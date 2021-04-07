##############################################
##### R script that makes wisker plots   #####
##### for the different parameter sets   #####
##### for the different variables we are #####
##### interested in: differece between   #####
##### background and between loci rates, #####
##### SD of the full chromosome rates,   #####
##### and 95% range of the whole chromo- #####
##### some.                 #####
##############################################

##############################################
##### Load required packages.            #####
##############################################

library(ggplot2)
library(ggpubr)
library(reshape2)

##############################################
##### Recieve command line name for in-  #####
##### put files. Input template should   #####
##### be the filename up until the ite-  #####
##### ration number. The script will     #####
##### fill in the iteration number and   #####
##### the file extensions (ldhot stan-   #####
##### dard extensions).     #####
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

input_parameter_table<-args[6]

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

parameters<-read.table(input_parameter_table, header=T)

##############################################
##### Make tables for figures.           #####
##############################################

# First, we make tables for the cases that were significantly different from the no-selection case
# Load files and extend data for each variable

diff_full_table<-data.frame(rep(0, 500))

for( i in param_diff_table$V1 ){
	diff_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	diff_case_table<-read.table(diff_case_name, header=TRUE, row.names=1)
	diff_case_vector<-diff_case_table$Rates_diff
	diff_full_table<-cbind(diff_full_table, diff_case_vector)
	rm(diff_case_table)
}

diff_full_table<-diff_full_table[,-1]

colnames(diff_full_table)<-param_diff_table$V1

diff_figure_table<-data.frame(mean=apply(diff_full_table, 2, mean), sd=apply(diff_full_table, 2, sd))

diff_figure_table<-diff_figure_table[order(diff_figure_table$mean),]

diff_figure_table$id<-1:nrow(diff_figure_table)

diff_figure_table$R<-parameters[rownames(diff_figure_table),12]


mean95_full_table<-data.frame(rep(0, 500))

for( i in param_mean95_table$V1 ){
	mean95_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	mean95_case_table<-read.table(mean95_case_name, header=TRUE, row.names=1)
	mean95_case_vector<-mean95_case_table$Rates_95range_mean_all
	mean95_full_table<-cbind(mean95_full_table, mean95_case_vector)
	rm(mean95_case_table)
}

mean95_full_table<-mean95_full_table[,-1]

colnames(mean95_full_table)<-param_mean95_table$V1

mean95_figure_table<-data.frame(mean=apply(mean95_full_table, 2, mean), sd=apply(mean95_full_table, 2, sd))

mean95_figure_table<-mean95_figure_table[order(mean95_figure_table$mean),]

mean95_figure_table$id<-1:nrow(mean95_figure_table)

mean95_figure_table$R<-parameters[rownames(mean95_figure_table),12]


mediansd_full_table<-data.frame(rep(0, 500))

for( i in param_mediansd_table$V1 ){
	mediansd_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	mediansd_case_table<-read.table(mediansd_case_name, header=TRUE, row.names=1)
	mediansd_case_vector<-mediansd_case_table$Rates_median_SD_all
	mediansd_full_table<-cbind(mediansd_full_table, mediansd_case_vector)
	rm(mediansd_case_table)
}

mediansd_full_table<-mediansd_full_table[,-1]

colnames(mediansd_full_table)<-param_mediansd_table$V1

mediansd_figure_table<-data.frame(mean=apply(mediansd_full_table, 2, mean), sd=apply(mediansd_full_table, 2, sd))

mediansd_figure_table<-mediansd_figure_table[order(mediansd_figure_table$mean),]

mediansd_figure_table$id<-1:nrow(mediansd_figure_table)

mediansd_figure_table$R<-parameters[rownames(mediansd_figure_table),12]

# Now we make a table for all cases and include the parameter values

diff_allcases_full<-data.frame(rep(0,500))
medianloci_allcases_full<-data.frame(rep(0,500))
mean95_allcases_full<-data.frame(rep(0,500))
mediansd_allcases_full<-data.frame(rep(0,500))

for(i in 1:900){
	diff_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	diff_case_table<-read.table(diff_case_name, header=TRUE, row.names=1)
	diff_case_vector<-diff_case_table$Rates_diff
	diff_allcases_full<-cbind(diff_allcases_full, diff_case_vector)
	rm(diff_case_table)

	mean95_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	mean95_case_table<-read.table(mean95_case_name, header=TRUE, row.names=1)
	mean95_case_vector<-mean95_case_table$Rates_95range_mean_all
	mean95_allcases_full<-cbind(mean95_allcases_full, mean95_case_vector)
	rm(mean95_case_table)

	mediansd_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	mediansd_case_table<-read.table(mediansd_case_name, header=TRUE, row.names=1)
	mediansd_case_vector<-mediansd_case_table$Rates_median_SD_all
	mediansd_allcases_full<-cbind(mediansd_allcases_full, mediansd_case_vector)
	rm(mediansd_case_table)

	medianloci_case_name<-paste(input_template_prefix_case, i, input_template_suffix_case, sep = '')
	medianloci_case_table<-read.table(medianloci_case_name, header=TRUE, row.names=1)
	medianloci_case_vector<-medianloci_case_table$Rates_median_mean_loci
	medianloci_allcases_full<-cbind(medianloci_allcases_full, medianloci_case_vector)
	rm(medianloci_case_table)
}

medianloci_allcases_full<-medianloci_allcases_full[,-1]
diff_allcases_full<-diff_allcases_full[,-1]
mean95_allcases_full<-mean95_allcases_full[,-1]
mediansd_allcases_full<-mediansd_allcases_full[,-1]

allcases_figure_table<-data.frame(diff_mean=apply(diff_allcases_full, 2, mean), diff_sd=apply(diff_allcases_full, 2, sd), mean95_mean=apply(mean95_allcases_full, 2, mean), mean95_sd=apply(mean95_allcases_full, 2, sd), mediansd_mean=apply(mediansd_allcases_full, 2, mean), mediansd_sd=apply(mediansd_allcases_full, 2, sd), medianloci_mean=apply(medianloci_allcases_full, 2, mean), medianloci_sd=apply(medianloci_allcases_full, 2, sd))

allcases_figure_table<-cbind(parameters, allcases_figure_table)

##############################################
##### Make whisker plots of cases sig-   #####
##### nificantly different from no-se-   #####
##### lection case.                      #####
##############################################



p_diff<-ggplot(diff_figure_table, aes(x=id, y=mean)) +
	geom_point(size=0.2) +
	geom_errorbar(aes(x=id, ymin=mean-sd, ymax=mean+sd, color=factor(R)), size=0.5) +
	labs(colour="Recombination rate (r)", x="", y="mean difference between background and between-loci recombinaiton rate") +
	NULL

ggsave("Rec_diff_test.pdf", height=3.5, width=10, units="in")

p_mean95<-ggplot(mean95_figure_table, aes(x=id, y=mean)) +
	geom_point(size=0.2) +
	geom_errorbar(aes(x=id, ymin=mean-sd, ymax=mean+sd, color=factor(R)), size=0.5) +
	labs(colour="Recombination rate (r)", x="", y="mean 95% range for estimates") +
	NULL

ggsave("Rec_mean95_test.pdf", height=3.5, width=10, units="in")

p_mediansd<-ggplot(mediansd_figure_table, aes(x=id, y=mean)) +
	geom_point(size=0.2) +
	geom_errorbar(aes(x=id, ymin=mean-sd, ymax=mean+sd, color=factor(R)), size=0.5) +
	labs(colour="Recombination rate (r)", x="", y="standard deviation of median rates") +
	NULL

ggsave("Rec_mediansd_test.pdf", height=3.5, width=10, units="in")


##############################################
##### Make scatter plots of pairs of     #####
##### variables marking by parameter va- #####
##### lues.                              #####
##############################################

# All parameter sets, coloring by recombination rate

p_diff_mean95<-ggplot(allcases_figure_table, aes(x=-diff_mean, y=mean95_mean)) +
	geom_point(size=1, aes(color=factor(R))) +
	NULL

ggsave("Rec_diff_mean95.pdf", height=4, width=5, units="in")

p_diff_mediansd<-ggplot(allcases_figure_table, aes(x=-diff_mean, y=mediansd_mean)) +
	geom_point(size=1, aes(color=factor(R))) +
	NULL

ggsave("Rec_diff_mediansd.pdf", height=4, width=5, units="in")

p_mediansd_mean95<-ggplot(allcases_figure_table, aes(x=mediansd_mean, y=mean95_mean)) +
	geom_point(size=1, aes(color=factor(R))) +
	NULL

ggsave("Rec_mean95_mediansd.pdf", height=4, width=5, units="in")

# Reduced plot size to zoom into one of the groups

p_diff_mean95_sub_0<-ggplot(subset(allcases_figure_table, R == 0), aes(x=-diff_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mean95_sub_0.pdf", height=4, width=5, units="in")

p_diff_mean95_sub_08<-ggplot(subset(allcases_figure_table, R == 1e-08), aes(x=-diff_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mean95_sub_08.pdf", height=4, width=5, units="in")

p_diff_mean95_sub_07<-ggplot(subset(allcases_figure_table, R == 1e-07), aes(x=-diff_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mean95_sub_07.pdf", height=4, width=5, units="in")

p_diff_mean95_sub_06<-ggplot(subset(allcases_figure_table, R == 1e-06), aes(x=-diff_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mean95_sub_06.pdf", height=4, width=5, units="in")

p_diff_mean95_sub_05<-ggplot(subset(allcases_figure_table, R == 1e-05), aes(x=-diff_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mean95_sub_05.pdf", height=4, width=5, units="in")

p_diff_mean95_sub_04<-ggplot(subset(allcases_figure_table, R == 1e-04), aes(x=-diff_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mean95_sub_04.pdf", height=4, width=5, units="in")



p_diff_mediansd_sub_0<-ggplot(subset(allcases_figure_table, R == 0), aes(x=-diff_mean, y=mediansd_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mediansd_sub_0.pdf", height=4, width=5, units="in")

p_diff_mediansd_sub_08<-ggplot(subset(allcases_figure_table, R == 1e-08), aes(x=-diff_mean, y=mediansd_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mediansd_sub_08.pdf", height=4, width=5, units="in")

p_diff_mediansd_sub_07<-ggplot(subset(allcases_figure_table, R == 1e-07), aes(x=-diff_mean, y=mediansd_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mediansd_sub_07.pdf", height=4, width=5, units="in")

p_diff_mediansd_sub_06<-ggplot(subset(allcases_figure_table, R == 1e-06), aes(x=-diff_mean, y=mediansd_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mediansd_sub_06.pdf", height=4, width=5, units="in")

p_diff_mediansd_sub_05<-ggplot(subset(allcases_figure_table, R == 1e-05), aes(x=-diff_mean, y=mediansd_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mediansd_sub_05.pdf", height=4, width=5, units="in")

p_diff_mediansd_sub_04<-ggplot(subset(allcases_figure_table, R == 1e-04), aes(x=-diff_mean, y=mediansd_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_mediansd_sub_04.pdf", height=4, width=5, units="in")



p_mediansd_mean95_sub_0<-ggplot(subset(allcases_figure_table, R == 0), aes(x=mediansd_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_mediansd_mean95_sub_0.pdf", height=4, width=5, units="in")

p_mediansd_mean95_sub_08<-ggplot(subset(allcases_figure_table, R == 1e-08), aes(x=mediansd_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_mediansd_mean95_sub_08.pdf", height=4, width=5, units="in")

p_mediansd_mean95_sub_07<-ggplot(subset(allcases_figure_table, R == 1e-07), aes(x=mediansd_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_mediansd_mean95_sub_07.pdf", height=4, width=5, units="in")

p_mediansd_mean95_sub_06<-ggplot(subset(allcases_figure_table, R == 1e-06), aes(x=mediansd_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_mediansd_mean95_sub_06.pdf", height=4, width=5, units="in")

p_mediansd_mean95_sub_05<-ggplot(subset(allcases_figure_table, R == 1e-05), aes(x=mediansd_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_mediansd_mean95_sub_05.pdf", height=4, width=5, units="in")

p_mediansd_mean95_sub_04<-ggplot(subset(allcases_figure_table, R == 1e-04), aes(x=mediansd_mean, y=mean95_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_mediansd_mean95_sub_04.pdf", height=4, width=5, units="in")



p_diff_medianloci_sub_0<-ggplot(subset(allcases_figure_table, R == 0), aes(x=-diff_mean, y=medianloci_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_medianloci_sub_0.pdf", height=4, width=5, units="in")

p_diff_medianloci_sub_08<-ggplot(subset(allcases_figure_table, R == 1e-08), aes(x=-diff_mean, y=medianloci_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_medianloci_sub_08.pdf", height=4, width=5, units="in")

p_diff_medianloci_sub_07<-ggplot(subset(allcases_figure_table, R == 1e-07), aes(x=-diff_mean, y=medianloci_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_medianloci_sub_07.pdf", height=4, width=5, units="in")

p_diff_medianloci_sub_06<-ggplot(subset(allcases_figure_table, R == 1e-06), aes(x=-diff_mean, y=medianloci_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_medianloci_sub_06.pdf", height=4, width=5, units="in")

p_diff_medianloci_sub_05<-ggplot(subset(allcases_figure_table, R == 1e-05), aes(x=-diff_mean, y=medianloci_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_medianloci_sub_05.pdf", height=4, width=5, units="in")

p_diff_medianloci_sub_04<-ggplot(subset(allcases_figure_table, R == 1e-04), aes(x=-diff_mean, y=medianloci_mean)) +
	geom_point(aes(color=HI_1, size=HI_2)) +
	NULL

ggsave("Rec_diff_medianloci_sub_04.pdf", height=4, width=5, units="in")

##############################################
##### Graphs of 1-locus cases. x-axis is #####
##### the selection coefficient. y-axis  #####
##### is the diff variable. color by re- #####
##### combination rate (for the first    #####
##### graph).                            #####
##############################################

single_locus_figure_table<-allcases_figure_table[which(allcases_figure_table$HI_1==0),]

p_diff_1loc<-ggplot(single_locus_figure_table, aes(x=HI_2, y=-diff_mean)) +
	geom_point(aes(color=R)) +
	NULL

ggsave("Rec_diff_1locus_all.pdf", height=4, width=5, units="in")



p_diff_1loc_R0<-ggplot(subset(single_locus_figure_table, R==0), aes(x=factor(HI_2), y=-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_diff_1locus_R0.pdf", height=4, width=5, units="in")

p_diff_1loc_R8<-ggplot(subset(single_locus_figure_table, R==1e-08), aes(x=factor(HI_2), y=-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_diff_1locus_R08.pdf", height=4, width=5, units="in")

p_diff_1loc_R7<-ggplot(subset(single_locus_figure_table, R==1e-07), aes(x=factor(HI_2), y=-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_diff_1locus_R07.pdf", height=4, width=5, units="in")

p_diff_1loc_R6<-ggplot(subset(single_locus_figure_table, R==1e-06), aes(x=factor(HI_2), y=-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_diff_1locus_R06.pdf", height=4, width=5, units="in")

p_diff_1loc_R5<-ggplot(subset(single_locus_figure_table, R==1e-05), aes(x=factor(HI_2), y=-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_diff_1locus_R05.pdf", height=4, width=5, units="in")

p_diff_1loc_R4<-ggplot(subset(single_locus_figure_table, R==1e-04), aes(x=factor(HI_2), y=-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_diff_1locus_R04.pdf", height=4, width=5, units="in")


##############################################
##### Graphs of 2-locus cases. x-axis is #####
##### the selection coefficient. y-axis  #####
##### is the diff variable. color by re- #####
##### combination rate (for the first    #####
##### graph).                            #####
##############################################

two_locus_figure_table<-allcases_figure_table[which(allcases_figure_table$HI_1!=0 | allcases_figure_table$HI_2==0),]

two_locus_figure_table$HI_12<-paste(two_locus_figure_table$HI_1, two_locus_figure_table$HI_2, sep="|")

two_locus_figure_table$HI_12<-as.factor(two_locus_figure_table$HI_12)

two_locus_figure_table$HI_12<-relevel(two_locus_figure_table$HI_12, "0|0")

p_diff_2loc<-ggplot(two_locus_figure_table, aes(x=HI_12, y=-diff_mean)) +
	geom_point(aes(color=R)) +
	NULL

ggsave("Rec_diff_1locus_all.pdf", height=4, width=5, units="in")



p_diff_2loc_R0<-ggplot(subset(two_locus_figure_table, R==0), aes(x=factor(HI_12), y=-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=0", y="", x="") +
	NULL

ggsave("Rec_diff_2locus_R0.pdf", height=4, width=8, units="in")

p_diff_2loc_R8<-ggplot(subset(two_locus_figure_table, R==1e-08), aes(x=factor(HI_12), y=-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-08", y="", x="") +
	NULL

ggsave("Rec_diff_2locus_R08.pdf", height=4, width=8, units="in")

p_diff_2loc_R7<-ggplot(subset(two_locus_figure_table, R==1e-07), aes(x=factor(HI_12), y=-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-07", y="interlocus - background \n 4Ner/kb", x="") +
	NULL

ggsave("Rec_diff_2locus_R07.pdf", height=4, width=8, units="in")

p_diff_2loc_R6<-ggplot(subset(two_locus_figure_table, R==1e-06), aes(x=factor(HI_12), y=-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-06", y="", x="") +
	NULL

ggsave("Rec_diff_2locus_R06.pdf", height=4, width=8, units="in")

p_diff_2loc_R5<-ggplot(subset(two_locus_figure_table, R==1e-05), aes(x=factor(HI_12), y=-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-05", y="", x="s (locus1|locus2)") +
	NULL

ggsave("Rec_diff_2locus_R05.pdf", height=4, width=8, units="in")

p_diff_2loc_R4<-ggplot(subset(two_locus_figure_table, R==1e-04), aes(x=factor(HI_12), y=-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-04", y="interlocus - background \n 4Ner/kb", x="s (locus1|locus2)") +
	NULL

ggsave("Rec_diff_2locus_R04.pdf", height=4, width=8, units="in")

# Multiple boxplot figures

ggarrange(p_diff_2loc_R0, p_diff_2loc_R8, p_diff_2loc_R7, p_diff_2loc_R6, p_diff_2loc_R5, nrow=5)

ggsave("Paper_Figure_Boxplot_diff.pdf", height=14, width=6, units="in")

##############################################
##### Graphs of 1-locus cases. x-axis is #####
##### the selection coefficient. y-axis  #####
##### is mean rho. color by recombina    #####
##### tion rate (for the first graph).   #####
##############################################

single_locus_figure_table<-allcases_figure_table[which(allcases_figure_table$HI_1==0),]

p_diff_1loc<-ggplot(single_locus_figure_table, aes(x=HI_2, y=-diff_mean)) +
	geom_point(aes(color=R)) +
	NULL

ggsave("Rec_diff_1locus_all.pdf", height=4, width=5, units="in")



p_diff_1loc_R0<-ggplot(subset(single_locus_figure_table, R==0), aes(x=factor(HI_2), y=medianloci_mean-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_median_1locus_R0.pdf", height=4, width=5, units="in")

p_diff_1loc_R8<-ggplot(subset(single_locus_figure_table, R==1e-08), aes(x=factor(HI_2), y=medianloci_mean-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_median_1locus_R08.pdf", height=4, width=5, units="in")

p_diff_1loc_R7<-ggplot(subset(single_locus_figure_table, R==1e-07), aes(x=factor(HI_2), y=medianloci_mean-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_median_1locus_R07.pdf", height=4, width=5, units="in")

p_diff_1loc_R6<-ggplot(subset(single_locus_figure_table, R==1e-06), aes(x=factor(HI_2), y=medianloci_mean-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_median_1locus_R06.pdf", height=4, width=5, units="in")

p_diff_1loc_R5<-ggplot(subset(single_locus_figure_table, R==1e-05), aes(x=factor(HI_2), y=medianloci_mean-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_median_1locus_R05.pdf", height=4, width=5, units="in")

p_diff_1loc_R4<-ggplot(subset(single_locus_figure_table, R==1e-04), aes(x=factor(HI_2), y=medianloci_mean-diff_mean, color=factor(HI_2))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme(legend.position="none") +
	NULL

ggsave("Rec_median_1locus_R04.pdf", height=4, width=5, units="in")


##############################################
##### Graphs of 2-locus cases. x-axis is #####
##### the selection coefficient. y-axis  #####
##### is the mean rho. color by recombi- #####
##### nation rate (for the first graph). #####
##############################################

two_locus_figure_table<-allcases_figure_table[which(allcases_figure_table$HI_1!=0 | allcases_figure_table$HI_2==0),]

two_locus_figure_table$HI_12<-paste(two_locus_figure_table$HI_1, two_locus_figure_table$HI_2, sep="|")

two_locus_figure_table$HI_12<-as.factor(two_locus_figure_table$HI_12)

two_locus_figure_table$HI_12<-relevel(two_locus_figure_table$HI_12, "0|0")

p_median_2loc<-ggplot(two_locus_figure_table, aes(x=HI_12, y=medianloci_mean-diff_mean)) +
	geom_point(aes(color=R)) +
	NULL

ggsave("Rec_median_1locus_all.pdf", height=4, width=5, units="in")



p_median_2loc_R0<-ggplot(subset(two_locus_figure_table, R==0), aes(x=factor(HI_12), y=medianloci_mean-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=0", y="", x="") +
	NULL

ggsave("Rec_median_2locus_R0.pdf", height=4, width=8, units="in")

p_median_2loc_R8<-ggplot(subset(two_locus_figure_table, R==1e-08), aes(x=factor(HI_12), y=medianloci_mean-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-08", y="", x="") +
	NULL

ggsave("Rec_median_2locus_R08.pdf", height=4, width=8, units="in")

p_median_2loc_R7<-ggplot(subset(two_locus_figure_table, R==1e-07), aes(x=factor(HI_12), y=medianloci_mean-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-07", y="median\n 4Ner/kb", x="") +
	NULL

ggsave("Rec_median_2locus_R07.pdf", height=4, width=8, units="in")

p_median_2loc_R6<-ggplot(subset(two_locus_figure_table, R==1e-06), aes(x=factor(HI_12), y=medianloci_mean-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-06", y="", x="") +
	NULL

ggsave("Rec_median_2locus_R06.pdf", height=4, width=8, units="in")

p_median_2loc_R5<-ggplot(subset(two_locus_figure_table, R==1e-05), aes(x=factor(HI_12), y=medianloci_mean-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-05", y="", x="s (locus1|locus2)") +
	NULL

ggsave("Rec_median_2locus_R05.pdf", height=4, width=8, units="in")

p_median_2loc_R4<-ggplot(subset(two_locus_figure_table, R==1e-04), aes(x=factor(HI_12), y=medianloci_mean-diff_mean, color=factor(HI_12))) +
	geom_boxplot() +
	geom_jitter(width=0.2) +
	theme_minimal() +
	theme(legend.position="none", axis.text.x=element_text(angle=45, hjust = 1)) +
	labs(title="r=1e-04", y="median \n 4Ner/kb", x="s (locus1|locus2)") +
	NULL

ggsave("Rec_median_2locus_R04.pdf", height=4, width=8, units="in")

# Multiple boxplot figures

ggarrange(p_median_2loc_R0, p_median_2loc_R8, p_median_2loc_R7, p_median_2loc_R6, p_median_2loc_R5, nrow=5)

ggsave("Paper_Figure_Boxplot_median.pdf", height=14, width=6, units="in")


##############################################
##### Scatterplots for pairs of relevant #####
##### variables.            #####
##############################################

# Pearson's correlation tests for all of the pairs of variables in the following figures

cor_table<-data.frame(cor=0, p.value=0, text="")

test_tmp<-cor.test(log10(subset(allcases_figure_table, R!=0)$R), -subset(allcases_figure_table, R!=0)$diff_mean)
cor_table[1,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(log10(subset(allcases_figure_table, R!=0)$R), subset(allcases_figure_table, R!=0)$mean95_mean)
cor_table[2,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==0)$HI_1, -subset(allcases_figure_table, R!=0)$diff_mean)
cor_table[3,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-04)$HI_1, -subset(allcases_figure_table, R==1e-04)$diff_mean)
cor_table[4,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-05)$HI_1, -subset(allcases_figure_table, R==1e-05)$diff_mean)
cor_table[5,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-06)$HI_1, -subset(allcases_figure_table, R==1e-06)$diff_mean)
cor_table[6,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-07)$HI_1, -subset(allcases_figure_table, R==1e-07)$diff_mean)
cor_table[7,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-08)$HI_1, -subset(allcases_figure_table, R==1e-08)$diff_mean)
cor_table[8,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==0)$HI_1, subset(allcases_figure_table, R==0)$mean95_mean)
cor_table[9,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-04)$HI_1, subset(allcases_figure_table, R==1e-04)$mean95_mean)
cor_table[10,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-05)$HI_1, subset(allcases_figure_table, R==1e-05)$mean95_mean)
cor_table[11,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-06)$HI_1, subset(allcases_figure_table, R==1e-06)$mean95_mean)
cor_table[12,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-07)$HI_1, subset(allcases_figure_table, R==1e-07)$mean95_mean)
cor_table[13,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-08)$HI_1, subset(allcases_figure_table, R==1e-08)$mean95_mean)
cor_table[14,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==0)$HI_2, -subset(allcases_figure_table, R==0)$diff_mean)
cor_table[15,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-04)$HI_2, -subset(allcases_figure_table, R==1e-04)$diff_mean)
cor_table[16,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-05)$HI_2, -subset(allcases_figure_table, R==1e-05)$diff_mean)
cor_table[17,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-06)$HI_2, -subset(allcases_figure_table, R==1e-06)$diff_mean)
cor_table[18,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-07)$HI_2, -subset(allcases_figure_table, R==1e-07)$diff_mean)
cor_table[19,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-08)$HI_2, -subset(allcases_figure_table, R==1e-08)$diff_mean)
cor_table[20,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==0)$HI_2, subset(allcases_figure_table, R==0)$mean95_mean)
cor_table[21,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-04)$HI_2, subset(allcases_figure_table, R==1e-04)$mean95_mean)
cor_table[22,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-05)$HI_2, subset(allcases_figure_table, R==1e-05)$mean95_mean)
cor_table[23,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-06)$HI_2, subset(allcases_figure_table, R==1e-06)$mean95_mean)
cor_table[24,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-07)$HI_2, subset(allcases_figure_table, R==1e-07)$mean95_mean)
cor_table[25,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))
test_tmp<-cor.test(subset(allcases_figure_table, R==1e-08)$HI_2, subset(allcases_figure_table, R==1e-08)$mean95_mean)
cor_table[26,]<-c(test_tmp$estimate, test_tmp$p.value, paste("cor=", signif(test_tmp$estimate, 2), " p=", signif(test_tmp$p.value, 2), sep=''))



# Full table R vs diff and mean 95% interval

p_scat_R_diff<-ggplot(allcases_figure_table, aes(x=R, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	NULL

ggsave("Scat_R_diff.pdf", height=4, width=5, units="in")

p_scat_R_95<-ggplot(allcases_figure_table, aes(x=R, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	NULL

ggsave("Scat_R_95.pdf", height=4, width=5, units="in")

ggarrange(p_scat_R_diff, p_scat_R_95, ncol=2)

ggsave("Scat_Mult_R_95_diff.pdf", height=4, width=8, units="in")

# By R, first locus max selection vs diff


p_scat_R0_HI1_diff<-ggplot(subset(allcases_figure_table, R==0), aes(x=HI_1, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=0\n", cor_table[3,3], sep=""), x="", y="interlocus - background \n 4Ner/kb") +
	theme_minimal() +
	NULL

ggsave("Scat_R0_HI1_diff.pdf", height=4, width=5, units="in")

p_scat_R04_HI1_diff<-ggplot(subset(allcases_figure_table, R==1e-04), aes(x=HI_1, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-04\n", cor_table[4,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R04_HI1_diff.pdf", height=4, width=5, units="in")

p_scat_R05_HI1_diff<-ggplot(subset(allcases_figure_table, R==1e-05), aes(x=HI_1, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-05\n", cor_table[5,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R05_HI1_diff.pdf", height=4, width=5, units="in")

p_scat_R06_HI1_diff<-ggplot(subset(allcases_figure_table, R==1e-06), aes(x=HI_1, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-06\n", cor_table[6,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R06_HI1_diff.pdf", height=4, width=5, units="in")

p_scat_R07_HI1_diff<-ggplot(subset(allcases_figure_table, R==1e-07), aes(x=HI_1, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-07\n", cor_table[7,3], sep=""), x="Locus 1 selection coefficient", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R07_HI1_diff.pdf", height=4, width=5, units="in")

p_scat_R08_HI1_diff<-ggplot(subset(allcases_figure_table, R==1e-08), aes(x=HI_1, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-08\n", cor_table[8,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R08_HI1_diff.pdf", height=4, width=5, units="in")

ggarrange(p_scat_R0_HI1_diff, p_scat_R08_HI1_diff, p_scat_R07_HI1_diff, p_scat_R06_HI1_diff, p_scat_R05_HI1_diff, p_scat_R04_HI1_diff, nrow=1)

ggsave("Scat_Mult_HI1_diff.pdf", height=2, width=12, units="in")

# By R, first locus max selection vs 95% confidence interval


p_scat_R0_HI1_95<-ggplot(subset(allcases_figure_table, R==0), aes(x=HI_1, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=0\n", cor_table[9,3], sep=""), x="", y="mean 95% range of \n recombination rate estimates") +
	theme_minimal() +
	NULL

ggsave("Scat_R0_HI1_95.pdf", height=4, width=5, units="in")

p_scat_R04_HI1_95<-ggplot(subset(allcases_figure_table, R==1e-04), aes(x=HI_1, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-04\n", cor_table[10,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R04_HI1_95.pdf", height=4, width=5, units="in")

p_scat_R05_HI1_95<-ggplot(subset(allcases_figure_table, R==1e-05), aes(x=HI_1, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-05\n", cor_table[11,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R05_HI1_95.pdf", height=4, width=5, units="in")

p_scat_R06_HI1_95<-ggplot(subset(allcases_figure_table, R==1e-06), aes(x=HI_1, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-06\n", cor_table[12,3, sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R06_HI1_95.pdf", height=4, width=5, units="in")

p_scat_R07_HI1_95<-ggplot(subset(allcases_figure_table, R==1e-07), aes(x=HI_1, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-07\n", cor_table[13,3], sep=""), x="Locus 1 selection coefficient", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R07_HI1_95.pdf", height=4, width=5, units="in")

p_scat_R08_HI1_95<-ggplot(subset(allcases_figure_table, R==1e-08), aes(x=HI_1, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("r=1e-08\n", cor_table[14,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R08_HI1_95.pdf", height=4, width=5, units="in")

ggarrange(p_scat_R0_HI1_95, p_scat_R08_HI1_95, p_scat_R07_HI1_95, p_scat_R06_HI1_95, p_scat_R05_HI1_95, p_scat_R04_HI1_95, nrow=1)

ggsave("Scat_Mult_HI1_95.pdf", height=2, width=12, units="in")

# By R, second locus max selection vs diff


p_scat_R0_HI2_diff<-ggplot(subset(allcases_figure_table, R==0), aes(x=HI_2, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[15,3], sep=""), x="", y="interlocus - background \n 4Ner/kb") +
	theme_minimal() +
	NULL

ggsave("Scat_R0_HI2_diff.pdf", height=4, width=5, units="in")

p_scat_R04_HI2_diff<-ggplot(subset(allcases_figure_table, R==1e-04), aes(x=HI_2, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[16,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R04_HI2_diff.pdf", height=4, width=5, units="in")

p_scat_R05_HI2_diff<-ggplot(subset(allcases_figure_table, R==1e-05), aes(x=HI_2, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[17,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R05_HI2_diff.pdf", height=4, width=5, units="in")

p_scat_R06_HI2_diff<-ggplot(subset(allcases_figure_table, R==1e-06), aes(x=HI_2, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[18,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R06_HI2_diff.pdf", height=4, width=5, units="in")

p_scat_R07_HI2_diff<-ggplot(subset(allcases_figure_table, R==1e-07), aes(x=HI_2, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[19,3], sep=""), x="Locus 2 selection coefficient", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R07_HI2_diff.pdf", height=4, width=5, units="in")

p_scat_R08_HI2_diff<-ggplot(subset(allcases_figure_table, R==1e-08), aes(x=HI_2, y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[20,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R08_HI2_diff.pdf", height=4, width=5, units="in")

ggarrange(p_scat_R0_HI2_diff, p_scat_R08_HI2_diff, p_scat_R07_HI2_diff, p_scat_R06_HI2_diff, p_scat_R05_HI2_diff, p_scat_R04_HI2_diff, nrow=1)

ggsave("Scat_Mult_HI2_diff.pdf", height=2, width=12, units="in")

# By R, second locus max selection vs 95% confidence interval


p_scat_R0_HI2_95<-ggplot(subset(allcases_figure_table, R==0), aes(x=HI_2, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[21,3], sep=""), x="", y="mean 95% range of \n recombination rate estimates") +
	theme_minimal() +
	NULL

ggsave("Scat_R0_HI2_95.pdf", height=4, width=5, units="in")

p_scat_R04_HI2_95<-ggplot(subset(allcases_figure_table, R==1e-04), aes(x=HI_2, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[22,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R04_HI2_95.pdf", height=4, width=5, units="in")

p_scat_R05_HI2_95<-ggplot(subset(allcases_figure_table, R==1e-05), aes(x=HI_2, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[23,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R05_HI2_95.pdf", height=4, width=5, units="in")

p_scat_R06_HI2_95<-ggplot(subset(allcases_figure_table, R==1e-06), aes(x=HI_2, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[24,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R06_HI2_95.pdf", height=4, width=5, units="in")

p_scat_R07_HI2_95<-ggplot(subset(allcases_figure_table, R==1e-07), aes(x=HI_2, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[25,3], sep=""), x="Locus 2 selection coefficient", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R07_HI2_95.pdf", height=4, width=5, units="in")

p_scat_R08_HI2_95<-ggplot(subset(allcases_figure_table, R==1e-08), aes(x=HI_2, y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	labs(title=paste("", cor_table[26,3], sep=""), x="", y="") +
	theme_minimal() +
	NULL

ggsave("Scat_R08_HI2_95.pdf", height=4, width=5, units="in")

ggarrange(p_scat_R0_HI2_95, p_scat_R08_HI2_95, p_scat_R07_HI2_95, p_scat_R06_HI2_95, p_scat_R05_HI2_95, p_scat_R04_HI2_95, nrow=1)

ggsave("Scat_Mult_HI2_95.pdf", height=2, width=12, units="in")

# Make a figure that has the scatter plots for both selection coefficients and diff_mean
# These scatter plots will be for 0, 08, 0.7, 06, and 05
# 04 is excluded because it hits LDhat's limit of recombination rate

p_scat_diff<-ggarrange(p_scat_R0_HI1_diff, p_scat_R08_HI1_diff, p_scat_R07_HI1_diff, p_scat_R06_HI1_diff, p_scat_R05_HI1_diff, p_scat_R0_HI2_diff, p_scat_R08_HI2_diff, p_scat_R07_HI2_diff, p_scat_R06_HI2_diff, p_scat_R05_HI2_diff, nrow=2, ncol=5) +
	border() +
	NULL

ggsave("Paper_Figure_Scatter_diff.pdf", height=5, width=12, units="in")


# Same as above, but for mean95_mean

p_scat_95<-ggarrange(p_scat_R0_HI1_95, p_scat_R08_HI1_95, p_scat_R07_HI1_95, p_scat_R06_HI1_95, p_scat_R05_HI1_95, p_scat_R0_HI2_95, p_scat_R08_HI2_95, p_scat_R07_HI2_95, p_scat_R06_HI2_95, p_scat_R05_HI2_95, nrow=2, ncol=5) +
	border() +
	NULL

ggsave("Paper_Figure_Scatter_95.pdf", height=5, width=12, units="in")


# Make scatter plots for -log10 of the recombination rate vs diff and 95


p_scat_logR_diff<-ggplot(subset(allcases_figure_table, R!=1e-04), aes(x=log10(R), y=-diff_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	theme_minimal() +
	labs(title=cor_table[1,3], x="log10(r)", y="interlocus - background \n 4Ner/kb") +
	NULL

ggsave("Scat_logR_diff.pdf", height=4, width=5, units="in")

p_scat_logR_95<-ggplot(subset(allcases_figure_table, R!=1e-04), aes(x=log10(R), y=mean95_mean)) +
	geom_point() +
	geom_smooth(method = "lm") +
	theme_minimal() +
	labs(title=cor_table[2,3], x="log10(r)", y="mean 95% range of \n recombination rate estimates") +
	NULL

ggsave("Scat_logR_95.pdf", height=4, width=5, units="in")

p_scat_logR<-ggarrange(p_scat_logR_diff, p_scat_logR_95, ncol=2) + border()

ggsave("Paper_Figure_Scatter_logR_95_diff.pdf", height=4, width=8, units="in")

# Figure 3 in the paper. Group of scatterplots

ggarrange(p_scat_logR, p_scat_diff, p_scat_95, labels=c("A", "B", "C"), nrow=3)

ggsave("Paper_Figures_Scatter_All.pdf", height=16, width=12, units="in")

##############################################
##### Run some linear regressions.       #####
##############################################

allcases_figure_table$diff_mean_adj<-allcases_figure_table$medianloci_mean/(allcases_figure_table$medianloci_mean-allcases_figure_table$diff_mean)

regress_1<-lm(diff_mean_adj ~ R + HI_1 * HI_2, data=subset(allcases_figure_table, R!=1e-04))

regress_2<-lm(-diff_mean ~ R + HI_1 * HI_2, data=subset(allcases_figure_table, R!=1e-04))

regress_3<-lm(-diff_mean ~ mean95_mean, data=subset(allcases_figure_table, R!=1e-04))

regress_4<-lm(mean95_mean ~ R + HI_1 * HI_2, data=subset(allcases_figure_table, R!=1e-04))

regress_5<-lm(diff_mean_adj ~ mean95_mean, data=subset(allcases_figure_table, R!=1e-04))

regress_6<-lm(diff_mean_adj ~ mean95_mean + R, data=subset(allcases_figure_table, R!=1e-04))

##############################################
##### Five recombination maps. Each one  #####
##### showing the recombination rate     #####
##### an example run with no selection,  #####
##### an example of the case with high-  #####
##### est diff with 1-locus selection,   #####
##### and an example of the 2-locus case #####
##### with highest diff.    #####
##############################################

# First, I pick the example cases by finding the highest diff (in magnitude, the sign I gave it is not intuitive) for each recombination rate
# Like so:
#
# One-locus case:
#
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-04 & HI_1==0), 1)
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-05 & HI_1==0), 1)
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-06 & HI_1==0), 1)
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-07 & HI_1==0), 1) #### Can't do 1e-07, only no selection and two locus survived the parameter reduction
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-08 & HI_1==0), 1)
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==0 & HI_1==0), 1)
#
# Two-locus case:
#
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-04 & HI_1!=0), 1)
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-05 & HI_1!=0), 1)
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-06 & HI_1!=0), 1)
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-07 & HI_1!=0), 1)
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==1e-08 & HI_1!=0), 1)
# head(subset(allcases_figure_table[order(allcases_figure_table$diff_mean),c(4,5,12,13)], R==0 & HI_1!=0), 1)
#
# I get the case number from the row name plus one
#
# I also pick the all-zeros case for each recombination rate
# Like so:
#
# head(subset(allcases_figure_table[,c(4,5,12,13)], R==1e-05), 1)
# etc.


# Second, I read the corresponding table (I extracted case numbers manually). I selected the specific replicate randomly.

nosel_recmap_04<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_2/SLiM_case_2_411.res.txt", header=T)
locus1_recmap_04<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_245/SLiM_case_245_25.res.txt", header=T)
locus2_recmap_04<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_693/SLiM_case_693_362.res.txt", header=T)


nosel_recmap_05<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_3/SLiM_case_3_398.res.txt", header=T)
locus1_recmap_05<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_823/SLiM_case_823_48.res.txt", header=T)
locus2_recmap_05<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_833/SLiM_case_833_357.res.txt", header=T)

nosel_recmap_06<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_4/SLiM_case_4_106.res.txt", header=T)
locus1_recmap_06<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_134/SLiM_case_134_397.res.txt", header=T)
locus2_recmap_06<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_329/SLiM_case_329_419.res.txt", header=T)

nosel_recmap_08<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_6/SLiM_case_6_430.res.txt", header=T)
locus1_recmap_08<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_214/SLiM_case_214_420.res.txt", header=T)
locus2_recmap_08<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_426/SLiM_case_426_428.res.txt", header=T)

nosel_recmap_0<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_1/SLiM_case_1_368.res.txt", header=T)
locus1_recmap_0<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_187/SLiM_case_187_62.res.txt", header=T)
locus2_recmap_0<-read.table("/scratch/user/e.jimenezschwarzkop/20210218_214047/4.LDhat_output/case_202/SLiM_case_202_83.res.txt", header=T)

# Third, I make tables with which to make figures

recmap_table_04<-melt(list(NoSel=nosel_recmap_04[-1,], Locus1=locus1_recmap_04[-1,], Locus2=locus2_recmap_04[-1,]), id.vars="Loci", measure.vars="Median")
recmap_table_05<-melt(list(NoSel=nosel_recmap_05[-1,], Locus1=locus1_recmap_05[-1,], Locus2=locus2_recmap_05[-1,]), id.vars="Loci", measure.vars="Median")
recmap_table_06<-melt(list(NoSel=nosel_recmap_06[-1,], Locus1=locus1_recmap_06[-1,], Locus2=locus2_recmap_06[-1,]), id.vars="Loci", measure.vars="Median")
recmap_table_08<-melt(list(NoSel=nosel_recmap_08[-1,], Locus1=locus1_recmap_08[-1,], Locus2=locus2_recmap_08[-1,]), id.vars="Loci", measure.vars="Median")
recmap_table_0<-melt(list(NoSel=nosel_recmap_0[-1,], Locus1=locus1_recmap_0[-1,], Locus2=locus2_recmap_0[-1,]), id.vars="Loci", measure.vars="Median")



p_recmap_04<-ggplot(recmap_table_04, aes(x=Loci, y=value, color=L1)) +
	geom_line() +
	NULL

ggsave("Recmap_R04.pdf", height=4, width=8, units="in")

p_recmap_05<-ggplot(recmap_table_05, aes(x=Loci, y=value, color=L1)) +
	geom_line() +
	NULL

ggsave("Recmap_R05.pdf", height=4, width=8, units="in")

p_recmap_06<-ggplot(recmap_table_06, aes(x=Loci, y=value, color=L1)) +
	geom_line() +
	NULL

ggsave("Recmap_R06.pdf", height=4, width=8, units="in")

p_recmap_08<-ggplot(recmap_table_08, aes(x=Loci, y=value, color=L1)) +
	geom_line() +
	NULL

ggsave("Recmap_R08.pdf", height=4, width=8, units="in")

p_recmap_0<-ggplot(recmap_table_0, aes(x=Loci, y=value, color=L1)) +
	geom_line() +
	NULL

ggsave("Recmap_R0.pdf", height=4, width=8, units="in")




############# NEXT UP (but after I run the boxplots for 2-locus selection cases):
#############		- Come back to this, but subtract min(Median) for each case. 
#############		- Also, check the .rec files. Something is up, because the diff values should be larger...

############ MANUAL STUFF I WANT TO DO TO EXTRACT THE GROUPS OF PARAMETER SETS FOR EACH OF THE VARIABLES

install.packages("BAMMtools")
library(BAMMtools)

getJenksBreaks(diff_figure_table$mean, 4)
getJenksBreaks(mean95_figure_table$mean, 6)
getJenksBreaks(mediansd_figure_table$mean, 8)# I want to group all of the lower groups into one. Essentiall anything < 3.980542e+01




diff_group1_params<-rownames(diff_figure_table[which(diff_figure_table$mean < diff_breaks[2]),])
parameter_sets[diff_group1_params,]
diff_group2_params<-rownames(diff_figure_table[which(diff_figure_table$mean > diff_breaks[2] & diff_figure_table$mean < diff_breaks[3]),])
parameter_sets[diff_group2_params,]













