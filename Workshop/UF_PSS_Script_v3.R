
# Author Steven Anderson
# This is the original version of the script, designed to run on a local Windows computer
# For the workshop, we divided this into parts and split the LASTools into a bash script.
# Using this script will require installation of R packages and LASTools
# As with the workshop dataset, the Large files need to be downloaded separately and added to the appropriate paths.
# See the README.md of the main repo for the links to the large files.

install.packages("devtools")
install.packages("sp")
install.packages("raster")
install.packages("rgdal")
install.packages("lidR")
install.packages("lme4")

library("sp")
library("raster")
library("rgdal")
library('lidR')


############# GAPIT INSTALL ################
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install()

#Then Install the packages in RStudio from the BiocManager source
BiocManager::install("multtest",ask=F)
BiocManager::install("gplots",ask=F)
BiocManager::install("ape",ask=F)
BiocManager::install("LDheatmap",ask=F)
BiocManager::install("genetics",ask=F)
BiocManager::install("EMMREML",ask=F)
BiocManager::install("scatterplot3d",ask=F)  #The downloaded link at:  http://cran.r-project.org/package=scatterplot3d
BiocManager::install("qvalue",ask=F)

# source("http://www.bioconductor.org/biocLite.R")
# biocLite("multtest")
# install.packages("gplots")
# install.packages("LDheatmap")
# install.packages("genetics")
# install.packages("ape")
# install.packages("EMMREML")
# install.packages("scatterplot3d")

library(multtest)
library(gplots)
library(LDheatmap)
library(genetics)
library(ape)
library(EMMREML)
library(compiler) #this library is already installed in R
library("scatterplot3d")

source("http://zzlab.net/GAPIT/gapit_functions.txt")
source("http://zzlab.net/GAPIT/emma.txt")


setwd("C://Workshop")

############ ############ ############ ############ 
############ Load and Visualize Mosaic ############ 
############ ############ ############ ############ 

mosaic<-stack("C://Workshop//Data//20180622_cs_sony_corn_mosaic.tif")
plotRGB(mosaic, r = 1, g = 2, b = 3)

######### Creating field mask polygon to clip pointcloud. ######### 
field_mask<-data.frame()
for (i in 1:4){
  x<-locator(type = "p",n=1,col="red",pch=19)
  field_mask<-rbind(field_mask,x)
}

field_mask<-rbind(field_mask,field_mask[1,])

############ ############ ############ ############ ############ ############ 
############ This data is for consistant results in the workshop ############ 
############ ############ ############ ############ ############ ############ 

field_mask<-data.frame(x=c(746116.6,746236.6,746277.6,746153.4,746116.6),y=c(3382133,3382264,3382230,3382094,3382133))
# 
## field_mask
##   x       y
## 1 746116.6 3382133
## 2 746236.6 3382264
## 3 746277.6 3382230
## 4 746153.4 3382094
## 5 746116.6 3382133

############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 


############ ############ ############ ############ ############ ############ 
############ Clipping mmosic to improve point acuracy ########## ############  
############ ############ ############ ############ ############ ############ 

lines(field_mask, col= "red", type="l", lty=2, lwd=3)

field_mask_poly <- Polygons(list(Polygon(field_mask)), "x")
field_mask_poly_df <- SpatialPolygonsDataFrame( SpatialPolygons(list(field_mask_poly)), data.frame( z=1, row.names=c("x") ) )
projection(field_mask_poly_df) <- projection(mosaic)

r <- crop(x = mosaic, y = field_mask_poly_df)
plotRGB(r, r = 1, g = 2, b = 3)

############  ############  ############  ############  ############  ############ 
############ REPEAT LINES 22-57  ############  ############  ############  #######
############  The Purpose is to further fine tune the field mask  ################
############  ############  ############  ############  ############  ############ 

field_mask<-data.frame()
for (i in 1:4){
  x<-locator(type = "p",n=1,col="red",pch=19)
  field_mask<-rbind(field_mask,x)
}

field_mask<-rbind(field_mask,field_mask[1,])



############ ############ ############ ############ ############ ############ 
############ This data is for consistant results in the workshop ############ 
############ ############ ############ ############ ############ ############ 

field_mask<-data.frame(x=c(746126.5,746239.5,746264.5,746152.3,746126.5),y=c(3382133,3382254,3382232,3382110,3382133))
# 
## field_mask
##   x       y
## 1 746126.5 3382133
## 2 746239.5 3382254
## 3 746264.5 3382232
## 4 746152.3 3382110
## 5 746126.5 3382133

############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 

lines(field_mask, col= "red", type="l", lty=2, lwd=3)

field_mask_poly <- Polygons(list(Polygon(field_mask)), "x")
field_mask_poly_df <- SpatialPolygonsDataFrame( SpatialPolygons(list(field_mask_poly)), data.frame( z=1, row.names=c("x") ) )
projection(field_mask_poly_df) <- projection(mosaic)

r2 <- crop(x = r, y = field_mask_poly_df)
plotRGB(r2, r = 1, g = 2, b = 3)

############  ############  ############  ############  ############ 
############ Saving the final field mask as a shapefile  ###########
############  ############  ############  ############  ############ 

# ?writeOGR
writeOGR(field_mask_poly_df,
         "C://Workshop//Outputs//Field_Mask.shp",
         "Population1",
         verbose = TRUE,
         overwrite_layer = T,
         driver="ESRI Shapefile")


############  ############  ############  ############  ############  ############ 
############ Defining the coordinates for point A of the AB line used  ###########
############ plot level polygon shapefiles.  ############  ############  #########
############  ############  ############  ############  ############  ############ 

A_mask<-data.frame()
for (i in 1:4){
  x<-locator(type = "p",n=1,col="red",pch=19)
  A_mask<-rbind(A_mask,x)
}

A_mask<-rbind(A_mask,A_mask[1,])


############ ############ ############ ############ ############ ############ 
############ This data is for consistant results in the workshop ############ 
############ ############ ############ ############ ############ ############ 

A_mask<-data.frame(x=c(746142.0,746148.0,746154.7,746148.0,746142.0),y=c(3382150,3382143,3382150,3382155,3382150))


## print(A_mask)
## field_mask
## x       y
## 1 746116.6 3382133
## 2 746236.6 3382264
## 3 746277.6 3382230
## 4 746153.4 3382094
## 5 746116.6 3382133

############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 

lines(A_mask, col= "red", type="l", lty=2, lwd=3)

A_mask_poly <- Polygons(list(Polygon(A_mask)), "x")
A_mask_poly_df <- SpatialPolygonsDataFrame( SpatialPolygons(list(A_mask_poly)), data.frame( z=1, row.names=c("x") ) )
projection(A_mask_poly_df) <- projection(mosaic)

A <- crop(x = r2, y = A_mask_poly_df)
plotRGB(A, r = 1, g = 2, b = 3)


A_cords<-locator(type = "p",n=1,col="red",pch=19)
A_cords<-c(A_cords$x,A_cords$y)

############ ############ ############ ############ ############ ############ 
############ This data is for consistant results in the workshop ############ 
############ ############ ############ ############ ############ ############ 

A_cords<-c(746146.348,3382149.835)

############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 

############  ############  ############  ############  ############  ############ 
############ Defining the coordinates for point B of the AB line used  ###########
############ plot level polygon shapefiles.  ############  ############  #########
############  ############  ############  ############  ############  ############ 

plotRGB(r2, r = 1, g = 2, b = 3)

B_mask<-data.frame()
for (i in 1:4){
  x<-locator(type = "p",n=1,col="red",pch=19)
  B_mask<-rbind(B_mask,x)
}

B_mask<-rbind(B_mask,B_mask[1,])

############ ############ ############ ############ ############ ############ 
############ This data is for consistant results in the workshop ############ 
############ ############ ############ ############ ############ ############ 

B_mask<-data.frame(x=c(746227.5,746236.6,746227.5,746218.8,746227.5),y=c(3382242,3382234,3382226,3382232,3382242))


# print(B_mask)
# x       y
# 1 746142.0 3382150
# 2 746148.0 3382143
# 3 746154.7 3382150
# 4 746148.0 3382155
# 5 746142.0 3382150

############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 


lines(B_mask, col= "red", type="l", lty=2, lwd=3)

B_mask_poly <- Polygons(list(Polygon(B_mask)), "x")
B_mask_poly_df <- SpatialPolygonsDataFrame( SpatialPolygons(list(B_mask_poly)), data.frame( z=1, row.names=c("x") ) )
projection(B_mask_poly_df) <- projection(mosaic)

B <- crop(x = r2, y = B_mask_poly_df)
plotRGB(B, r = 1, g = 2, b = 3)
lines(B_mask, col= "red", type="l", lty=2, lwd=3)

B_cords<-locator(type = "p",n=1,col="red",pch=19)
B_cords<-c(B_cords$x,B_cords$y)

############ ############ ############ ############ ############ ############ 
############ This data is for consistant results in the workshop ############ 
############ ############ ############ ############ ############ ############ 

B_cords<-c(746229.4,3382239.0)

############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 
############ ############ ############ ############ ############ ############ 

############ ############ ############ ############ ############ ############ 
############ Plotting to visualize the previous pipeline steps   ############ 
############ ############ ############ ############ ############ ############ 

plotRGB(r2, r = 1, g = 2, b = 3)
lines(rbind(A_cords,B_cords), col= "red", type="l", lty=2, lwd=3)
points(rbind(A_cords,B_cords),col= "blue", type="p",pch=19,cex=2)
text(x=c(A_cords[1],B_cords[1]),
     y=c(A_cords[2],B_cords[2]),
     labels=c("A","B"),
     cex = 3,
     adj = 0,
     col="yellow")


plotRGB(A, r = 1, g = 2, b = 3)
lines(rbind(A_cords,B_cords), col= "red", type="l", lty=2, lwd=5)
points(rbind(A_cords,B_cords),col= "Blue", type="p",pch=19,cex=2)
text(x=c(A_cords[1],B_cords[1]),
     y=c(A_cords[2],B_cords[2]),
     labels=c("A","B"),
     cex = 4,
     adj = 0,
     col="yellow")

plotRGB(B, r = 1, g = 2, b = 3)
lines(rbind(A_cords,B_cords), col= "red", type="l", lty=2, lwd=5)
points(rbind(A_cords,B_cords),col= "blue", type="p",pch=19,cex=2)
text(x=c(A_cords[1],B_cords[1]),
     y=c(A_cords[2],B_cords[2]),
     labels=c("A","B"),
     cex = 4,
     adj = 0,
     col="yellow")


############ ############ ############ ############ ############ ############ 
############ Creating plot level polygon shapefiles ############ ############ 
############ ############ ############ ############ ############ ############ 

library("devtools")
devtools::install_github("andersst91/UAStools")
library("UAStools")

?plotshpcreate


setwd("C://Workshop//Outputs")
plots.shp<-plotshpcreate(A=A_cords, #Point A c(Easting_0.0,Northing_0.0)
              B=B_cords, #Point B c(Easting_1.0,Northing_1.0)
              infile=read.csv("C://Workshop//Data//CS18-POP1_infile.csv",header=T),
              outfile="Population1_plotpolygons",
              nrowplot=1,
              field="CS18-POP1",
              rowspc = 2.5, rowbuf = 0.1,
              rangespc = 12.5, rangebuf = 2,unit = "feet",
              UTMzone = "14", Hemisphere = "N")


system(paste("C://Workshop//LAStools//bin//lasview.exe",
             "-i C://Workshop/20180622_cs_sony_corn_3dpc.las",
             sep=" "),invisible=F)


############ ############ ############ ############ ############ ############ 
############ Clipping cleaned pointcloud to reduce computational time #######
############ ############ ############ ############ ############ ############ 

system(paste("C://Workshop//LAStools//bin//lasclip.exe",
  "-i C://Workshop/20180622_cs_sony_corn_3dpc.las",
  "-merged",
  "-poly C://Workshop//Outputs//Field_Mask.shp",
  "-o  C://Workshop//Processing//CS18-YYCI_06222018_FW_clip.laz",
  "-oforce -cores 8",
  sep=" "))

system(paste("C://Workshop//LAStools//bin//lasview.exe",
             "-i C://Workshop//Processing//CS18-YYCI_06222018_FW_clip.laz",
             sep=" "),invisible=F)

############ ############ ############ ############ ############ ############ 
############ Sorting clipped pointcloud to reduce computational time #######
############ ############ ############ ############ ############ ############ 

system(paste("C://Workshop//LAStools//bin//lassort.exe",
  "-i C://Workshop//CS18-YYCI_06222018_FW.laz",
  "-o C://Workshop//Processing//CS18-YYCI_06222018_FW_clip_sort.laz",
  "-olaz -cores 4",
  sep=" "))

system(paste("C://Workshop//LAStools//bin//lasview.exe",
             "-i C://Workshop//Processing//CS18-YYCI_06222018_FW_clip_sort.laz",
             sep=" "),invisible=F)

############ ############ ############ ############ ############ ############ 
############ Removing further noise from pointcloud ############ ############
############ ############ ############ ############ ############ ############ 

system(paste("C://Workshop//LAStools//bin//lasnoise.exe",
  "-i C://Workshop//Processing//CS18-YYCI_06222018_FW_clip_sort.laz",
  "-step_xy 5",
  "-step_z .05",
  "-isolated 100",
  # "-remove_noise",
  "-o C://Workshop//Processing//CS18-YYCI_06222018_FW_NREM.laz",
  "-oforce -cores 4",
  sep=" "))

system(paste("C://Workshop//LAStools//bin//lasview.exe",
             "-i C://Workshop//Processing//CS18-YYCI_06222018_FW_NREM.laz",
             sep=" "),invisible=F)

############ ############ ############ ############ ############ ############ 
############ Using ATIN alogrithim to ifdentify ground points ## ############
############ ############ ############ ############ ############ ############ 

system(paste("C://Workshop//LAStools//bin//lasground.exe",
             "-i C://Workshop//Processing//CS18-YYCI_06222018_FW_NREM.laz",
             "-step 25",
             "-bulge 0",
             "-offset 0.2",
             "-spike 0.05",
             "-stddev 0",
             "-o C://Workshop//Processing//GRND_CS18-YYCI_06222018_FW.laz",
             "-oforce -cores 4",
             sep=" "))

system(paste("C://Workshop//LAStools//bin//lasview.exe",
             "-i C://Workshop//Processing//GRND_CS18-YYCI_06222018_FW.laz",
             sep=" "),invisible=F)

############ ############ ############ ############ ############ ############ 
############ Identifying maximum points to model ground at peaks of rows ####
############ ############ ############ ############ ############ ############ 


system(paste("C://Workshop//LAStools//bin//lasthin.exe",
  "-i C://Workshop//Processing//GRND_CS18-YYCI_06222018_FW.laz",
  "-ignore_class 1",
  "-classify_as 8",
  "-step 0.5",
  "-highest",
  "-o C://Workshop//Processing//GRND_KP_CS18-YYCI_06222018_FW.laz",
  "-olaz -oforce",
  sep=" "))


system(paste("C://Workshop//LAStools//bin//lasview.exe",
             "-i C://Workshop//Processing//GRND_KP_CS18-YYCI_06222018_FW.laz",
             sep=" "),invisible=F)

############ ############ ############ ############ ############ ############ 
############ Usinbg keypoints to model the ground, adjusting Z point ########
############ to above ground height estimates ##### ############ ############ 
############ ############ ############ ############ ############ ############ 

system(paste("C://Workshop//LAStools//bin//lasheight.exe",
             "-i C://Workshop//Processing//GRND_KP_CS18-YYCI_06222018_FW.laz",
               "-classification 8",
               "-scale_u 0.001",
               "-drop_below 0.1",
               "-drop_above 3.5",
               "-replace_z",
              "-o C://Workshop//Processing//HGT_CS18-YYCI_06222018_FW.las",
             "-oforce",
             sep=" "))

system(paste("C://Workshop//LAStools//bin//lasview.exe",
             "-i C://Workshop//Processing//HGT_CS18-YYCI_06222018_FW.las",
             sep=" "),invisible=F)


############ ############ ############ ############ ############ ############ 
############ Clipping each plot polygon and extracting cloud metrics ########
############ ############ ############ ############ ############ ############ 

Shapefile<-readOGR(dsn = "C://Workshop//Outputs//CS18-POP1_Population1_plotpolygons.shp")
PointCloud<-readLAS("C://Workshop//Processing//HGT_CS18-YYCI_06222018_FW.las", select="xyz")

############ ############ ############ ############ ############ ############ 
############ This takes roughly 40 mins  sdo we will skip for the workshop ##
############ ############ ############ ############ ############ ############ 

# PC_Summary<-data.frame()
# for (i in 1:length(Shapefile)){
# start<-proc.time()
# TPC<-lasclip(PointCloud,Shapefile@polygons[[i]]@Polygons[[1]])
#   
# 
# PC_Summary<-rbind(PC_Summary,
#                  cbind(data.frame(Barcode=Shapefile@data$id[[i]],
#                             Points=length(TPC$Z)),
#                             as.data.frame(stdmetrics_z(TPC$Z))))
# 
# print(paste("Quantiles Extracted for ",Shapefile@data$id[[i]],sep=""))
# print(proc.time()-start)         
# }
# 
# write.csv(PC_Summary,file="C://Workshop//Outputs//20180622_CS18_POP1_Metrics.csv",quote=F,row.names=F)
# system.time(T2PC<-lasclip(PointCloud,Shapefile))

PC_Summary<-read.csv("C://Workshop//Outputs//20180622_CS18_POP1_Metrics.csv",header=T)                           
Notes<-read.csv("C://Workshop//Data/CS18_YYCI_Notes.csv",header=T)    

XXX<-merge(Notes,PC_Summary,by="Barcode")


############ ############ ############ ############ ############ ############ 
############ Visualization and correlation ######## ############ ############
############ ############ ############ ############ ############ ############ 

plot(((XXX$PHT*2.54)/100)~XXX$zq95,
     ylab="Manual PHT (m)", xlab= "UAS P95 (m)")
abline(lm((XXX$PHT*2.54)/100~XXX$zq95),col="red",lwd=7)

text(x=0.8, y=2.2,paste( "r=",round(cor(x=((XXX$PHT*2.54)/100),y=XXX$zq95,use="pairwise.complete.obs"),3), sep=" "))


############ ############ ############ ############ ############ ############ 
############ Example as to why manual correction is benificial## ############ 
############ ############ ############ ############ ############ ############


PC_Summary<-read.csv("C://Workshop//Outputs//20180622_CS18_POP1_translated_Metrics.csv",header=T)                           
Notes<-read.csv("C://Workshop//Data/CS18_YYCI_Notes.csv",header=T)    

XXX<-merge(Notes,PC_Summary,by="Barcode")

plot(((XXX$PHT*2.54)/100)~XXX$zq95,
     ylab="Manual PHT (m)", xlab= "UAS P95 (m)")
abline(lm((XXX$PHT*2.54)/100~XXX$zq95),col="red",lwd=7)

text(x=0.8, y=2.2,paste( "r=",round(cor(x=((XXX$PHT*2.54)/100),y=XXX$zq95,use="pairwise.complete.obs"),3), sep=" "))



#########################
################ Extract BLUPS for ENTRIES 
library("lme4")

XXX$Rep<-as.factor(XXX$Rep)
XXX$Row<-as.factor(XXX$Row)
XXX$Range<-as.factor(XXX$Range)
XXX$PHT<-as.numeric(XXX$PHT)*2.54/100
XXX$P95<-as.numeric(XXX$zq95)

PHT<-lmer(PHT~(1|Rep)+(1|Row)+(1|Range)+(1|Entry),data=XXX)
  
print(VarCorr(PHT), comp=c("Variance"))

PHT<-lmer(PHT~(1|Range)+(1|Entry),data=XXX)

PHT_vc<-as.data.frame(print(VarCorr(PHT), comp=c("Variance")))
PHT_vc$Percent<-PHT_vc$vcov/sum(PHT_vc$vcov)

PHT_vc

######################

summary(XXX$STD)

hist(XXX$P95)

for (i in 1:nrow(XXX)){
  if(is.na(XXX$STD[i])){
    XXX$P95[i]<-NA;next}
  if(XXX$STD[i]<5){
    XXX$P95[i]<-NA;next}
  }

hist(XXX$P95)

plot(XXX$PHT~XXX$P95,
     ylab="Manual PHT (m)", xlab= "UAS P95 (m)")
abline(lm(XXX$PHT~XXX$P95),col="red",lwd=7)

text(x=0.8, y=2.2,paste( "r=",round(cor(x=XXX$PHT,y=XXX$P95,use="pairwise.complete.obs"),3), sep=" "))





P95<-lmer(P95~(1|Rep)+(1|Row)+(1|Range)+(1|Entry),data=XXX)

print(VarCorr(P95), comp=c("Variance"))

P95<-lmer(P95~(1|Range)+(1|Entry),data=XXX)

P95_vc<-as.data.frame(print(VarCorr(P95), comp=c("Variance")))
P95_vc$Percent<-P95_vc$vcov/sum(P95_vc$vcov)

P95_vc


#################

PHT_BLUPS<-ranef(PHT)$Entry+fixef(PHT)
PHT_BLUPS<-data.frame("Taxa"=row.names(PHT_BLUPS),"PHT"=PHT_BLUPS[,1])
PHT_BLUPS<-PHT_BLUPS[-c(1,2,3,4,6,7,9),]

dim(PHT_BLUPS)

hist(PHT_BLUPS$PHT)

P95_BLUPS<-ranef(P95)$Entry+fixef(P95)
P95_BLUPS<-data.frame("Taxa"=row.names(P95_BLUPS),"P95"=P95_BLUPS[,1])
P95_BLUPS<-P95_BLUPS[-c(1,2,3,4,6,7,9),]

dim(P95_BLUPS)

hist(P95_BLUPS$P95)

myY<-merge(PHT_BLUPS,P95_BLUPS,by="Taxa",all=T)

write.csv(myY,file="C://Workshop//Data//POP1_GAPITPHENOS_v2.csv",row.names=F,quote=F)


##########################
### GWAS ANALYSIS ########
##########################

myG<-read.csv("C://Workshop//Data//POP1_HapMap.csv",header=F)
myY<-read.csv("C://Workshop//Data//POP1_GAPITPHENOS_v2.csv",header=T)


for(i in 12:nrow(myG)){
  print(paste(i," in i of ",nrow(myG),sep=""))
  for (j in 12:ncol(myG)){
          # print(paste(j," in i of ",ncol(myG),sep=""))
    chk<-strsplit(as.character(myG[i,j]),"")
    if(chk[[1]][1]==chk[[1]][2]){next}
    if(chk[[1]][1]!=chk[[1]][2]){
      myG[i,j]<-"--"}
  }
}


setwd("C://Workshop//GAPIT")

myGAPIT <- GAPIT(
  Y=myY,
  G=myG,
  SNP.MAF=0.35,
  model=c("CMLM","SUPER","GLM","MLM","MLMM")
)

myGAPIT <- GAPIT(
  Y=myY[,c(1,2)],
  G=myG,
  SNP.MAF=0.35,
  model=c("FarmCPU")
)

myGAPIT <- GAPIT(
  Y=myY[,c(1,3)],
  G=myG,
  SNP.MAF=0.35,
  model=c("FarmCPU")
)


###############  MAF = 0.45
setwd("C://Workshop//GAPIT_MAF=0.45")

myGAPIT <- GAPIT(
  Y=myY,
  G=myG,
  SNP.MAF=0.45,
  model=c("CMLM","SUPER","GLM","MLM","MLMM")
)

myGAPIT <- GAPIT(
  Y=myY[,c(1,2)],
  G=myG,
  SNP.MAF=0.45,
  model=c("FarmCPU")
)

myGAPIT <- GAPIT(
  Y=myY[,c(1,3)],
  G=myG,
  SNP.MAF=0.45,
  model=c("FarmCPU")
)

