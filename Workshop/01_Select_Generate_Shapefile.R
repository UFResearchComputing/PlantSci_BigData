library("devtools")
library("sp")
library("raster")
library("rgdal")
library("lidR")

library("sp")
library("raster")
library("rgdal")
library('lidR')



############ ############ ############ ############ 
############ Load and Visualize Mosaic ############ 
############ ############ ############ ############ 

mosaic<-stack("Data/20180622_cs_sony_corn_mosaic.tif")
plotRGB(mosaic, r = 1, g = 2, b = 3)

######### Creating field mask polygon to clip pointcloud. ######### 
field_mask<-data.frame()
for (i in 1:4){
  x<-locator(type = "p",n=1,col="red",pch=19)
  field_mask<-rbind(field_mask,x)
}

field_mask<-rbind(field_mask,field_mask[1,])

############ ############ ############ ############ ############ ############ 
############ This data is for consistent results in the workshop ############ 
############ Regardless of the points selected, the bounding box ############
############ will be the same so that all results are identical. ############
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
############ Clipping mosaic to improve point accuracy ######### ############  
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
############ This data is for consistent results in the workshop ############ 
############ As above, use constant bounding box for demo.       ############
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
         "Outputs/Field_Mask.shp",
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
############ This data is for consistent results in the workshop ############ 
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
############ This data is for consistent results in the workshop ############ 
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
############ This data is for consistent results in the workshop ############ 
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
############ This data is for consistent results in the workshop ############ 
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


setwd("Outputs")
plots.shp<-plotshpcreate(A=A_cords, #Point A c(Easting_0.0,Northing_0.0)
              B=B_cords, #Point B c(Easting_1.0,Northing_1.0)
              infile=read.csv("../Data/CS18-POP1_infile.csv",header=T),
              outfile="Population1_plotpolygons",
              nrowplot=1,
              field="CS18-POP1",
              rowspc = 2.5, rowbuf = 0.1,
              rangespc = 12.5, rangebuf = 2,unit = "feet",
              UTMzone = "14", Hemisphere = "N")
