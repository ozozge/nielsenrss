
library(plyr)
library(splitstackshape)
library(dplyr)
library(RODBC)
library(filesstrings)

setwd("C:\\foldername\\folder\\batch\\bin")
##downloading the files from Nielsen rss feed 

shell("nds-client.bat --http-user login@email.com --http-pass Password --output-directory D:\\folder\\foldername https://nds.nielsen.com/nds/LOCMTHLY/rss1-1day.xml --start-date \"30/01/2019\" --end-date \"31/01/2019\" ")

setwd("D:\\folder\\foldername")
zipF <- list.files(path = ".", pattern = "*.ZIP", full.names = TRUE)
ldply(.data = zipF, .fun = unzip, exdir = ".")
txt_files <- list.files(path = ".", pattern = "*.txt")

for (i in 1:length(txt_files)) {
  filename=txt_files[i]
  df1<-read.delim2(filename,header=FALSE, sep="\n")
  df2<-concat.split(data = df1,split.col = "V1" ,sep = "\t", drop = TRUE)
  df2$created_date<-Sys.Date()
  assign(x =substr(filename,1,7),value = df2)
  
}

Dflistnames<-ls.str(mode = "list")
Nlist<-Dflistnames[startsWith(Dflistnames,'NSI')]

marhead=NULL
distr=NULL
demo=NULL
estim=NULL
intab=NULL
excl=NULL
qtr=NULL
qhr=NULL
statn=NULL
mhp=NULL
pnr=NULL
mprup=NULL
pup=NULL
for (j in 1:(length(Nlist))){
  df3<-get(Nlist[j])
  marhead1<-filter(df3, V1_01=="1")
  marhead<-rbind(marhead,marhead1)
  distr1<-filter(df3, V1_01=="2")
  distr<-rbind(distr,distr1)
  demo1<-filter(df3, V1_01=="3")
  demo<-rbind(demo,demo1)
  estim1<-filter(df3, V1_01=="4")
  estim<-rbind(estim,estim1)
  intab1<-filter(df3, V1_01=="5")
  intab<-rbind(intab,intab1)
  excl1<-filter(df3, V1_01=="6")
  excl<-rbind(excl,excl1)
  qtr1<-filter(df3, V1_01=="7")
  qtr<-rbind(qtr,qtr1)
  qhr1<-filter(df3, V1_01=="8")
  qhr<-rbind(qhr,qhr1)
  statn1<-filter(df3, V1_01=="9")
  statn<-rbind(statn,statn1)
  mhp1<-filter(df3, V1_01=="11")
  mhp<-rbind(mhp,mhp1)
  pnr1<-filter(df3, V1_01=="12")
  pnr<-rbind(pnr,pnr1)
  mprup1<-filter(df3, V1_01=="21")
  mprup<-rbind(mprup,mprup1)
  pup1<-filter(df3, V1_01=="22")
  pup<-rbind(pup,pup1)
}

marhead<- marhead[, -c(26:32)]
colnames(marhead)<-c("recordcd","marketcd","dmacd","marketrank","geoind","geoname","startdttm","enddttm","numofdays","numofweeks","repstarttm","repserv","headersamplety","reissued","dataaccredited","playbackty","timeinterval","collectionmethod","contestind","reportperiod","repyear","markettimez","marketclasscd","distributor","daylight","createddate")


distr<-distr[,-c(20:32)]
colnames(distr)<-c("recordcd","marketcd","repserv","startdttm","enddttm","distributorcd","callletters","legacycalll","cablelongname","bcchannelnum","distrsourcety","primaryaff","secondaryaff","tertiaryaff","stationtotalind","stationtycd","audestind","reportabilitystat","prognameind","createddate")

demo<-demo[,-c(24:32)]
colnames(demo)<-c("recordcd","households","dem1","dem2","dem3","dem4","dem5","dem6","dem7","dem8","dem9","dem10","dem11","dem12","dem13","dem14","dem15","dem16","dem17","dem18","dem19","dem20","dem21","createddate")

estim<-estim[,-c(30:32)]
colnames(estim)<-c("recordcd","marketcd","geoind","repserv","samplety","metroa","metrob","household","dem1","dem2","dem3","dem4","dem5","dem6","dem7","dem8","dem9","dem10","dem11","dem12","dem13","dem14","dem15","dem16","dem17","dem18","dem19","dem20","dem21","createddate")

intab<-intab[,-c(31:32)]
colnames(intab)<-c("recordcd","marketcd","geoind","repserv","samplety","intabdt","metroa","metrob","householdintab","dem1","dem2","dem3","dem4","dem5","dem6","dem7","dem8","dem9","dem10","dem11","dem12","dem13","dem14","dem15","dem16","dem17","dem18","dem19","dem20","dem21","createddate")

excl<-excl[,-c(9:32)]
colnames(excl)<-c("recordcd","marketcd","repserv","exclty","startdttm","enddttm","desc","distributorcd","createddt")

colnames(qtr)<-c("recordcd","distributorcd","marketcd","repserv","samplety","playbackty","calendardttm","excluded","metroa","metrob","dmaqtr","dem1","dem2","dem3","dem4","dem5","dem6","dem7","dem8","dem9","dem10","dem11","dem12","dem13","dem14","dem15","dem16","dem17","dem18","dem19","dem20","dem21","createddate")  

colnames(qhr)<-c("recordcd","distributorcd","marketcd","repserv","samplety","playbackty","calendardttm","excluded","metroa","metrob","dmaunits","dem1","dem2","dem3","dem4","dem5","dem6","dem7","dem8","dem9","dem10","dem11","dem12","dem13","dem14","dem15","dem16","dem17","dem18","dem19","dem20","dem21","createddate")

statn<-statn[,-c(31:32)]
colnames(statn)<-c("recordcd","distributorcd","marketcd","repserv","samplety","playbackty","calendardttm","excluded","householdunits","dem1","dem2","dem3","dem4","dem5","dem6","dem7","dem8","dem9","dem10","dem11","dem12","dem13","dem14","dem15","dem16","dem17","dem18","dem19","dem20","dem21","createddate")

mhp<-mhp[,-c(19:32)]
colnames(mhp)<-c("recordcd","formatv","marketcd","dmacd","marketrank","geoind","geoname","startdttm","enddttm","numofdays","numofweeks","repstarttm","repserv","reportperiod","repyear","markettimez","daylight","subsampleind","createddate")  

pnr<-pnr[,-c(16:32)]
colnames(pnr)<-c("recordcd","marketcd","distributorcd","callletters","legacycalll","parentplind","qtrstartdttm","qtrenddttm","programcd","programname","subtitle","cablelongname","programty","programsource","satnameind","createddate")

mprup<-mprup[,-c(19:32)]
colnames(mprup)<-c("recordcd","marketcd","dmacd","marketrank","geoind","geoname","startdttm","enddttm","numofdays","numofweeks","repstarttm","repserv","reportperiod","repyear","markettimez","daylight","processingdttm","subsampleind","createddate")

pup<-pup[,-c(16:32)]
colnames(pup)<-c("recordcd","marketcd","distributorcd","callletters","legacycalll","parentplind","qtrstartdttm","qtrenddttm","programcd","programname","subtitle","cablelongname","programty","programsource","satnameind","createddate")



con=odbcDriverConnect('driver={SQL Server};server=servername;database=Nielsen;trusted_connection=true')
###
memory.limit(size=20000)

sqlSave(con,marhead,tablename="NielsenMarketHdr",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,distr,tablename="NielsenDistributorHdr",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,demo,tablename="NielsenDemoHdr",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,estim,tablename="NielsenMarketEstimateHdr",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,intab,tablename="NielsenMarketIntab",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,qtr,tablename="NielsenQtrHour",varTypes=c(calendardttm="datetime",createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,qhr,tablename="NielsenQtrHourDistr",varTypes=c(calendardttm="datetime",createddate="datetime"),append=TRUE,fast = FALSE)  
sqlSave(con,statn,tablename="NielsenStationTotal",varTypes =c(calendardttm="datetime", createddate="date") ,append=TRUE,fast = FALSE)
sqlSave(con,excl,tablename="NielsenExclusionRec",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,mhp,tablename="NielsenMarketHdrPro",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,pnr,tablename="NielsenProgramNames",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,mprup,tablename="NielsenMarketHdrProUpd",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)
sqlSave(con,pup,tablename="NielsenProgramUpd",varTypes=c(createddate="datetime"),append=TRUE,fast = FALSE)

### identify the folders

arcfolder <- "D:\\Archive"
zipfiles<-list.files(path = ".", pattern = "*.ZIP")
# find the files that you want
#list.of.files <- list.files(current.folder)

# copy the files to the new folder
file.move(txt_files, arcfolder)
file.move(zipfiles, arcfolder)
