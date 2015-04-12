### Answer to Exercise 1 ###

# 1.

element <- c("o", "x", "y", "g", "e", "n")
element[4:1]

# 2a. element[-1] is everything but the first element
# 2b. element[-4] is everything but element 4
# 2c. element[-1:-4] returns ["e", "n"]

# 3.

dat <- read.csv("aneurysm_data_site-1.csv", header=TRUE)
index <- dat$Gender == 'm'
dat[index,]

### Answer to Exercise 2 ###

index_m<-dat$Gender=='m'
index_f<-dat$Gender=='f'

dat[index_m,2]<-'M'
dat[index_f,2]<-'F'

### Answers to Exercise 3 ###

exprmt <- factor(exprmt, levels=c("treat1", "treat2", "treat3", "control"))
barplot(table(exprmt))

### Answers to Exercise 4 ###

dat['min_aneurysm'] <- apply(dat[, 6:9], 1, min)
write.csv(dat, "updated_data.csv")
new_dat <- read.csv("updated_data.csv", header=T)

### Answer to Exercise 5 ###

boxplot(BloodPressure~GenderCorrected, data=dat)

#Or something like:

jpeg("file path/boxplot.jpg") 
par(mar=c(5,5,1,1))                 ###this sets the margins within the plot device
boxplot(BloodPressure~GenderCorrected, data=dat, 
        ylim=c(50,200),
        ylab=c("Blood Pressure (mm Hg)"), xlab=c("Gender"),
        col="light grey",
        cex.axis=2, cex.lab=2, 
        font.lab=2,
        lwd=4)
abline(mean(dat$BloodPressure),0)
dev.off()


### Answers for Exercises 5-8 ###

clean_data <- function(data){
  # Clean a dataset

  data$Gender[data$Gender == 'm'] = 'M'
  data$Gender[data$Gender == 'f'] = 'F'
  data <- droplevels(data)
  return(data)

}

analyze <- function(filename){
  # A function that plots and analyzes aneurysm data

  # 1. Load in data in filename and save it to a variable
  tdata <- read.csv(filename, header=TRUE)

  # 2. Clean your data
  tdata <- clean_data(tdata)

  # 3. Define a new response that is the mean number of anuerysms
  tdata['avg_an'] <- rowMeans(tdata[, 6:9])

  # 4. Visualize your data with a few plots
  boxplot(avg_an ~ Gender, data=tdata, main=filename)

  # 5. Run an analysis for each dataset and output results
  fit <- lm(avg_an ~ Gender + Group + BloodPressure, data=tdata)
  results <- anova(fit)
  return(results)

}

# Loop over all five datasets
all_files <- list.files(pattern="aneurysm")
for(filename in all_files){
  print(analyze(filename))
}

