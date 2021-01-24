##############################################
##### R script that obtains all relevant #####
##### information from LDhot summary     #####
##### tables and sets it up in tables to #####
##### make figures from. It runs over    #####
##### 900 parameter sets.                #####
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

means.table<-data.frame()
sd.table<-data.frame()

for(i in 1:itercount){
	# generate the filename from the template provided as input
	filename<-paste(filetemplate, i, ".summary.txt", sep='')
	ogtable<-read.table(filename, header=TRUE, row.names=1)

	# calculate the mean and sd for all the columns
	means<-apply(ogtable, 2, mean)
	sds<-apply(ogtable, 2, sd)

	# add the vectors of means and sd to their tables
	means.table<-rbind(means.table, means)
	sd.table<-rbind(sd.table, sds)

}

# change the means.table and sd.table column names

colnames(means.table)<-c("HS_count", "HS_loci_count", "HS_brute_mean", "HS_relative_mean", "HS_loci_brute_mean", "HS_loci_relative_mean", "HS_brute_median", "HS_relative_median", "HS_loci_brute_median", "HS_loci_relative_median")
colnames(sd.table)<-c("HS_count_sd", "HS_loci_count_sd", "HS_brute_mean_sd", "HS_relative_mean_sd", "HS_loci_brute_mean_sd", "HS_loci_relative_mean_sd", "HS_brute_median_sd", "HS_relative_median_sd", "HS_loci_brute_median_sd", "HS_loci_relative_median_sd")


# load the table with parameter information
parameters.table<-read.table("/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/6.aux/SLiM_Parameters.txt", header=TRUE)

output.table<-cbind(parameters.table, means.table, sd.table)

write.table(output.table, "/data/cornejo/projects/e.jimenezschwarzkop/SLiMRecombinationModel/8.LDhot_summary/LDhot_means_sds.txt", quote=FALSE, row.names=FALSE)











