### Answer to Exercise 1 ###

# 1.

element <- c("o", "x", "y", "g", "e", "n")
element[4:1]

# 2a. element[-1] is everything but the first element
# 2b. element[-4] is everything but element 4
# 2c. element[-1:-4] returns ["e", "n"]

# 3. 

dat = read.csv("anuerysm_data.csv", header=TRUE)
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

dat['Average_Anuerism'] = rowMeans(dat[, 6:9])
write.csv(dat, "updated_aneurism.csv")
