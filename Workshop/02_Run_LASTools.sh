#!/bin/bash
#SBATCH --job-name=lastools        # Job name
#SBATCH --mail-type=END,FAIL       # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=ADD_YOUR_EMAIL # Where to send mail
#SBATCH --cpus-per-task=2          # Run on 2 CPUs
#SBATCH --mem=6gb                  # Job memory request
#SBATCH --time=0:15:00             # Time limit hrs:min:sec
#SBATCH --output=lastools_%j.log   # Standard output and error log

pwd; hostname; date

module load wine

# Set path to location of LASTools folder. For the workshop, this is at 
# ufrc/general_workshop/share. You will need to change this for your installation
# We are using the CLI version of LASTools.

LASTools_PATH=ufrc/general_workshop/share

############ ############ ############ ############ ############ ############ 
############ Clipping cleaned pointcloud to reduce computational time #######
############ ############ ############ ############ ############ ############ 

echo \n\nRunning lasclip
date 

wine $LASTools_PATH/LAStools-cli/bin/lasclip-cli.exe -i Data/20180622_cs_sony_corn_3dpc.las \
        -merged \
        -poly Outputs/Field_Mask.shp \
        -o  Processing/CS18-YYCI_06222018_FW_clip.laz \
        -oforce -cores 2


############ ############ ############ ############ ############ ############ 
############ Sorting clipped pointcloud to reduce computational time #######
############ ############ ############ ############ ############ ############ 

echo \n\nRunning lassort
date

wine $LASTools_PATH/LAStools-cli/bin/lassort-cli.exe -i Data/CS18-YYCI_06222018_FW.laz \
        -o Processing/CS18-YYCI_06222018_FW_clip_sort.laz \

############ ############ ############ ############ ############ ############ 
############ Removing further noise from pointcloud ############ ############
############ ############ ############ ############ ############ ############ 

echo \n\nRunning lasnoise
date 

wine $LASTools_PATH/LAStools-cli/bin/lasnoise-cli.exe -i Processing/CS18-YYCI_06222018_FW_clip_sort.laz \
         -step_xy 5 \
         -step_z .05 \
         -isolated 100 \
         -remove_noise \
         -o Processing/CS18-YYCI_06222018_FW_NREM.laz \
         -oforce -cores 2
 
############ ############ ############ ############ ############ ############ 
############ Using ATIN alogrithim to ifdentify ground points ## ############
############ ############ ############ ############ ############ ############ 

echo \n\nRunning lasground
date 

wine $LASTools_PATH/LAStools-cli/bin/lasground-cli.exe -i Processing/CS18-YYCI_06222018_FW_NREM.laz \
          -step 25 \
          -bulge 0 \
          -offset 0.2 \
          -spike 0.05 \
          -stddev 0 \
          -o Processing/GRND_CS18-YYCI_06222018_FW.laz \
          -oforce -cores 2 
 
############ ############ ############ ############ ############ ############ 
############ Identifying maximum points to model ground at peaks of rows ####
############ ############ ############ ############ ############ ############ 

echo \n\nRunning lasthin
date

wine $LASTools_PATH/LAStools-cli/bin/lasthin-cli.exe -i Processing/GRND_CS18-YYCI_06222018_FW.laz \
        -ignore_class 1 \
        -classify_as 8 \
        -step 0.5 \
        -highest \
        -o Processing/GRND_KP_CS18-YYCI_06222018_FW.laz \
        -olaz -oforce    


############ ############ ############ ############ ############ ############ 
############ Usinbg keypoints to model the ground, adjusting Z point ########
############ to above ground height estimates ##### ############ ############ 
############ ############ ############ ############ ############ ############ 

echo \n\nRunning lasheight
date

wine $LASTools_PATH/LAStools-cli/bin/lasheight-cli.exe -i Processing/GRND_KP_CS18-YYCI_06222018_FW.laz \
          -classification 8 \
          -scale_u 0.001 \
          -drop_below 0.1 \
          -drop_above 3.5 \
          -replace_z \
          -o Processing/HGT_CS18-YYCI_06222018_FW.las \
          -oforce
