# Install and load required packages
install.packages("devtools") # if "devtools" is not installed already
install.packages("Rcpp")
install.packages("tidyverse")
install.packages("igraph")
install.packages("plotly")
install.packages("genio")
devtools::install_github("uqrmaie1/admixtools")
library("admixtools")
library("genio")
library("ggplot2")


# F3 statistics with all the coloured groups together in the form f3(Coloured, Population, CHB\_EAS)
coloured_population_together<-c('Coloured')
westafrican_or_bantu<- c('Mandinka', 'YRI_AFR', 'Wolof','Bitonga', 'Pedi', 'Xhosa', 'Zulu', 'Sotho')
asian<-c('CHB_EAS')

f3_values_coloured_westafrican_or_bantu <- qp3pop('/plink_file_directory',coloured_population_together,westafrican_or_bantu,asian)
sorted_f3_values_coloured_westafrican_or_bantu <- f3_values_coloured_westafrican_or_bantu[order(f3_values_coloured_westafrican_or_bantu$est), ]
print(sorted_f3_values_coloured_westafrican_or_bantu, n = 72)

# Create a new column for the row numbers
sorted_f3_values_coloured_westafrican_or_bantu$row_number <- seq_len(nrow(sorted_f3_values_coloured_westafrican_or_bantu))

# Plot
f3_Asian_WestAfr_Bantu <- ggplot(sorted_f3_values_coloured_westafrican_or_bantu, aes(x = est, y = -row_number)) +
  geom_point() +
  geom_errorbarh(aes(xmin = est - 2 * se, xmax = est + 2 * se), height = 0) +
  scale_y_continuous(breaks = -seq(1, length(sorted_f3_values_coloured_westafrican_or_bantu$row_number), by = ceiling(length(sorted_f3_values_coloured_westafrican_or_bantu$row_number)/72)),
                     labels = sorted_f3_values_coloured_westafrican_or_bantu$pop2,
                     expand = c(0.007, 0))+
  labs(x = "f3(Coloured, Population, CHB_EAS)", y ="")+
  theme_bw()+
  theme(panel.grid.minor.y = element_blank())




# F3 statistics with all the coloured groups together in the form f3(Coloured, Population, Yoruba)
coloured_population_together<-c('Coloured')
madagascar_or_asian<- c('Mikea','Temoro','Vezo','STU_SAS','GIH_SAS','KHV_EAS','CHB_EAS')
west_african<-c('YRI_AFR')

f3_values_coloured_asian_madagascar <- qp3pop('/plink_file_directory',coloured_population_together,madagascar_or_asian, west_african)
sorted_f3_values_coloured_asian_madagascar <- f3_values_coloured_asian_madagascar[order(f3_values_coloured_asian_madagascar$est), ]
print(sorted_f3_values_coloured_asian_madagascar, n = 63)

# Create a new column for the row numbers
sorted_f3_values_coloured_asian_madagascar$row_number <- seq_len(nrow(sorted_f3_values_coloured_asian_madagascar))

# Plot
f3_KS_Asian_madagascar <- ggplot(sorted_f3_values_coloured_asian_madagascar, aes(x = est, y = -row_number)) +
  geom_point() +
  geom_errorbarh(aes(xmin = est - 2 * se, xmax = est + 2 * se), height = 0) +
  scale_y_continuous(breaks = -seq(1, length(sorted_f3_values_coloured_asian_madagascar$row_number), by = ceiling(length(sorted_f3_values_coloured_asian_madagascar$row_number)/63)),
                     labels = sorted_f3_values_coloured_asian_madagascar$pop2,
                     expand = c(0.007, 0))+
  labs(x = "f3(Coloured, Population, YRI_AFR)", y ="")+
  theme_bw()+
  theme(panel.grid.minor.y = element_blank())




