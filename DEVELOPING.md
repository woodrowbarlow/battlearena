# Developer's Guide

This game is made with Game Maker Studio, but does not work well with GMS's built-in SVN-based VCS, so you should manage the repository manually. Also, don't commit code while Game Maker is running. Save and exit GameMaker, commit and push your code, then re-open the project and continue working (otherwise Game Make thinks all the files have disappeared and starts flipping out).

## First-Time Setup

1. Install [Git](http://git-scm.com/). The default installation settings should be fine.
2. Create a folder somewhere where you want to store all your git projects.
3. Open up that folder in Windows Explorer, then right click somewhere and choose "Open Git Bash Here".
4. Now you need to identify yourself to Git. Execute the following commands, and make sure to use your own email and name instead of mine.
    * `git config --global user.email wjbarlow@ncsu.edu`
    * `git config --global user.name "Woodrow Barlow"`
5. Now download the repo. This time, don't change my name to yours, since the repo is under my account.
    * `git clone https://github.com/woodrowbarlow/battlearena`
6. In your Windows Explorer window, you should now see a new folder called "battlearena". Open it then double click the project file to launch Game Maker.

## Typical Workflow

1. Before you start working, check to see if anyone else has submitted any work and, if so, download it.
    * Open the "battlearena" folder in Windows Explorer. Right click somewhere and choose "Open Git Bash Here".
    * `git pull`
2. Open the project in Game Maker and work on it.
3. Save your changes and exit Game Maker.
4. Once more, check to see if anyone else has submitted any work and, if so, download it. This prevents history conflicts. Then, submit your changes.
    * Open the "battlearena" folder in Windows Explorer. Right click somewhere and choose "Open Git Bash Here".
    * `git pull`
    * `git add .`
    * `git commit -m "type a brief commit message here"`
    * `git push`

Occassionally, you'll come across a merge conflict. This happens when somebody submitted a change to a file that you were working on while you were working on it. If that happens, you'll have to resolve it manually by telling Git which of the conflicting parts to use.