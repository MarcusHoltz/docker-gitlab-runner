# Weather CI/CD Demo 🌤️

Welcome! This project demonstrates GitLab CI/CD pipelines with interactive user input.

* * *

## Getting Started

1. **Set up your API key**:
   - Get a free API key from [OpenWeatherMap](https://openweathermap.org/api)
   - Add it in **Settings → CI/CD → Variables**
   - Click **Add variable**
   - Enter the **Key** as `WEATHER_API_KEY`
   - Enter the **Value** as `Your API key`
   - Save changes

2. **Run your first pipeline**:
   - Go to **Build → Pipelines**
   - Click **New Pipeline**
   - Fill out the form with your desired location
   - Click **New Pipeline**

3. **Watch the magic happen**:
   - See real-time logs
   - Watch as nothing happens
   - The 'main' branch has manual builds
   - To fix: Make a new branch below
   - Or click: The stuck job card or **run** (play) button in your current pipeline

4. **Make a new Branch**:
   - To push a new README.md automatically to the repository
   - You need to make a new branch not named, 'main' or 'webdav'
   - Go to **Code → Branches**
   - Click **New Branch**
   - Fill out the form with your desired branch name **(be sure to 'create from' `main`)**
   - Click **Create Branch**

5. **Run a pipeline in a branch**:
   - Go to **Build → Pipelines**
   - Click **New Pipeline**
   - Look in the upper left hand corner of this form
   - **Run for branch name or tag**
   - Select the branch you made
   - Fill out the form with your desired location
   - Click **New Pipeline**

6. **Watch your README.md change**:
   - See real-time logs
   - Visit your README.md for the changes


---

## Current Status

No weather data yet. Run the pipeline to fetch current weather for any location!

---

*Ready to learn GitLab CI/CD? Run the pipeline in a new branch and see this README transform!*

---

## How This Pipeline Works

This pipeline demonstrates several GitLab CI/CD concepts:

### Core Features

1. **Pre-filled Variables** - User-friendly form with dropdowns and descriptions
2. **Manual Triggers** - Pipeline runs only when you manually trigger it
3. **Multiple Stages** - Validate → Fetch → Update
4. **Artifacts** - Data passes between stages via artifacts
5. **API Integration** - Fetches real weather data from OpenWeatherMap
6. **Git Operations** - Automatically commits updated README.md
7. **Branch & Tag Rules** - Different behavior based on branch/tag
8. **Deployment Methods** - Triggered from branch names


---

## Running the Pipeline Yourself

### Quick Start

#### Step 1: Set up your API key

* Get a free API key from [OpenWeatherMap](https://openweathermap.org/api).
* Go to **Settings → CI/CD → Variables**.
* Click **Add variable**.
* Enter **Key** as **WEATHER_API_KEY**
* Enter **Value** as **your API key.**
* Save changes.

#### Step 2: Run your first pipeline

* Go to **Build → Pipelines**.
* Click **New Pipeline**.
* Fill out the form with your desired location.
* Click **New Pipeline**.

#### Step 3: Watch the magic happen

* See real-time logs as the pipeline runs.
* Note that the **main** branch requires manual intervention.
* If the job is stuck, either create a new branch (see below) or click **run** on the stuck job.

#### Step 4: Create a new branch

* To push updates to **README.md** automatically, create a new branch (not **main** or **webdav**).
* Go to **Code → Branches**.
* Click **New Branch**, and make sure to create it from **main**.
* Click **Create Branch**.

#### Step 5: Run a pipeline in your new branch

* Go to **Build → Pipelines**.
* Click **New Pipeline**.
* In the form, look for **Run for branch name or tag**.
* Select the branch you created.
* Fill out the form with your desired location.
* Click **New Pipeline**.

#### Step 6: Watch your README.md change

* See real-time logs as the pipeline runs.
* Visit your **README.md** to see the changes.


---

## Learning More

There's more examples! Here's a brief tutorial that explains how to use the **webdav** branch to deploy to a WebDAV server.


### Deploying to a WebDAV Server Using the WebDAV Branch

* Make a new branch and name it webdav.
* Use the **webdav** branch for WebDAV file deployment.
* Set the necessary **WebDAV credentials** in the GitLab **Variables**, or edit the .gitlab-ci.yml file, or even add them when manually running.
* Confirm the correct input values for the WebDAV job, trigger the pipeline, and watch as your production files are uploaded.


#### Step 1: Set up your WebDAV credentials

* Go to **Settings → CI/CD → Variables**.
* Add the following variables:

  * **WEBDAV_URL**: The URL of your WebDAV server (e.g., https://your-webdav-server.com/remote.php/webdav).
  * **WEBDAV_USERNAME**: Your WebDAV username.
  * **WEBDAV_PASSWORD**: Your WebDAV password.
* Save changes.

#### Step 2: Switch to the webdav branch

* Go to **Code → Branches**.
* Switch to the **webdav** branch. If it doesn't exist, create it from main.

#### Step 3: Run the pipeline

* Go to **Build → Pipelines**.
* Click **New Pipeline**.
* Select **webdav** as the branch.
* Fill out the form with the **LOCATION** (e.g., "Paris, France").
* Click **Run Pipeline**.

#### Step 4: Enter manual job inputs

* When prompted, enter the following values:

  * **WEBDAV_URL**: Make sure it’s the correct WebDAV server URL.
  * **WEBDAV_USERNAME**: Your WebDAV username.
  * **WEBDAV_PASSWORD**: Your WebDAV password.
  * **WEBDAV_DEPLOY_DIRECTORY**: The directory on the WebDAV server where files will be uploaded (e.g., /var/www/production).
* Click **Run** to start the deployment.

#### Step 5: Watch the deployment

* View real-time logs as the pipeline runs.
* The README.md file will be uploaded to the specified **WebDAV server**.


---

### Additional Infomation

Explore these GitLab CI/CD concepts in this project:

- **Variables**: Check out the pre-filled variable definitions in `.gitlab-ci.yml`
- **Rules**: See how jobs run conditionally based on branches and tags
- **Artifacts**: Notice how data flows between stages
- **Branch-specific jobs**: Try creating a `feature/` branch and pushing
- **Tag-based releases**: Create a tag like `v1.0.0` to trigger release jobs

### Project Structure

```
WeatherCICD/
├── .gitlab-ci.yml           # Pipeline configuration
├── validate_location.py     # Location validation script
├── fetch_weather.py         # Weather API integration
├── update_readme.sh         # README update script
└── README.md               # This file (auto-updated!)
```


### Pipeline Stages

```
┌─────────────────────────────────────────────┐
│  VALIDATE                                   │
│  └─ validate_location                       │
│      • Geocodes location                    │
│      • Saves coordinates                    │
│                                             │
│  ↓ (passes validated_location.txt)          │
│                                             │
│  FETCH                                      │
│  └─ fetch_weather                           │
│      • Calls OpenWeatherMap API             │
│      • Retrieves temperature & conditions   │
│                                             │
│  ↓ (passes weather_data.txt)                │
│                                             │
│  UPDATE                                     │
│  └─ update_readme                           │
│      • Formats weather data                 │
│      • Commits to repository                │
└─────────────────────────────────────────────┘
```


### Troubleshooting

**Pipeline fails at validate_location:**
- Check your location spelling
- Try format: "City, Country"

**Pipeline fails at fetch_weather:**
- Verify `WEATHER_API_KEY` is set in project variables
- Check if your API key is active (can take a few minutes)

**README not updating:**
- Ensure you have permissions to push to the repository
- Check Settings → CI/CD → Job token permissions

