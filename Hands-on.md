# Workshop Hands-On

The Workshop makes use of the University of Florida's [HiPerGator](https://rc.ufl.edu) computer cluster. The computational requirements for analyzing the examples are not large and could be done on your own computer. However, we do skip a few steps and processing many files is often best done on a computer cluster. If you run this on your own computer, you will need to install the R libraries and [LASTools](http://lastools.org/) software on your computer and adjust paths. We have tried to use relative paths as much as possible, though some paths will need to be updated.

For the workshop, each user will use a temporary account to access HiPerGator resources. You will be given a slip of paper with the username and password to use. Even if you have your own HiPerGator account, it would be best to use the one for the workshop to ensure that you have access to some of the files and applications stored in the workshop folder. The temporary accounts will be deleted shortly after the workshop.

## Step 1: Login to Open On Demand
For the workshop, we will be using the Open-on-Demand interface to get a terminal window and a Rstudio window as we work through the exercises.

In your web browser, go to https://ood.rc.ufl.edu/ 
**Note:** You need to be on the UF network to reach this site. Please use the eduroam WiFi network or connect with UF VPN.

Hopefully we won't need this...

When you get to the GatorLink login screen, **log in with the temporary account provided to you**. Do not login with your own GatorLink account as you will not have access to the needed resources.

> **Hopefully we don't need this section:** It may be the case OOD becomes overloaded during the workshop, if that happens, [here is another method that will connect you to Rstudio](https://help.rc.ufl.edu/doc/GUI_Programs#RC_GUI-2.0). The commands needed would be  `module load gui/2; gui start -e rstudio -c 1 -m 2 -t 2` and `gui show` to get the connection URL.

## Step 2: Use shell to clone repository

From the Clusters menu, select HiPerGator Shell Access
![Screenshot of Clusters > HiPerGator Shell Access](images/shell_access.png)

This will open a new window with a Linux terminal on HiPerGator. 

For this step, we will use some Linux commands to make a clone of this repository in your directory on the cluster.

Users should store data in their /ufrc directory, so the first thing to do is change directories from your home directory to your /ufrc directory located at `/ufrc/general_workshop/gatorlink` (replace *gatorlink* with your temporary GatorLink account name, in the documentation here, I'll use user123).

Once in your user's /ufrc/general_workshop directory, clone this repository. Here are the commands to use for these steps.

```bash
[user123@login1 ~]$ cd /ufrc/general_workshop/user123/
[user123@login1 user123]$ git clone https://github.com/UFResearchComputing/PlantSci_BigData.git
Cloning into 'PlantSci_BigData'...
remote: Enumerating objects: 30, done.
remote: Counting objects: 100% (30/30), done.
remote: Compressing objects: 100% (21/21), done.
remote: Total 269 (delta 11), reused 24 (delta 9), pack-reused 239
Receiving objects: 100% (269/269), 85.19 MiB | 5.33 MiB/s, done.
Resolving deltas: 100% (105/105), done.
[user123@login1 user123]$ 
```

## Step 3: Open Rstudio

Now that we have a copy of the files for the workshop in your /ufrc/general_workshop directory, we can launch Rstudio and start working with the data.

Go back to the main OOD tab (leave the terminal open, we'll use this later).

From the Interactive Apps menu, select Rstudio. ![Screenshot of Interactive Apps menu](images/launch_rstudio.png)

The screen that comes up after that allows you to select the resources needed for your Rstudio session. This is one way to schedule a job on the cluster and allows you to tell the SLURM scheduler information about the processors (CPUs), memory, time and other information about your job. 

**For our purposes, you can leave this with the default settings and scroll all the way to the botton and click Launch.**

That will submit your job to the scheduler and wait for it to start up. Wait a minute or so and the box should look something like this, with a **Launch Rstudio** button. ![Screenshot of connecting to running Rstudio job](images/launch_rstudio_window.png)

This will open a new browser window with Rstudio running on the cluster. This allows you to run a graphical, interactive Rstudio session, using the storage and compute resources of HiPerGator.

## Step 4: Run 01_Select_Generate_Shapefile.R

Now that we have Rstudio running, we need to open the first script from the repository we cloned in step 2 above.

In the right-hand side of the Files section of Rstudio, click on the three dots (highlighted in screenshot).  ![Screenshot of opening the file navigator in Rstudio](images/Rstudio_file_navigate.png)

In the Directories box at the bottom of the window, type in /ufrc/general_workshop/gatorlink, using your temporary gatorlink id. ![Screenshot of navigating to directory](images/Rstudio_directory.png)

The file is in PlantSci_BigData/Workshop/01_Select_Generate_Shapefile.R

Once the file is open, set this folder (/ufrc/general_workshop/user123/PlantSci_BigData/Workshop) as the working directory for R using the Gear More menu in the Files pane and selecting Set Working Directory.
![Sreenshot of setting working directory](images/Rstudio_setwd.png)

Now that the 01_Select_Generate_Shapefile.R script is loaded and the working directory is set to`/ufrc/general_workshop/user123/PlantSci_BigData/Workshop`, we can run the script but clicking on the Source button. ![Screenshot of Rstudio source button](images/Rstudio_source.png)

As part of running this script, you will need to select four points to create a bounding box around the field you want to study. While you will click and Rstudio will show the four points, **for the workshop, we force a bounding box that is the same for all users**. So, the bounding box will not correspond to the points you select, bit is set in the code. There are several lines in the R code that are noted as being set to ensure consistent results for the workshop. If you want to try the code as it would be run with real analyses, comment out those lines.

## [Continue in part 2 of the Hands-on](Hands-on_part2.md)
