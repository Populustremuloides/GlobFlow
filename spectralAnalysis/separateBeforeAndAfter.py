

# open the file
inFile = "concatenatedData.csv"
columnFile = "columnConcatenatedFlow.csv"
firstFile = "earlyData.csv"
secondFile = "lateData.csv"

with open(columnFile, "r+") as cFile:
    numLines = 0
    for line in cFile:
        numLines = numLines + 1

numLines = numLines - 1 # don't count the header line
timeToSwitch = numLines // 2

with open(firstFile, "w+") as fFile:
    with open(columnFile, "r+") as cFile:
        i = 0
        for line in cFile:
            if i > timeToSwitch:
                break
            else:
                fFile.write(line)
            i = i + 1

with open(secondFile, "w+") as sFile:
    with open(columnFile, "r+") as cFile:
        i = 0
        for line in cFile:
            if i == 0:
                sFile.write(line)
            if i <= timeToSwitch:
                pass
            else:
                sFile.write(line)
            i = i + 1

