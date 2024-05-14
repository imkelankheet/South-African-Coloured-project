# Load the required libraries
library(ggplot2)
library(scales)
library(dplyr)

########
# This script takes the X and autosomal proportions as gotten from supervised ADMIXTURE, and bootstraps the individuals to calculate X-to-autosomal values, with confidence intervals.
# First, we are bootstrapping all X chromosomal fractions, then all corresponding autosomal fractions, then after that calculating the x-autosomal ratio with the formula, per bootstrap.
# The average of all bootstrap x-to-autosomal values is then calculated, and the standard deviation as well.
########


# Read in the x-proportions and autosomal proportions
# Autosomal proportions are based on 9 chromosomes (1-6 (cut to 180 cM), 7, 10, and 12)
coloured_x <- read.delim("X-coloured.txt")
coloured_aut <- read.delim("Aut-coloured.txt")

# For each of the seven populations, this for loop runs bootstrapping and generates a admix ratio plot.
for (population in c("Genadendal", "Graaff-Reinet", "Greyton", "Nieu-Bethesda", "Kranshoek", "Oudtshoorn", "Prince_Albert")){
print(population)
  
# Make a dataframe where the values for the x-to-autosomal ratios are stored, together with the standard deviation
dataframe<- data.frame()  
newest_dataframe_x<- data.frame()
newest_dataframe_aut<- data.frame()
# Colors for plotting
colors=c("#D6AE73","#ED1C54","#FDE06B","#702C3F","#9A9A9D")
# Counter makes sure the colours end up with the right group in the dataframe
counter = 0

# For each of the 5 ancestries, the X-to-autosomal ratio is calculated using bootstrapping. 
# The bootstrapping is performed by resampling the indviduals with replacement. 
for (group in c("EastAfrican", "European", "KhoeSan","Asian","WestAfrican")){
  counter= counter +1
  # B is the number of Bootstrapping iterations. At least 10000 is recommended.
  B <- 10000
  
  # Select only the rows in the dataframe belonging to this population
  selected_rows_aut <- coloured_aut[coloured_aut[, 1] == population, ]
  selected_rows_x <- coloured_x[coloured_x[, 1] == population, ]
  ind <- nrow(selected_rows_aut)
  
  # Three vectors where the mean x proportions, mean autosomal proportions and ratios are stored
  bootMean_x <- vector()
  bootMean_aut <- vector()
  ratio <- vector()
  print(group)

  # Loop for bootstrap iteration
  for (i in 1:B){
    # Boostrappring begins
    # From selected_rows_x, the indexes (rows) are resampled and the sample (with replacement) is stored in bootSample_x and bootSample_aut. 
    # So each bootSample is made up of randomly sampled individuals (with replacement, so one individual can occur twice).
    indices_individuals <- sample(nrow(selected_rows_x), ind, replace =TRUE)
    bootSample_x <- selected_rows_x[indices_individuals,]
    bootSample_aut <- selected_rows_aut[indices_individuals, ]
    
    # We weigh the females twice by multiplying the female rows times two
    chromosome_corrected_samples_x <- c(rep(bootSample_x[bootSample_x$Gender == "F", group],2), bootSample_x[bootSample_x$Gender == "M", group])
    chromosome_corrected_samples_aut <-bootSample_aut[,group]
    
    # The next part calculates the ratio for this specific bootSample. It takes the average of the x-column and the 
    #average of the autosomal column, and then it calculates the ratio using these two values with the formula:
    # X-to-autosomal ratio = Fancestry,total * (Fx-Fauto)/(Fx+Fauto). As there are 9 autosomes, to calculate the Fancestry,total the 
    # autosomes weight 9 times "heavier".
    bootMean_x[i] <- mean(chromosome_corrected_samples_x)
    bootMean_aut[i] <- mean(chromosome_corrected_samples_aut)
    total_genome_ancestry <- (9*bootMean_aut[i] + bootMean_x[i])/10
    ratio[i] <- total_genome_ancestry * (bootMean_x[i]-bootMean_aut[i])/(bootMean_x[i]+bootMean_aut[i])
  }
  # From all the ratios calculated in the B nubmer of boostraps, mean_ratio contains the mean of all the ratios. sd_ratio contains 
  # the standard deviations of all these observations.
  mean_ratio <- mean(ratio)
  sd_ratio <- sd(ratio)
  lowerSD_ratio <- mean_ratio-sd_ratio
  upperSD_ratio <- mean_ratio+sd_ratio 
  quantile<- quantile(ratio, probs=c(0.025,0.975))
  quantile1<- quantile[1]
  quantile2<- quantile[2]
  color<-colors[counter]
  row <- cbind(group,mean_ratio, sd_ratio, color, lowerSD_ratio, upperSD_ratio, quantile1, quantile2)
  dataframe<- rbind(dataframe, row)
}
dataframe$mean_ratio = as.numeric(as.character(dataframe$mean_ratio))
dataframe$sd_ratio = as.numeric(as.character(dataframe$sd_ratio))
dataframe$lowerSD_ratio = as.numeric(as.character(dataframe$lowerSD_ratio))
dataframe$upperSD_ratio = as.numeric(as.character(dataframe$upperSD_ratio))
dataframe$quantile1 = as.numeric(as.character(dataframe$quantile1))
dataframe$quantile2 = as.numeric(as.character(dataframe$quantile2))
dataframe

# Save dataframe
setwd(dir = "/working_directory")
write.csv(dataframe, paste(population,"_dataframe_bootstrap_outcomes.csv", sep = ""))

# Make sure the order of the popuation is correct
dataframe$group <- factor(dataframe$group, levels = c("EastAfrican", "European", "KhoeSan","Asian","WestAfrican"))

# Plot the data in a barplot with 95% confidence bars (same as 2 standard deviations from the mean)
q <- ggplot(data=dataframe, aes(x=group, y=mean_ratio))+
  theme_bw()+
  geom_bar(stat="identity", fill=dataframe$color)+
  geom_pointrange(aes(x=group, y=mean_ratio, ymin=quantile1, ymax=quantile2), color="orange", alpha=0.9, size=1.3,linewidth = 1.3)+
  scale_x_discrete(labels=c("East African","European", "Khoe-San", "Asian", "West African"))+
  theme(axis.text = element_text(size = 22), axis.title.y = element_text(size = 22),plot.title = element_text(size = 30))+
  geom_hline(yintercept = 0)

q  <- q + labs(title=paste("N=",ind, sep=""), x="", y = "\u0394 Admix ratio")
q
  
ggplot2::ggsave(filename = paste("X-to_Aut_ratio_95_confidence_interval", population, ".jpeg", sep=""), 
                plot = q,device = NULL, dpi = 1200, width = 25, height = 25, units = "cm")
}




