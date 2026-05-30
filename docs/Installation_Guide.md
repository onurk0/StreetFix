## Development Setup

### Install Ruby on Rails & PostgreSQL for your machine:

> **TCNJ students using a VM:** 
Make sure that you have the correct version of Ruby and Rails installed on your VM by running the installruby.sh script, this is done by the following command:

    ./installruby.sh

The script only needs to be run once.  To check if it was successfully installed run the following to ensure that your VM has Ruby 4.0.1 and that the Rails command is recognized.

    ruby -v
    
    rails -v

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

### Installing dependencies

Now that you've cloned your repository, navigate to the `<repo_name>/src/` folder. This folder is where all the code files are located. (There's also a `<repo_name>/docs/` folder you may have noticed that should hold relevant project documents and diagrams). Here, in the src directory, you now have to install the project dependencies. Run the following commands:

`bundle install`

Go into your sysadmin account and run:

`sudo npm install -g yarn` and then,

`sudo -u postgres createuser -s student(n)` <-- replacing (n) with whatever student account you're setting up in

Logout, go back into your studentn account go into <repo_name>/src.

`bundle install`

### Create the databases and perform migration:

    rake db:create
    
    rake db:migrate
    
    rake db:seed

### Finally, run the app.
Find your VM’s ip address by running the command

`ip addr`

**Please see the instructions to set up the Virtual Machine Setup (given at the beginning of the semester) to review how to run the server. ** 

Run the server by running:

`rails server --binding=xxx.xxx.xxx.xxx`

Note that you won't be able to run the rails server unless you are in the `src` folder.

The app should be available in the browser at http://csc415-serverXX.hpc.tcnj.edu:3000/ 
Where XX is your server number.

Your Rails starter project has now been successfully created!  Please read through [this page](More_helpful_info.md) to view the gems that are already included to better understand the current project capabilities such as a premade login/registration functionality and an administrative portal.

### Pulling updates from the template

If the SE-Rails-Template is updated after you've already created your project, you can pull those changes into your own repo:

1. Add the template as a remote (only needed once):

        git remote add template git@github.com:TCNJ-SE/SE-Rails-Template.git

2. Fetch and pull the latest changes:

        git fetch template
        git pull template main

3. Resolve any merge conflicts, then run:

        cd src
        bundle install
        rake db:migrate

If you still encounter errors, make sure the PostgreSQL server has been started, or try to restart it.

  Starting the server (should already be configured to start automatically at boot-up):
  `sudo systemctl start postgresql`

  Restarting the server:
  `sudo systemctl restart postgresql-18`

> **TCNJ NOTE:** If issues continue, there's something wrong with your psql installation.

* Please run the following. `sudo yum install postgresql-libs postgresql-devel --nobest`

* If the errors still continue, look up the error you're receiving for more advice.

Once bundle install successfully completes you can begin to create the database.

### Note on the .gitignore file
If you have any files in your app with sensitive information, API keys, data files for your database, etc., make sure to add them to your `.gitignore` file so that those files are not published on GitHub for everyone to see. You can read more about what this file is and how to use it [here](.gitignore_Guide.md).
