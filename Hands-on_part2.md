# Workshop Hands-On Part 2

## [Continued from Part 1 of the Hands-on](Hands-on.md)

## Step 5: Running LASTools

Now that we have setup the region to analyze, we are going to use LASTools to run the portion of the pipeline that does the LiDAR processing.

This part of the pipeline uses command-line driven applications. While this can be done from within Rstudio (e.g. `system LAStools/bin lasclip -i 20180622_cs_sony_corn_3dpc.las -merged -poly Outputs/Field_Mask.shp
-o Processing/CS18-YYCI_06222018_FW_clip.laz -oforce -cores 2`), I have written this as a Bash script with SLURM #SBATCH commands to submit the job to the scheduler. This gives you anther view of how applications can be run on the cluster. This is also a more common way to submit and process large batches of jobs, so important to understand some details of.

To run the second part of the processing pipeline, let's go back to the Terminal tab we opened earlier (you can leave the Rstudio tab open too).

Change directories into the Workshop folder: The `pwd` command below shows where you likely left off earlier. Then the `cd` command changes to the Workshop directory in the PlantSci_BigData directory.

```bash
[user123@login1 user123]$ pwd
/ufrc/general_workshop/user123
[user123@login1 user123]$ cd PlantSci_BigData/Workshop/
[user123@login1 Workshop]
```

The 02_Run_LASTools.sh file is a SLURM submission script that will provide information for the scheduler about the resources needed to run the analysis and then the commands needed to do the analysis. In this workshop, we are using the command-line version of LASTools. It is unlicensed, so the results will have intentionally introduced noise. Also, LASTools is not available for Linux, so we are using it with [Wine](https://www.winehq.org/).

You can edit the script to send you e-mail using the nano text editor: `nano 02_Run_LASTools.sh` and then change the 4th line where it says "--mail-user=ADD_YOUR_EMAIL" to add your email.  Control-X will exit, nano will ask if you want to save (Y) and then what filename to use (Enter keeps the same name).

To run this script, submit it to the scheduler with the command: **`sbatch 02_Run_LASTools.sh`**

That only takes a minute or two to run. So we can go back to Rstudio.

## Step 6: Looking at the LASTools results

The R script 03_Post_LASTools.R takes the output from LASTools and plots some correlations.

Open 03_Post_LASTools.R and click Source.

# Step 7: Genome Wide Association Study (GWAS)

This last script, 04_GAPIT_GWAS.R runs the [GAPIT](https://www.maizegenetics.net/gapit) R library to conduct the GAWS.

Open 04_GAPIT_GWAS.R and click Source.
