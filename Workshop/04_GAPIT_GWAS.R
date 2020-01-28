

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

write.csv(myY,file="Data/POP1_GAPITPHENOS_v2.csv",row.names=F,quote=F)


##########################
### GWAS ANALYSIS ########
##########################

myG<-read.csv("Data/POP1_HapMap.csv",header=F)
myY<-read.csv("Data/POP1_GAPITPHENOS_v2.csv",header=T)


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


setwd("GAPIT")

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
setwd("GAPIT_MAF=0.45")

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

