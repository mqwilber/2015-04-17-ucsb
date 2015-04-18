---
layout: lesson
root: ../..
title: Big Data with R
---

*Prepared by Tom Bell, using code written by Luke Miller*

Before we start this lesson we will have to install packages ncdf and fields    

    install.packages("ncdf")  
    install.packages("fields") 
    library(ncdf) 
    library(fields)  
    
Goals
-----
By the end of the lesson, you will be able to download daily sea surface temperature data for the entire globe, select you areas of interest, and create a short time series   

These skills can be used to create longer time series and convert data from various sensors into data you can use for your own research. This can be as simple as a sanity check for your own field sensors, or as complex as using the data as inputs for global models. I have had many people come to me and ask for time series of these global datasets, so there is an obivious need in the community. I hope that this short lesson will give you some of the basic knowledge on how to retrieve these data for the specific projects you are working on

Background
------
 1. *What is big data?*   
    Big data is a broad term for datasets that are so large or complex that they defy traditional data processing applications. Today we are going to focus on remotely sensed data. Luckily for us, while these data matrices are large, most are neatly organized by government agencies and many are freely available

 2. *How can we use it for our purposes?*  
 Most of us could use time series of environmental variables to examine how organisms or systems respond to these temporal and spatial changes. We don't have unlimited time and money to outfit every site with various sensors, however we can get many of these environmental variables from existing resources online. We can track changing vegetation greenness with NDVI, photosynthetically active radiation, land and sea surface temperature, or phytoplankton biomass, etc.
    
 3. *Why can’t I just download it?*  
 We can and we can't. Today we will be talking about data collected daily from satellites. These sensors on board satellite vehicles measure Earth's radiance or emitted energy in digital number (DN) units, the number of which vary depending on the bit number of the sensor. For example, an 8-bit sensor (like Landsat 5 TM) measures radiance in a particular band as integers between 0-255, or 2^8. Also for ease of data storage, these large datasets may be stored as 16-bit signed or unsigned integers. This means that most of the time the numbers you see aren't in the units you are really interested in. Many of these data files are stored in unfamiliar file types like hdf4, hdf5, and netCDF. These types of files contain both the data and the metadata, which will allow you to convert these DN's into the units you are intestest in. This usually means that the metadata will contain an equation to convert these integers to real units, as well as spatial information, like coordinates and elevation, or temporal information, like the time and day the image was acquired
 
 4. *Why are you still talking Tom? I want to get started!*  
 OK!
 
First we will have to download a few netCDF SST files and an R script will will use later on. 

 **Supplementary Material**: [R script](NOAA_OISST_function.R), [Data in Dropbox](https://www.dropbox.com/sh/di6a3dggx3419n7/AACLDkENBxDGCnnPLbjsZ2Wga?dl=0)

Downloading and Loading Data
-----  
For this lesson we are downloading 4 netCDF sea surface temperature files from the NOAA 1/4° daily Optimum Interpolation Sea Surface Temperature (or daily OISST), as well as one yearly SST file. These files are an analysis constructed by combining observations from different platforms (satellites, ships, buoys) on a regular global grid. A spatially complete SST map is produced by interpolating to fill in gaps

See: [http://www.ncdc.noaa.gov/oisst](http://www.ncdc.noaa.gov/oisst)

As many of you have heard about or probably noticed if you have been swimming in the ocean over the past year and a half, a long-lived patch of warm water, about 1 to 4 degrees Celsius above normal, has been sitting off our coast. This warm water mass has been nicknamed "The Blob" and is leading to some very unusual fish sightings and emaciated sea lion pups

Today we will examine 4 SST files from March 31, 2012:2015 to see how the average surface temperature has changed for the Southern CA Bight.

To load our data, first we need to locate it. We can change the current working directory to the location of the netCDF files using the function `setwd` (meaning "set the working directory") For example, if the files are located in a directory named workshop on our Desktop, we would change the working directory using the following command:

    setwd("~/Desktop/workshop/")

Once you have your working directory set and the your daily SST files are in that directory, you are ready to load these files into R Studio. 

For this part of the lesson we will load the 3/31/2012 SST file

    sst_example <- open.ncdf("20120331.nc")

Once we have this file loaded, we can move on to the next step

Examining the Data Frame 
----
Go ahead and examine the data frame by typing
   
     sst_example
    
The output states that the file has 4 dimensions (time, zlev, lat, and lon), which correspond to the the day value of the data, elevation/depth, and coordinates for the each pixel. Because these are daily SST data, time and zlev both have size = 1, while lat size = 720 and lon size = 1440 (1/4° data)

The file also contains 4 variables: SST, SST Anomaly, SST Standard Deviation, and Sea Ice Concentration. Missing values = -999. NOAA 1/4° daily Optimum Interpolation Sea Surface Temperature files are already converted to degrees Celcius, so you don't have to worry about converting DN's, NOAA has already done this for you

We can now extract global SST values from this file and retrieve a few summary stats

    sst_ex <- (get.var.ncdf(sst_example , varid = 'sst'))
    mean(sst_ex,na.rm=TRUE)
    sd(sst_ex,na.rm=TRUE)
    
We see that the mean SST of the globe on 3/31/2012 was 13.71C with a standard deviation of 11.79C

Focusing on a Region (Southern CA Bight)
----
While having global SST is cool, most of us in the room are probably more interested in the SST of the Southern California Bight. So lets focus on the region between Pt. Conception and the US/Mexico border and see how things have changed over past few years

For this we will borrow a neat script written by Luke Miller, a post-doc with Mark Denny up at Hopkins Marine Station

    source('NOAA_OISST_function.R')

You can check out more here: [http://lukemiller.org/](http://lukemiller.org/)

This bit of code has everything you need to read these NOAA Optimum Interpolation Sea Surface Temperature files, mask out land masses, and cut out the areas of the world you just don't care about

First we will need to name the 4 SST files we downloaded at the beginning of the lesson as well as the landmask file

    sst_2012 <- "20120331.nc" #SST for 3/31/2012
    sst_2013 <- "20130331.nc" #SST for 3/31/2013
    sst_2014 <- "20140331.nc" #SST for 3/31/2014
    sst_2015 <- "20150331.nc" #SST for 3/31/2015
    lsmask <- "lsmask.oisst.v2.nc" #Land Mask

We can then use the script to read each file, mask out the land, and subset the data to our area of interest

The function is structured like this:

    extractOISST1day(fname,lsmask,lon1,lon2,lat1,lat2)

`fname` is simply the name of the daily sst file you specified above

`lsmask` is the landmask 

`lon1`, `lon2` are the two longitudes that bound the area you want to extract data for. They are given in degrees EAST of the prime meridian, so they range from 0.125 to 359.875. When you enter the arguments, `lon1` MUST be smaller (further west) than `lon2`   

`lat1`, `lat2` are the two latitudes that bound the area you want to extract data for. They are given in degrees NORTH, so that latitudes in the southern hemisphere all have negative values. The value for `lat1` must be less (further south) than the value of `lat2`

For example, for day 3/31/2012 in the Southern CA Bight we would type:

    SoCal_2012 <-extractOISST1day(sst_2012,lsmask,239,243.25,32.5,34.75)
    
We would then repeat this for the next three timesteps  

    SoCal_2013 <-extractOISST1day(sst_2013,lsmask,239,243.25,32.5,34.75)
    SoCal_2014 <-extractOISST1day(sst_2014,lsmask,239,243.25,32.5,34.75)
    SoCal_2015 <-extractOISST1day(sst_2015,lsmask,239,243.25,32.5,34.75)

We can plot our results using the plotOISST function  

    plotOISST(SoCal_2012) #Plot SST 2012
    plotOISST(SoCal_2013) #Plot SST 2013
    plotOISST(SoCal_2014) #Plot SST 2014
    plotOISST(SoCal_2015) #Plot SST 2015
    
**Note**: I have altered the code to scale the plots between 13.4 and 19.5 degrees Celsius. Normally it would scale each plot for the the range of that individual day

We can find the mean SST for each 31st day of March for each year by typing

    sst.list <- list(SoCal_2012, SoCal_2013, SoCal_2014, SoCal_2015)
    mean_temps <- sapply(sst.list, function(x){mean(x, na.rm=TRUE)})
    years <- as.integer(2012:2015)

    plot(years, mean_temps, type = "l")
    
This forms a list of the four variables we created and applies a function to find the mean of each

WOW! The regional SST of the Southern CA Bight was more than 3 degrees Celsius higher on 3/31 of 2015 compared to 3/31/ of 2012!

MOAR PLEASE - Yearly SST
---
We can also download yearly files which contain SST info for all 365(366) days.

First we define our yearly .nc file and open it

    year <- "sst_year_2014.nc"
    year_example <- open.ncdf(year)
    year_example

If we examine the file, we see that it contains information for 365 dates

We then run another function which operates in a similar fashion to the one we used for daily data, except for this one you must specify the start and end date you are interested in. Here are going to examine Jan. 1, 2014 to Dec 31, 2014.

    A2014 <- extractOISST(year,lsmask,239,243.25,32.5,34.75, "2014-01-01", "2014-12-31")

We can then define a vector and write short for loop to find the mean SST for the Southern CA Bight for each day of the year in 2014 and see how it changes

    SST_2014 <- numeric(365)
    for (i in 1:365 ) {
    SST_2014[i] <- mean(A2014[,,i],na.rm=TRUE)
    }
    Days <- as.integer(1:365)
    plot(Days, SST_2014, type = "l")

If you were interested in the pixel directly over your study plot you would find the pixel closest to your site. For example, if you study Mohawk Reef (34.394N, 240.27E), the closest pixel is found at row 3, column 7. **Rows before columns, ALWAYS**. Again write a short for loop specifying that cell and run it for all dates

    Mohawk_2014 <- numeric(365)
    for (i in 1:365 ) {
    Mohawk_2014[i] <- mean(A2014[3,7,i],na.rm=TRUE)
    }
    plot(Days, Mohawk_2014, type = "l")

THANK YOU!
----








