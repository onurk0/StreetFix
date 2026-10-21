## Development Setup

### Install Docker:

Ruby, Rails, all gems and PostgreSQL are provided by the `Dockerfile` in the root of
the repository, so nothing else needs to be installed on your machine besides Git and
Docker (or Podman).

Install Docker by following the official instructions on the Docker website:
<https://docs.docker.com/get-started/get-docker/>

* **Windows / macOS:** download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/), then start it. Step-by-step guides: [Windows](https://docs.docker.com/desktop/setup/install/windows-install/), [macOS](https://docs.docker.com/desktop/setup/install/mac-install/).
* **Linux (including the course VMs):** pick your distribution on <https://docs.docker.com/engine/install/> and follow the "Install using the repository" steps. For example, on a RHEL-based VM use <https://docs.docker.com/engine/install/rhel/>, on Ubuntu use <https://docs.docker.com/engine/install/ubuntu/>.
  Then complete the [Linux post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/) so you can run `docker` without `sudo`, and log out and back in for the group change to take effect.

Check that Docker works by running:

    docker --version
    docker run --rm hello-world

### Install this repository: 
> Students **MUST** use this template, PLEASE BE SURE to click **USE THIS TEMPLATE** on the top of the repository before you clone it (DO NOT FORK). 
1. Click the `Use this template` option at the top of this project page on GitHub (<https://github.com/TCNJ-SE/SE-Rails-Template>).
2. Choose TCNJ-SE from the **Owner** dropdown.
3. When entering a name, follow this naming convention: `S26-FML-Project`. Replace FML with the initials of your First name, Middle name and Last name. Replace Project with the shortened name of the project
4. Choose the `Private` option.
5. You do not need to include all branches.
6. Click `Create repository from template`  

Once your new project is created, you'll need to clone it to get a local copy of all the files. We're going to use SSH to clone the project, which requires having an SSH key set up with your GitHub account. That whole process is explained in this page: [Setting up SSH keys with GitHub](Setting_up_SSH_keys_GitHub.md).

If you already have an SSH key set up, here is how to clone this repo:

1. On the GitHub website, on your repository page, select the "Code" dropdown at the top of the page. Make sure to select "SSH" and not "HTTPS". Click the little clipboard to the right of the provided url to copy it.
2. Now, return to your terminal and enter the following command: `git clone <copied url>` (exclude the '<' and '>')
3. If you are told that the authenticity of the host 'github.com' can't be established, and asked if you want to continue connecting, enter "yes".
4. You'll be prompted to enter the passphrase you made earlier for your SSH key. After you enter that, the repository will be cloned to your VM.

### Building and running the app

Now that you've cloned your repository, go into the `<repo_name>/` folder (the one containing the `Dockerfile`). The code lives in `<repo_name>/src/`, and there's also a `<repo_name>/docs/` folder for project documents and diagrams.

Build the image (installs Ruby 4.0.1, Rails, all gems and PostgreSQL):

    docker build -t streetfix .

Run the app. The first start creates, migrates and seeds the database automatically, and the `streetfix-db` volume keeps the data between runs:

    docker run --rm -p 3000:3000 -v streetfix-db:/var/lib/postgresql/data streetfix

The app is then available in the browser at http://localhost:3000/ (or, on a server, at `http://<server-address>:3000/`).

To run any other Rails command, put it after the image name, for example:

    docker run --rm -v streetfix-db:/var/lib/postgresql/data streetfix bin/rails db:migrate

Your Rails starter project has now been successfully created!  Please read through [this page](More_helpful_info.md) to view the gems that are already included to better understand the current project capabilities such as a premade login/registration functionality and an administrative portal.

### Pulling updates from the template

If the SE-Rails-Template is updated after you've already created your project, you can pull those changes into your own repo:

1. Add the template as a remote (only needed once):

        git remote add template git@github.com:TCNJ-SE/SE-Rails-Template.git

2. Fetch and pull the latest changes:

        git fetch template
        git pull template main

3. Resolve any merge conflicts, then rebuild the image (pending migrations run automatically when the container starts):

        docker build -t streetfix .

### Note on the .gitignore file
If you have any files in your app with sensitive information, API keys, data files for your database, etc., make sure to add them to the `.gitignore` file in the root of the repository so that those files are not published on GitHub for everyone to see. You can read more about what this file is and how to use it [here](.gitignore_Guide.md).
