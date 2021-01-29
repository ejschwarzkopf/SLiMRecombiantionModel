##############################################
##### R script that selects the parame-  #####
##### ter sets that differ from the no-  #####
##### selection case. It runs over the   #####
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

param_filename<-args[1]

input_template_prefix<-args[2]

input_template_suffix<-args[3]

output_template_prefix<-args[4]

##############################################
##### For loop that goes over all para-  #####
##### meter sets and compares them to    #####
##### the no-selection equivalent.       #####
##############################################

# Read the parameter sets

param_table<-read.table(param_filename, header=TRUE)

# For loop that goes over possible values of recombination rate

full_pvalue_table<-data.frame()

for( r in unique(param_table$R) ){
	cases<-which(param_table$R==r)
	comp_case<-cases[1]
	comp_input<-paste(input_template_prefix, comp_case, input_template_suffix, sep='')
	comp_table<-read.table(comp_input, haeder=TRUE, row.names=1)
	pvalue_table<-data.frame()
	for( i in cases){
		case_input<-paste(input_template_prefix, i, input_template_suffix, sep='')
		case_table<-read.table(case_input, haeder=TRUE, row.names=1)
		diff_KS<-ks.test(case_table$Rates_diff, rnorm(500, mean=mean(case_table$Rates_diff), sd=sd(case_table$Rates_diff)))
		diff_KW<-kruskal.test(list(case_table$Rates_diff, comp_table$Rates_diff))
		diff_t<-t.test(case_table$Rates_diff, comp_table$Rates_diff, paired=FALSE. var.equal=FALSE)
		mean95_KS<-ks.test(case_table$Rates_95range_mean_all, rnorm(500, mean=mean(case_table$Rates_95range_mean_all), sd=sd(case_table$Rates_95range_mean_all)))
		mean95_KW<-kruskal.test(list(case_table$Rates_95range_mean_all, comp_table$Rates_95range_mean_all))
		mean95_t<-t.test(case_table$Rates_95range_mean_all, comp_table$Rates_95range_mean_all, paired=FALSE. var.equal=FALSE)
		mediansd_KS<-ks.test(case_table$Rates_median_SD_all, rnorm(500, mean=mean(case_table$Rates_median_SD_all), sd=sd(case_table$Rates_median_SD_all)))
		mediansd_KW<-kruskal.test(list(case_table$Rates_median_SD_all, comp_table$Rates_median_SD_all))
		mediansd_t<-t.test(case_table$Rates_median_SD_all, comp_table$Rates_median_SD_all, paired=FALSE. var.equal=FALSE)
		case_p<-c(diff_KS, diff_KW, diff_t, mean95_KS, mean95_KW, mean95_t, mediansd_KS, mediansd_KW, mediansd_t)
		pvalue_table<-rbind(pvalue_table, case_p)
	}
	full_pvalue_table[cases,]<-pvalue_table
}

colnames(full_pvalue_table)<-c("diff_KS", "diff_KW", "diff_t", "mean95_KS", "mean95_KW", "mean95_t", "mediansd_KS", "mediansd_KW", "mediansd_t")

diff_params<-which((full_pvalue_table$diff_KS<=0.05 & full_pvalue_table$diff_t<=0.05) | (full_pvalue_table$diff_KS>0.05 & full_pvalue_table$diff_KW))

mean95_params<-which((full_pvalue_table$mean95_KS<=0.05 & full_pvalue_table$mean95_t<=0.05) | (full_pvalue_table$mean95_KS>0.05 & full_pvalue_table$mean95_KW))

mediansd_params<-which((full_pvalue_table$mediansd_KS<=0.05 & full_pvalue_table$mediansd_t<=0.05) | (full_pvalue_table$mediansd_KS>0.05 & full_pvalue_table$mediansd_KW))

diff_outputfile<-paste(output_template_prefix, "_diff_parameters.txt", sep='')

write.table(diff_outputfile, diff_params. quote=FALSE, row.names=FALSE)

mean95_outputfile<-paste(output_template_prefix, "_mean95_parameters.txt", sep='')

write.table(mean95_outputfile, mean95_params. quote=FALSE, row.names=FALSE)

mediansd_outputfile<-paste(output_template_prefix, "_mediansd_parameters.txt", sep='')

write.table(mediansd_outputfile, mediansd_params. quote=FALSE, row.names=FALSE)



