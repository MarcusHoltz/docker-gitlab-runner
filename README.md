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

## Step 1: Prepare Your Environment

You need to tell the stack who you are. The `.env` file is your single source of truth.

1. **Configure `.env`:** Open your `.env` file and update these key fields:
* `DOMAIN_NAME`: Your domain (e.g., `example.com`).
* `GITLAB_SUBDOMAIN`: Usually `gitlab`.
* `ACME_EMAIL`: Your email for Let's Encrypt alerts.


2. **Set the Root Password:** To keep things secure, we use Docker Secrets.
* Create a folder named `secrets`.
* Create a file inside called `gitlab_root_password.txt` and paste your desired admin password there.

