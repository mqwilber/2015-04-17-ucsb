# ggplot lesson exercise answers

# Exercise 1:

### Answer to Exercise 1: ###
dat<-read.csv("C://Users//Thomas//Documents//2015-04-17-ucsb//data//aneurysm_data_site-1.csv", header = TRUE)
index_m<-dat$Gender=='m'
index_f<-dat$Gender=='f'
index_M<-dat$Gender=='M'
index_F<-dat$Gender=='F'
#
dat$GenderCorrected<-NULL
dat$GenderCorrected[index_f]<-"Female"
dat$GenderCorrected[index_F]<-"Female"
dat$GenderCorrected[index_m]<-"Male"
dat$GenderCorrected[index_M]<-"Male"
#
#par(mar=c(5,5,1,1))
#boxplot(BloodPressure~GenderCorrected, data=dat, 
#        ylim=c(50,200),
#        ylab=c("Blood Pressure (mm Hg)"), xlab=c("Gender"),
#        col="light grey",
#        cex.axis=2, cex.lab=2, 
#        font.lab=2,
#        lwd=4)
#abline(mean(dat$BloodPressure),0)

#answer:
# a) Reproduce the boxplot of Blood Pressure vs. Gender (the `aneurysm` data we were calling `dat` yesterday) using your new `ggplot2` skills.
#Part A:
ggplot(data=dat, aes(x=GenderCorrected, y=BloodPressure))+
  geom_boxplot()

# b) What can you do to see if the pattern is similar throughout all three Groups?
#Part B:
ggplot(data=dat, aes(x=GenderCorrected, y=BloodPressure))+
  geom_boxplot()+
  facet_wrap(~Group)



### Answer to Exercise 2: ###
# Using the `iris` data, create a faceted figure that includes three panels, one for each species; each panel should include a scatter plot of Petal.Width vs. Petal.Length; lastly, include a linear fit on each panel.  Manipulate the theme to improve the appearance of the figure.
str(iris)
ggplot(data=iris, aes(x=Petal.Length, y=Petal.Width))+
  geom_point()+
  geom_smooth(method="lm")+
  facet_wrap(~Species, scales="free_x")+
  theme()