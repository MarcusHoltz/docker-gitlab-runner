# Gitlab Up and Running on Docker with Runners and TLS with a CI/CD pipeline project

![GitLab Omnibus and Runners can be a pain, get your own self-hosted DevOps platform running in this guide](https://raw.githubusercontent.com/MarcusHoltz/marcusholtz.github.io/main/assets/img/header/header--gitlab--self-hosted-deployment-stack.jpg)

GitLab Omnibus is a massive "all-in-one" platform that bundles databases, web servers, and task runners into a single package.

Getting your own self-hosted DevSecOps platform running doesn't have to be a headache. 

This guide will get you a professional-grade **GitLab CE** instance, secured with **TLS (HTTPS)** via Traefik, a pre-configured **GitLab Runner**, and a **CI/CD pipeline** project, in under 15 minutes.


* * *

## The Architecture at a Glance

Before we dive in, here is how the traffic flows through your stack:

- **Traefik:** Acts as the traffic cop, handling SSL termination and routing.

- **Certbot:** Automatically fetches Wildcard certificates via Cloudflare DNS.

- **GitLab CE:** The core application, running on an internal Docker network.

- **GitLab Runner:** Automatically registers itself to your instance using a helper script.

- **WeatherCICD:** This is the gitlab-ci.yml pipeline that we will run once the project is complete.


* * *

## 1). Configure the Project Environment to Your Requirements

You need to tell the stack a few details. 

- `./certbot/cloudflare.ini` - This file tells Certbot your Cloudflare API Token for DNS-01

- `./secrets/gitlab_root_password.txt` - This file contains our intial password to login to GitLab as root

- `.env` - The `.env` file is where we place every other non-secret value. It contains all the customization within our script.


* * *

### Edit ./certbot/cloudflare.ini

The first step is to leave this write-up and go to another website.

Cloudflare can provide a nameserver for almost any domain, allowing us to use Cloudflare's API to create temporary TXT records for SSL domain validation.

For help with creating a Token in Cloudflare, watch this [LinuxCloudHacks video](https://youtu.be/NziF6Srh-08?si=j6HHxMJCfz-hYkZp&t=388) for a quick how-to.

Once you have the token,

- Go inside the `cerbot` folder

- Edit the `cloudflare.ini` file

- Find `dns_cloudflare_api_token`

- Replace `YOUR_CLOUDFLARE_API_TOKEN_HERE` with your token

- Save and quit the file

> Ensure the token has "Zone:DNS:Edit" permissions for your domain.


* * *

### Edit ./secrets/gitlab_root_password.txt

To keep passwords secure, we will use Docker Secrets.

- Go inside the folder named `secrets`

- Edit a file inside called `gitlab_root_password.txt`
- You should see a placeholder password, `HEYOUchangeThisPassword`
- Remove that text and enter your password (your password should be the only text in the file)
- Save and quit the file

> Make sure to paste just your GitLab root password


* * *

### Edit .env

The .env file is were we store everything we want to configure in all of our files (outside of our secrets).

This allows us to make changes in one place throughout the entire project, but keep our keys, tokens, passwords, and secrets safe somewhere else.

- Open your `.env` file

- You must atleast update the following fields:
  - `DOMAIN_NAME`: Your domain (e.g., `example.com`).
  - `GITLAB_SUBDOMAIN`: Usually `gitlab`.
  - `GITLAB_HOST_IP`: The IP address of your Docker host running GitLab

- There are many more fields, change a few more and you may just break something - Good Luck!


* * *

## 2). Spin Up the Stack

With configuration complete, you can bring up the Docker compose project stack.

```bash
docker compose up -d
```


* * *

### What's happening?

* **Certbot** runs first to ensure your SSL certificates exist in `./appdata/certbot`.

* **Traefik** starts listening on ports 80 and 443, but will need rebooted to find the certificates.

* **GitLab** begins its boot sequence.


* * *

#### What can I do?

I would say, to let everything get everything settled, run this command and walk away:

`docker compose up -d && sleep 180 && docker compose up -d && sleep 270 && docker logs -f gitlab_ce`

> **GitLab is heavy.** It can take 5–10 minutes to fully initialize. You can monitor the progress with `docker logs -f gitlab_ce`.


* * *

#### Problems?

See the [Help section](#) at the end


* * *

## 3.) Runner Registration Script

Usually, registering a runner is a manual chore of copying tokens. I have automated this with the `register_gitlab_runner.sh` script.

Once GitLab is healthy (you can reach the login page), run:

```bash
register_gitlab_runner.sh
```

**What this script does for you:**

1. **Wait:** It polls the GitLab API until it's actually ready.
2. **Auth:** It enters the GitLab container and generates a temporary Personal Access Token.
3. **Register:** It fetches a Runner Registration Token and links the `gitlab-runner` container to your instance.
4. **Connect:** It configures the runner to use the Docker executor, allowing it to run CI/CD jobs.


* * *

### Login and Verify Runner

1. Navigate to `https://gitlab.yourdomain.com`.

2. Log in with username **root** and the password you put in your secrets file.

3. Go to **Admin Area > CI/CD > Runners**. You should see your `homelab-hybrid-runner` online and ready!


* * *

## 4). Your First Project















