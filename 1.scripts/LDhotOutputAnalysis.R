##############################################
##### R script that obtains all relevant #####
##### information from LDhot output and  #####
##### and places it in a new table. This #####
##### script runs over the 500 itera-    #####
##### tions of a particular set of para- #####
##### meters.                            #####
##############################################

##############################################
##### Load required packages.            #####
##############################################

library(spatstat)

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

# HScount keeps the number of hotspots for all the iterations
HS_count<-c()
# HS_loci_count keeps the number of hotspots that are between the two loci
HS_loci_count<-c()
# HS_brute_mean keeps the mean recombination rate of hotspots. Weighted by HS length
HS_brute_mean<-c()
# HS_relative_mean keeps the mean recombination rate of hotspots relative to the background rate. Weighted by HS length
HS_relative_mean<-c()
# HS_loci_brute_mean: same as HS_brute_mean, but only for HS between loci
HS_loci_brute_mean<-c()
# HS_loci_relative_mean: same as HS_relative_mean, but only for HS between loci
HS_loci_relative_mean<-c()
# HS_brute_median: same as HS_brute_mean, but median
HS_brute_median<-c()
# HS_relative_median: same as HS_relative_mean, but median
HS_relative_median<-c()
# HS_loci_brute_median: same as HS_loci_brute_median, but only for HS between loci
HS_loci_brute_median<-c()
# HS_loci_relative_median: same as HS_relative_median, but only for HS between loci
HS_loci_relative_median<-c()

for(i in 1:itercount){
	# generate the filename from the template provided as input
	filename<-paste(filetemplate, i, ".ldhot.hotspots.txt", sep='')
	ogtable<-read.table(filename, header=TRUE)
	# Subset by significant hotspots and keep the start and stop positions
	table<-ogtable[which(ogtable[,9]<0.001), 1:2]
	# This while loop will merge any hotspots that overlap with each other
	j=1
	while(j!=0 & nrow(table)>j){
		if(nrow(table)==j){
			j=0
		}else{
			if(table[j,2]<=table[(j+1),1]){
				table[j,2]=table[(j+1),2]
				table = table[-(j+1),]
			}else{
				j=j+1
			}
		}
	}
	HS_count<-c(HScount, nrow(table))
	HS_loci_count<-c(HScount, nrow(table[which((table[,1]>=10 & table[,1]<=15) | (table[,2]>=10 & table[,2]<=15)),]))
	# Subset by significant hotspots, but keep everything
	table2<-ogtable[which(ogtable[,9]<0.001),]
	# Average strength weighted by hotspot length:
	table2[,11]<-table2[,2]-table2[,1]
	table2[,12]<-table2[,11]/sum(table2[,11])

	loci_index<-which((table2[,1]>=10 & table2[,1]<=15) | (table2[,2]>=10 & tale2[,2]<=15))

	HS_brute_mean<-sum(table2[,3]*table2[,12])
	HS_relative_mean<-sum((table2[,3]/table2[,6])*table2[,12])
	HS_loci_brute_mean<-sum(table2[loci_index,3]*table2[loci_index,12])
	HS_loci_relative_mean<-sum((table2[loci_index,3]/table2[loci_index,6])*table2[loci_index,12])
	HS_brute_median<-weighted.median(table2[,3], table2[,12])
	HS_relative_median<-weighted.median((table2[,3]/table2[,6]), table2[,12])
	HS_loci_brute_median<-weighted.median(table2[loci_index,3], table2[loci_index,12])
	HS_loci_relative_median<-weighted.median((table2[loci_index,3]/table2[loci_index,6]), table2[loci_index,12])
}

OutputTable<-data.frame(HS_count=HS_count, HS_loci_count=HS_loci_count, HS_brute_mean=HS_brute_mean, HS_relative_mean=HS_relative_mean, HS_loci_brute_mean=HS_loci_brute_mean, HS_loci_relative_mean=HS_loci_relative_mean, HS_brute_median=HS_brute_median, HS_relative_median=HS_relative_median, HS_loci_brute_median=HS_loci_brute_median, HS_loci_relative_median=HS_loci_relative_median)

output_filename<-paste(filetemplate, ".ldhot.summary.txt", sep='')

write.table(OutputTable, filetemplate, quote=FALSE)