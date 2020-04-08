#install.packages("WaveletComp", repos='http://cran.us.r-project.org')
library("WaveletComp")

rootDir = "/home/sethbw/Documents/GlobFlow/spectralAnalysis"
outDir = "/home/sethbw/Documents/GlobFlow/spectralAnalysis"

dataFile = "earlyData.csv"

dataFolder = paste(rootDir, dataFile, sep="/")
print(dataFolder)
data = read.csv(dataFolder, sep=",")
#print(data)
originalData = data.frame(data)

sites = names(data)
sites



getStoppingIndex = function(siteData) {
    stoppingIndex = 0
    for (indx in 1:(length(siteData))) {

        if (is.na(siteData[indx])) { 
            stoppingIndex = indx - 1
            break           
        }
    }
    if (stoppingIndex == 0) {
        stoppingIndex = length(siteData)
    }
    return(stoppingIndex)

}


getTrimmedData = function(originalData, site) {
    siteData = originalData[,site]
    stoppingIndex = getStoppingIndex(siteData)
    return(originalData[1:stoppingIndex,])
}


site = sites[[1]] # test site
trimmedData = getTrimmedData(originalData, site)

wvlt = analyze.wavelet(trimmedData, site,loess.span = 0,
                      dt = 1, dj = 1/100,lowerPeriod = 2,
                      upperPeriod = 4096,make.pval = T, n.sim = 1)

wt.image(wvlt, color.key = "quantile", 
         n.levels = 100,legend.params = list(lab = "wavelet power levels", mar = 4.7))

wt.avg(wvlt)

scale = wvlt$Scale
power = data.frame(scale)
power
pval = data.frame(scale)
pval

for (indx in 1:length(sites)) {
    currentSite = sites[indx]
    trimmedData = getTrimmedData(originalData, currentSite)

    wvlt = analyze.wavelet(trimmedData, currentSite,loess.span = 0,
                      dt = 1, dj = 1/100,lowerPeriod = 2,
                      upperPeriod = 4096,make.pval = T, n.sim = 15)

    power[[currentSite]] = wvlt$Power.avg
    pval[[currentSite]] = wvlt$Power.avg.pval
    print(indx)         
}

power
write.csv(power,paste(outDir, "earlyPeriodPowers.csv", sep="/"), row.names=FALSE)
write.csv(pval,paste(outDir, "earlyPeriodPowerPvals.csv", sep="/"), row.names=FALSE)

power


tPower = t(power)
tPval = t(pval)
write.csv(tPower, paste(outDir, "earlyPowersTransose.csv", sep="/"), row.names=TRUE)
write.csv(tPval,paste(outDir, "earlyPeriodPowerPvalsTranspose.csv", sep="/"), row.names=FALSE)

