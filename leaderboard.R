## This script downloads the golf leaderboard from espn.com and exports it to csv

## load library dependencies
library(XML)
library(XLConnectJars)
library(XLConnect)

## set URL; this does not seem to change
url <- "http://espn.go.com/golf/leaderboard"

## read the raw html
doc <- htmlTreeParse(url, useInternalNodes = TRUE)

## get tourney name
tourney <- xpathSApply(doc, "//h1[@class='tourney-name']", xmlValue)

## parse the table values
pos <- xpathSApply(doc, "//td[@class='textcenter']", xmlValue)
topar <- xpathSApply(doc, "//td[@class='textcenter score']", xmlValue)
player <- xpathSApply(doc, "//td[@class='player']", xmlValue)

## create index for each field, where needed
posINDX <- seq(from = 1, to = length(pos), by = 9)
startINDX <- seq(from = 2, to = length(pos), by = 9)
todayINDX <- seq(from = 4, to = length(pos), by = 9)
r1INDX <- seq(from = 5, to = length(pos), by = 9)
r2INDX <- seq(from = 6, to = length(pos), by = 9)
r3INDX <- seq(from = 7, to = length(pos), by = 9)
r4INDX <- seq(from = 8, to = length(pos), by = 9)
totINDX <- seq(from = 9, to = length(pos), by = 9)
toparINDX <- seq(from = 1, to = length(topar), by = 2)
thruINDX <- seq(from = 2, to = length(topar), by = 2)

## split pos and topar using index
cleanPOS <- pos[posINDX]
START <- pos[startINDX]
cleanTOPAR <- topar[toparINDX]
TODAY <- pos[todayINDX]
THRU <- topar[thruINDX]
R1 <- pos[r1INDX]
R2 <- pos[r2INDX]
R3 <- pos[r3INDX]
R4 <- pos[r4INDX]
TOT <- pos[totINDX]

## build single data frame
ldrbrd <- data.frame(cbind(cleanPOS, 
                           START, 
                           player, 
                           cleanTOPAR, 
                           TODAY, 
                           THRU, 
                           R1, 
                           R2, 
                           R3, 
                           R4, 
                           TOT))

names(ldrbrd) <- c("POS", 
                   "START", 
                   "PLAYER", 
                   "TO_PAR", 
                   "TODAY", 
                   "THRU", 
                   "R1", 
                   "R2", 
                   "R3", 
                   "R4", 
                   "TOT")

## change class to int for rounds
ldrbrd$R1 <- as.integer(as.character(ldrbrd$R1))
ldrbrd$R2 <- as.integer(as.character(ldrbrd$R2))
ldrbrd$R3 <- as.integer(as.character(ldrbrd$R3))
ldrbrd$R4 <- as.integer(as.character(ldrbrd$R4))
ldrbrd$TOT <- as.integer(as.character(ldrbrd$TOT))

## export to csv
if (grepl("Masters Tournament", tourney)) {
        writeWorksheetToFile(file = "~/Documents/DataScience/leaderboard/2016_Majors_Pool.xlsx", data = ldrbrd, 
                             sheet = "masters", clearSheets = TRUE)
} else if (grepl("U.S. Open", tourney)) {
        writeWorksheetToFile(file = "~/Documents/DataScience/leaderboard/2016_Majors_Pool.xlsx", data = ldrbrd, 
                             sheet = "USopen", clearSheets = TRUE)
} else if (grepl("The Open", tourney)) {
        writeWorksheetToFile(file = "~/Documents/DataScience/leaderboard/2016_Majors_Pool.xlsx", data = ldrbrd, 
                             sheet = "THEopen", clearSheets = TRUE)
} else if (grepl("PGA Championship", tourney)) {
        writeWorksheetToFile(file = "~/Documents/DataScience/leaderboard/2016_Majors_Pool.xlsx", data = ldrbrd, 
                             sheet = "PGAchamp", clearSheets = TRUE)
} else if (grepl("THE PLAYERS Championship", tourney)) {
        writeWorksheetToFile(file = "~/Documents/DataScience/leaderboard/2016_Majors_Pool.xlsx", data = ldrbrd, 
                             sheet = "players", clearSheets = TRUE)
} else
        writeWorksheetToFile(file = "~/Documents/DataScience/leaderboard/2016_Majors_Pool.xlsx", data = ldrbrd, 
                             sheet = "regular", clearSheets = TRUE)

## clear memory
rm(list=ls())
