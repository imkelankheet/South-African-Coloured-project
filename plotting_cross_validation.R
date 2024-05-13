# Load the file with all the cross-validation values created with the script optimal_K_finding.sh
crossvalidation <- read.table("ADMX_COL.CV.txt")

# Calculate the average cross-validation per K
averages <-aggregate(crossvalidation$V2, list(crossvalidation$V1), FUN=mean) 

# Smallest cross-validation value
minimum=min(averages)

# Plot (and save) with cross-validation for each K, with a horizontal line for the smallest K
png(file="/<directory>/Cross-validation.png",width = 5, height = 6, units = 'in', res = 300)
par(mar = c(5, 5, 2, 2) ,cex=0.7,cex.lab = 2)
plot(x$Group.1, x$x, xlab = "K", ylab = "Cross-validation error", pch = 16, type = "o", panel.first=grid())
abline(h=minimum,col="blue")
dev.off()
