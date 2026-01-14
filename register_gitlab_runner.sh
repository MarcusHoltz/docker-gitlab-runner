#!/bin/bash
# ============================================================================
# register_gitlab_runner.sh - AUTOMATED CI/CD REGISTRATION
# ============================================================================
# Documentation: https://docs.gitlab.com/runner/register/
# Purpose: Programmatically links the Runner container to the GitLab instance.

# --- [ 1. ENVIRONMENT INITIALIZATION ] ---
set -e # Exit immediately if a command exits with a non-zero status.

# Description: Load the global configuration safely.
if [ -f .env ]; then
    echo "Loading configuration from .env..."
    # 'set -a' tells Bash to automatically export any variable defined in the sourced file.
    # This natively handles the comments and quotes in your specific .env file.
    set -a
    source .env
    set +a
else
    echo "Error: .env file not found. Please create it first."
    exit 1
fi

# --- [ 2. PRE-FLIGHT CONNECTIVITY CHECK ] ---
# Description: Wait for GitLab's NGINX to be ready before attempting API calls.
echo "Waiting for GitLab (https://${GITLAB_SUBDOMAIN}.${DOMAIN_NAME}) to boot..."
until curl -s -k -o /dev/null --header "Host: ${GITLAB_SUBDOMAIN}.${DOMAIN_NAME}" "https://127.0.0.1/-/health"; do
    printf '.' # Print a dot for every failed heartbeat.
    sleep 5    # Wait 5 seconds between checks to avoid CPU spikes.
done
echo -e "\nGitLab is UP!"

# --- [ 3. PROGRAMMATIC PAT GENERATION ] ---
# Description: Execute Ruby code inside the GitLab container to create an API token.
echo "Generating temporary Personal Access Token (PAT)..."
PAT_TOKEN=$(date +%s | sha256sum | head -c 30) # Generate a random 30-character string.

# Executing Rails Runner to insert the token directly into the database.
docker exec -i gitlab_ce gitlab-rails runner "
  user = User.find_by_username('root');
  token = user.personal_access_tokens.create(
    scopes: ['create_runner'],
    name: 'auto-registration-script',
    expires_at: 1.days.from_now
  );
  token.set_token('${PAT_TOKEN}');
  token.save!;
"

# --- [ 4. REQUEST RUNNER AUTHENTICATION TOKEN ] ---
# Description: Exchange the PAT for a specific Runner Registration Token via the API.
echo "Fetching Runner Token from API..."
RESPONSE=$(curl -s -k --request POST \
  --header "PRIVATE-TOKEN: ${PAT_TOKEN}" \
  --header "Host: ${GITLAB_SUBDOMAIN}.${DOMAIN_NAME}" \
  --data "runner_type=instance_type" \
  --data "description=${RUNNER_NAME}" \
  --url "https://127.0.0.1/api/v4/user/runners")

# Parsing logic (No jq):
# 1. grep -o finds the specific pattern "token":"value"
# 2. cut -d'"' splits by quote (") and grabs the 4th element (the actual value)
RUNNER_TOKEN=$(echo $RESPONSE | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

# SAFETY CHECK: Ensure we actually got a token before proceeding
if [ -z "$RUNNER_TOKEN" ]; then
    echo "Error: Failed to retrieve Runner Token."
    echo "API Response: $RESPONSE"
    exit 1
fi

# --- [ 5. RUNNER REGISTRATION ] ---
# Description: Configure the Runner container to execute jobs on the host's Docker engine.
echo "Registering Runner with Executor: docker..."
docker exec -i gitlab_runner gitlab-runner register \
  --non-interactive \
  --url "https://${GITLAB_SUBDOMAIN}.${DOMAIN_NAME}" \
  --token "${RUNNER_TOKEN}" \
  --executor "docker" \
  --docker-image "docker:stable" \
  --description "${RUNNER_NAME}" \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
  --docker-network-mode "${DOCKER_NETWORK_NAME}"

# --- [ 6. FINALIZATION ] ---
# Description: Restart the runner to ensure the new config.toml is loaded into memory.
echo "Restarting Runner container..."
docker restart gitlab_runner

echo "----------------------------------------------------"
echo "Registration Complete for: ${RUNNER_NAME}"
echo "Network Mode: ${DOCKER_NETWORK_NAME}"
echo "----------------------------------------------------"
