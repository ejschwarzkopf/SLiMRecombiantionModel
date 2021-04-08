##############################################
##### R script that obtains all relevant #####
##### information from LDhat output and  #####
##### places it in a new table. This     #####
##### script runs over the 500 itera-    #####
##### tions of a particular set of para- #####
##### meters.                            #####
##############################################

##############################################
##### Load required packages.            #####
##############################################


##############################################
##### Recieve command line name for in-  #####
##### put files. Input template should   #####
##### be the filename up until the ite-  #####
##### ration number. The script will     #####
##### fill in the iteration number and   #####
##### the file extensions (ldhot stan-   #####
##### dard extensions).                  #####
##############################################

args = commandArgs(trailingOnly=TRUE)

if(length(args)<1){
	stop("Missing argument")
}

filetemplate<-args[1]

itercount<-args[2]


##############################################
##### For loop that goes over all file   #####
##### names for a set of parameters.     #####
##############################################

# Standard deviation of all mean rates (per locus)
Rates_mean_SD_all<-c()
# Coefficient of variation for all mean rates
Rates_mean_CV_all<-c()
# Standard deviation of mean rates between the two loci
Rates_mean_SD_loci<-c()
# Coefficient of variation of mean rates between the two loci
Rates_mean_CV_loci<-c()
Rates_mean_mean_all<-c()
Rates_mean_mean_loci<-c()
# Same as above, but the median
Rates_median_SD_all<-c()
Rates_median_CV_all<-c()
Rates_median_SD_loci<-c()
Rates_median_CV_loci<-c()
Rates_median_mean_all<-c()
Rates_median_mean_loci<-c()
# Same as above, but U95-L95
Rates_95range_SD_all<-c()
Rates_95range_CV_all<-c()
Rates_95range_SD_loci<-c()
Rates_95range_CV_loci<-c()
Rates_95range_mean_all<-c()
Rates_95range_mean_loci<-c()
# Background recombiantion rate (excludes 10-11k). Mean of the medians
Rates_median_mean_bg<-c()
# Difference between back bg rate and rate between loci under selection
Rates_diff<-c()



for(i in 1:itercount){
	# generate the filename from the template provided as input
	filename<-paste(filetemplate, i, "2.res.txt", sep='')
	ogtable<-read.table(filename, header=TRUE)
	# Subset by positions between the two loci
	table<-ogtable[which(ogtable[,1]>=10 & ogtable[,1]<=11),]
	bgtable<-ogtable[which(ogtable[,1]<10 | ogtable[,1]>11),]

	Rates_mean_mean_all<-c(Rates_mean_mean_all, mean(ogtable[,2]))
	Rates_mean_SD_all<-c(Rates_mean_SD_all, sd(ogtable[,2]))
	Rates_mean_CV_all<-c(Rates_mean_CV_all, sd(ogtable[,2])/mean(ogtable[,2]))
	Rates_mean_mean_loci<-c(Rates_mean_mean_loci, mean(table[,2]))
	Rates_mean_SD_loci<-c(Rates_mean_SD_loci, sd(table[,2]))
	Rates_mean_CV_loci<-c(Rates_mean_CV_loci, sd(table[,2])/mean(table[,2]))
	Rates_median_mean_all<-c(Rates_median_mean_all, mean(ogtable[,3]))
	Rates_median_SD_all<-c(Rates_median_SD_all, sd(ogtable[,3]))
	Rates_median_CV_all<-c(Rates_median_CV_all, sd(ogtable[,3])/mean(ogtable[,2]))
	Rates_median_mean_loci<-c(Rates_median_mean_loci, mean(table[,3]))
	Rates_median_SD_loci<-c(Rates_median_SD_loci, sd(table[,3]))
	Rates_median_CV_loci<-c(Rates_median_CV_loci, sd(table[,3])/mean(table[,3]))
	Rates_95range_mean_all<-c(Rates_95range_mean_all, mean(ogtable[,5]-ogtable[,4]))
	Rates_95range_SD_all<-c(Rates_95range_SD_all, sd(ogtable[,5]-ogtable[,4]))
	Rates_95range_CV_all<-c(Rates_95range_CV_all, sd(ogtable[,5]-ogtable[,4])/mean(ogtable[,5]-ogtable[,4]))
	Rates_95range_mean_loci<-c(Rates_95range_mean_loci, mean(table[,5]-table[,4]))
	Rates_95range_SD_loci<-c(Rates_95range_SD_loci, sd(table[,5]-table[,4]))
	Rates_95range_CV_loci<-c(Rates_95range_CV_loci, sd(table[,5]-table[,4])/mean(table[,5]-table[,4]))
	Rates_median_mean_bg<-c(Rates_median_mean_bg, mean(bgtable[,3]))
	
}
Rates_diff<-Rates_median_mean_loci-Rates_median_mean_bg
OutputTable<-data.frame(Rates_mean_mean_all=Rates_mean_mean_all, Rates_mean_SD_all=Rates_mean_SD_all, Rates_mean_CV_all=Rates_mean_CV_all, Rates_mean_mean_loci=Rates_mean_mean_loci, Rates_mean_SD_loci=Rates_mean_SD_loci, Rates_mean_CV_loci=Rates_mean_CV_loci, Rates_median_mean_all=Rates_median_mean_all, Rates_median_SD_all=Rates_median_SD_all, Rates_median_CV_all=Rates_median_CV_all, Rates_median_mean_loci=Rates_median_mean_loci, Rates_median_SD_loci=Rates_median_SD_loci, Rates_median_CV_loci=Rates_median_CV_loci, Rates_95range_mean_all=Rates_95range_mean_all, Rates_95range_SD_all=Rates_95range_SD_all, Rates_95range_CV_all=Rates_95range_CV_all, Rates_95range_mean_loci=Rates_95range_mean_loci, Rates_95range_SD_loci=Rates_95range_SD_loci, Rates_95range_CV_loci=Rates_95range_CV_loci, Rates_median_mean_bg=Rates_median_mean_bg, Rates_diff=Rates_diff)

output_filename<-paste(filetemplate, "2.res.summary.txt", sep='')

write.table(OutputTable, output_filename, quote=FALSE)