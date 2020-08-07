---
title: "Reproducible Research: Peer Assessment 1 "
author: "Launia White"
date: "8/7/2020"
output: 
  html_document:
    keep_md: true
---



## Loading and preprocessing the data

```r
dat <- read_csv("~/activity.csv")
```

```
## Parsed with column specification:
## cols(
##   steps = col_double(),
##   date = col_date(format = ""),
##   interval = col_double()
## )
```
## What is mean total number of steps taken per day?

```r
ts <- aggregate(steps~date, dat, FUN=sum)
hist(ts$steps, main="Histogram of Total Steps per Day", xlab="Total Steps")
```

![](PA1_template_files/figure-html/mnsteps-1.png)<!-- -->

```r
options(scipen=999)
mnsteps <- round(mean(ts$steps), digits=1)
medsteps <- round(median(ts$steps), digits=1)
```

The mean total number of steps per day is 10766.2 and the median total number of steps taken per day is 10765.

## What is the average daily activity pattern?

```r
ms <- aggregate(steps~interval, dat, FUN=mean, na.rm=TRUE)
p1 <- ggplot() + geom_line(aes(y = steps, x = interval),
      data = ms, stat="identity") + 
  ggtitle("Mean Steps per Day by Interval") + 
  labs(x="Interval", y="Mean Steps per Day") 
p1
```

![](PA1_template_files/figure-html/pattern-1.png)<!-- -->

```r
maxsteps <- ms[order(-ms$steps),]
maxsteps <- head(maxsteps, n=1)
maxsteps$steps <- round(maxsteps$steps, digits=1)
```

Interval 835 had the maximum number of steps of 206.2.

## Imputing missing values

```r
na <- sum(is.na(dat))
```

The total number of missing values in the dataset was 2304.




```r
imputed <- dat # new dataset called imp
for (i in ms$interval) {
  imputed[imputed$interval == i & is.na(imputed$steps), ]$steps <- 
    ms$steps[ms$interval == i]
}
is <- aggregate(steps~date, imputed, FUN=sum)
hist(is$steps, main="Histogram of Total Steps per Day", xlab="Total Steps")
```

![](PA1_template_files/figure-html/impute-1.png)<!-- -->

```r
mnstepsi <- round(mean(is$steps), digits=2)
medstepsi <- round(median(is$steps), digits=2)
```
After imputation, the mean total number of steps per day was 10766.19 and the median total number of steps taken per day increased to 10766.19.

## Are there differences in activity patterns between weekdays and weekends?

```r
imputed$daytype <- ifelse(weekdays(imputed$date) %in% c("Saturday", "Sunday"), "weekend", "weekday")
msdaytype <- aggregate(steps~interval + daytype, imputed, FUN=sum, na.rm=TRUE)
p3 <- ggplot() + geom_line(aes(y = steps, x = interval),
                           size=1, data = msdaytype, stat="identity") + 
  ggtitle(" ") + 
  labs(x="Interval", y="Number of steps") 
p4 <- p3 + facet_grid(daytype ~ .)
p4
```

![](PA1_template_files/figure-html/weekday-1.png)<!-- -->


