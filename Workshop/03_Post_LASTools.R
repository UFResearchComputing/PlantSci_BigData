library("devtools")
library("sp")
library("raster")
library("rgdal")
library("lidR")
library("lme4")

library("sp")
library("raster")
library("rgdal")
library('lidR')

############ ############ ############ ############ ############ ############ 
############ Clipping each plot polygon and extracting cloud metrics ########
############ ############ ############ ############ ############ ############ 

Shapefile<-readOGR(dsn = "Outputs/CS18-POP1_Population1_plotpolygons.shp")
PointCloud<-readLAS("Processing/HGT_CS18-YYCI_06222018_FW.las", select="xyz")

############ ############ ############ ############ ############ ############ 
############ This takes roughly 40 mins  so we will skip for the workshop  ##
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
# write.csv(PC_Summary,file="Outputs/20180622_CS18_POP1_Metrics.csv",quote=F,row.names=F)
# system.time(T2PC<-lasclip(PointCloud,Shapefile))

PC_Summary<-read.csv("Outputs/20180622_CS18_POP1_Metrics.csv",header=T)
Notes<-read.csv("Data/CS18_YYCI_Notes.csv",header=T)

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


PC_Summary<-read.csv("Outputs/20180622_CS18_POP1_translated_Metrics.csv",header=T)
Notes<-read.csv("Data/CS18_YYCI_Notes.csv",header=T)

XXX<-merge(Notes,PC_Summary,by="Barcode")

plot(((XXX$PHT*2.54)/100)~XXX$zq95,
     ylab="Manual PHT (m)", xlab= "UAS P95 (m)")
abline(lm((XXX$PHT*2.54)/100~XXX$zq95),col="red",lwd=7)

text(x=0.8, y=2.2,paste( "r=",round(cor(x=((XXX$PHT*2.54)/100),y=XXX$zq95,use="pairwise.complete.obs"),3), sep=" "))

