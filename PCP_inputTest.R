### LIBRARIES
library(ggplot2)
library(tidyverse)
library(geosphere)
library(gmt) # geodist is in geosphere under a different name--need to fix

### DATA READING
  
  dataPath <- readline(prompt="Enter file Path: ")
  dataPath <- file.path(dataPath)
  
  df <- read.csv(file = dataPath)

### DATA PROCESSING
  #### AT SOME POINT WE SHOULD VALIDATE.
  #### FOR THE TIME BEING, JUST NAIVE COL RE-NAME
  # col1 <- readline(prompt="is column 1 ID (Y/N): ")
  # col2 <- readline(prompt="is column 1 a binary (Y/N): ")

    colnames(df)[1] <- "dfName"
    colnames(df[1])
    
    colnames(df)[2] <- "ctrBin"
    colnames(df[2])
    
    colnames(df)[3] <- "lat"
    colnames(df[3])
    
    colnames(df)[4] <- "long"
    colnames(df[4])
    
    colnames(df)[5] <- "val1"
    colnames(df[5])
    
    colnames(df)
  
    # VALIDATION
      if (typeof(df$dfName) != "character")
        df$dfName <- as.character(df$dfName)
      if (typeof(df$ctrBin) != "logical")
        df$ctrBin <- as.logical(df$ctrBin)
      if (typeof(df$lat) != "double")
        df$ctrBin <- as.double(df$lat)
      if (typeof(df$long) != "double")
        df$ctrBin <- as.double(df$long)
      if (typeof(df$val1) != "integer" && typeof(df$val1) != "double" )
        df$val1 <- as.double(df$val1)
      
      summary(df)

      # coordinate validation
      ifelse(max(df$lat > 90.0) || 
               min(df$lat < -90.0) || 
               max(df$long > 180.0) || 
               min(df$long < -180.0), 
             print("Check your coordinate system..."), 
             print("Coordinates look ok!"))
      
      # test plot
      plot(df$long, df$lat)
      print("Please check to make sure your data looks ok")

      
## CENTERS
    # check centers
    if (sum(df$ctrBin) > 1)
      print("Too many centers. Check data")
    if (sum(df$ctrBin) == 0)
      print("No center. Check data. Maybe we'll have an interface to select one later")
    if (sum(df$ctrBin) == 1)
      print("There is one center! Hooray!")
    
    # give center row an id
    ctrX <- df$long[df$ctrBin == TRUE]
    ctrY <- df$lat[df$ctrBin == TRUE]
    ctrPt <- c(ctrX,ctrY)
    cat("Your center point has the following coordinates:", 
        ctrPt[1],"longitude and", ctrPt[2], "latitude. ")


#### DISTANCES
    # create a column in df, fill with km distances
    df$distance <- geodist(ctrY, ctrX, df$lat, df$long, units = "km")  
    # create a column in df, fill with km east-west distances
    df$distanceX <- geodist(ctrY, ctrX, ctrY, df$long, units = "km")  
    # create a column in df, fill with km north-south distances
    df$distanceY <- geodist(ctrY, ctrX, df$lat, ctrX, units = "km")  
    
    df$longDiff <- df$long - ctrX 
      # actual latitude difference, use for square plot later
    df$longDiffSign <- ifelse(df$long - ctrX < 0, -1, 1)
    
    df$latDiff <- df$lat - ctrY # actal longitude difference, use for square plot later
    df$latDiffSign <- ifelse(df$lat - ctrY < 0 , -1, 1)
    
    # find max distance
    # assign variable to max dist
    maxdistPT <- max(df$distance) # distance of real points
    maxdistX <- max(df$distanceX) # longest east-west distance
    maxdistY <- max(df$distanceY) # longest north-south distance
    maxdist <- max(df$distanceX, df$distanceY) # max between both
   
    # axial distances
    maxXcoord <- df$lat[df$distanceX == maxdistX]
    maxYcoord <- df$long[df$distanceY == maxdistY]