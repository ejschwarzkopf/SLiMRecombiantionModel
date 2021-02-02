##############################################
##### R script that makes wisker plots   #####
##### for the different parameter sets   #####
##### for the different variables we are #####
##### interested in: differece between   #####
##### background and between loci rates, #####
##### SD of the full chromosome rates,   #####
##### and 95% range of the whole chromo- #####
##### some.                              #####
##############################################

##############################################
##### Load required packages.            #####
##############################################

library(ggplot2)

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

input_template_prefix_param<-args[1]

input_template_suffix_param<-args[2]

input_template_prefix_case<-args[3]

input_template_suffix_case<-args[4]

output_template_prefix<-args[5]

##############################################
##### Load the case number tables.       #####
##############################################

diff_input_name<-paste(input_template_prefix_param, "diff", input_template_suffix_param, sep='')

param_diff_table<-read.table(diff_input_name)
print("diff")
mean95_input_name<-paste(input_template_prefix_param, "mean95", input_template_suffix_param, sep='')

param_mean95_table<-read.table(mean95_input_name)
print("mean95")
mediansd_input_name<-paste(input_template_prefix_param, "mediansd", input_template_suffix_param, sep='')

param_mediansd_table<-read.table(mediansd_input_name)
print("mediansd")
##############################################
##### Make tables for figures.           #####
##############################################

# Load files and extend data for each variable

diff_full_table<-data.frame(rep(0, 500))

for( j in 1:nrow(param_diff_table) ){
	i=param_diff_table[j,1]
	print(i)
	diff_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	diff_case_table<-read.table(diff_case_name, header=TRUE, row.names=1)
	diff_case_vector<-diff_case_table$Rates_diff
	diff_full_table<-cbind(diff_full_table, diff_case_vector)
	rm(diff_case_table)
	print(i)
}

diff_full_table<-diff_full_table[,-1]

row.names(diff_full_table)<-param_diff_table

diff_figure_table<-data.frame(id=1:ncol(diff_full_table), mean=apply(diff_full_table, 2, mean), sd=apply(diff_full_table, 2, sd))

print("diff")
mean95_full_table<-data.frame(rep(0, 500))

for( i in param_mean95_table ){
	mean95_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	mean95_case_table<-read.table(mean95_case_name, header=TRUE, row.names=1)
	mean95_case_vector<-mean95_case_name$Rates_mean95
	mean95_full_table<-cbind(mean95_full_table, mean95_case_vector)
	rm(mean95_case_table)
}

mean95_full_table<-mean95_full_table[,-1]

row.names(mean95_full_table)<-param_mean95_table

mean95_figure_table<-data.frame(id=1:ncol(mean95_full_table), mean=apply(mean95_full_table, 2, mean), sd=apply(mean95_full_table, 2, sd))



mediansd_full_table<-data.frame(rep(0, 500))

for( i in param_mediansd_table ){
	mediansd_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	mediansd_case_table<-read.table(mediansd_case_name, header=TRUE, row.names=1)
	mediansd_case_vector<-mediansd_case_name$Rates_mediansd
	mediansd_full_table<-cbind(mediansd_full_table, mediansd_case_vector)
	rm(mediansd_case_table)
}

mediansd_full_table<-mediansd_full_table[,-1]

row.names(mediansd_full_table)<-param_mediansd_table

mediansd_figure_table<-data.frame(id=1:ncol(mediansd_full_table), mean=apply(mediansd_full_table, 2, mean), sd=apply(mediansd_full_table, 2, sd))

##############################################
##### Make figures                       #####
##############################################

p_diff<-ggplot(diff_figure_table, aes(x=id, y=mean)) +
	geom_pointrange(aes(ymin=mean-sd, ymax=mean+sd)) +
	null()

ggsave("Rec_diff_test.pdf", height=3.5, width=10, units="in")

p_mean95<-ggplot(mean95_figure_table, aes(x=id, y=mean)) +
	geom_pointrange(aes(ymin=mean-sd, ymax=mean+sd)) +
	null()

ggsave("Rec_mean95_test.pdf", height=3.5, width=10, units="in")

p_mediansd<-ggplot(mediansd_figure_table, aes(x=id, y=mean)) +
	geom_pointrange(aes(ymin=mean-sd, ymax=mean+sd)) +
	null()

ggsave("Rec_mediansd_test.pdf", height=3.5, width=10, units="in")


























