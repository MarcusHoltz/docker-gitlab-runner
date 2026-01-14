# ============================================================================
# GitLab Omnibus Configuration
# This file is Ruby code that gets executed by GitLab
# Please make edits in the .env file or in the ./secrets folder
# Docs: https://docs.gitlab.com/install/docker/installation/#install-gitlab-by-using-docker-compose
# ============================================================================

# ============================================================================
# External URL - the main frontend connection - how users will access GitLab
# ============================================================================
# Note: Do NOT use '=' sign here! NO = after external_url
external_url "https://#{ENV['GITLAB_SUBDOMAIN']}.#{ENV['DOMAIN_NAME']}"

# ============================================================================
# INITIAL ROOT USER (First Boot Only)
# ============================================================================
gitlab_rails['initial_root_password'] = File.read('/run/secrets/gitlab_root_password').gsub("\n", "")

# ============================================================================
# SSL CONFIGURATION
# ============================================================================
nginx['ssl_certificate'] = "/etc/letsencrypt/live/#{ENV['DOMAIN_NAME']}/fullchain.pem"
nginx['ssl_certificate_key'] = "/etc/letsencrypt/live/#{ENV['DOMAIN_NAME']}/privkey.pem"

letsencrypt['enable'] = (ENV['LETSENCRYPT_ENABLED'] == 'true')

# ============================================================================
# NETWORK SECURITY
# ============================================================================
gitlab_rails['trusted_proxies'] = ENV['TRUSTED_PROXIES'].split(',').map(&:strip)

gitlab_rails['monitoring_whitelist'] = ENV['MONITORING_WHITELIST'].split(',').map(&:strip)
gitlab_rails['allowed_hosts'] = ENV['ALLOWED_HOSTS'].split(',').map(&:strip)

nginx['listen_port'] = 443
nginx['listen_https'] = true

# ============================================================================
# SSH CONFIGURATION
# ============================================================================
gitlab_rails['gitlab_shell_ssh_port'] = ENV['GITLAB_SSH_PORT'].to_i

# ============================================================================
# PUMA WEB SERVER
# ============================================================================
puma['worker_processes'] = ENV['PUMA_WORKER_PROCESSES'].to_i
puma['worker_timeout'] = ENV['PUMA_WORKER_TIMEOUT'].to_i
puma['per_worker_max_memory_mb'] = ENV['PUMA_WORKER_MAXMEM'].to_i
puma['listen'] = '0.0.0.0'
puma['port'] = 8080

# ============================================================================
# POSTGRESQL DATABASE
# ============================================================================
postgresql['shared_buffers'] = ENV['POSTGRESQL_SHARED_BUFFERS']

# ============================================================================
# SIDEKIQ BACKGROUND JOBS
# ============================================================================
sidekiq['max_concurrency'] = ENV['SIDEKIQ_MAX_CONCURRENCY'].to_i
sidekiq['concurrency'] = ENV['SIDEKIQ_CONCURRENCY'].to_i

# ============================================================================
# GITLAB WORKHORSE
# ============================================================================
gitlab_workhorse['listen_network'] = 'tcp'
gitlab_workhorse['listen_addr'] = ENV['WORKHORSE_LISTEN_ADDR']
gitlab_workhorse['auth_backend'] = 'http://localhost:8080'
gitlab_workhorse['api_limit_per_min'] = 0
gitlab_workhorse['api_queue_limit'] = 0
gitlab_workhorse['api_queue_duration'] = '30s'

# ============================================================================
# FEATURE TOGGLES
# ============================================================================
prometheus_monitoring['enable'] = (ENV['PROMETHEUS_ENABLED'] == 'true')

gitlab_pages['enable'] = (ENV['GITLAB_PAGES_ENABLED'] == 'true')

# ============================================================================
# UI PREFERENCES
# ============================================================================
gitlab_rails['gitlab_default_theme'] = ENV['GITLAB_DEFAULT_THEME'].to_i
gitlab_rails['gitlab_default_color_mode'] = ENV['GITLAB_DEFAULT_COLOR_MODE']

# ============================================================================
# TELEMETRY
# ============================================================================
gitlab_rails['usage_ping_enabled'] = (ENV['DISABLE_USAGE_DATA'] != 'true')
