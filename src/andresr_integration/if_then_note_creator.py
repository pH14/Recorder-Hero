
def main():
    CList = [0,12,24,36,48]
    CSList = [1,13,25,37,49]
    DList = [2,14,26,38,50]
    DSList = [3,15,27,39,51]
    EList = [4,16,28,40,52]
    FList = [5,17,29,41,53]
    FSList = [6,18,30,42,54]
    GList = [7,19,31,43,55]
    GSList = [8,20,32,44,56]
    AList = [9,21,33,45,57]
    ASList = [10,22,34,46,58]
    BList = [11,23,35,47,59]

    clause = ""
    for i in CList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= C;"

    clause = ""
    
    for i in CSList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= Cs;"

    clause = ""

    for i in DList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= D;"

    clause = ""

    for i in DSList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= Ds;"

    clause = ""

    for i in EList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= E;"

    clause = ""

    for i in FList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= F;"\

    clause = ""

    for i in FSList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= Fs;"

    clause = ""

    for i in GList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= G;"

    clause = ""

    for i in GSList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= Gs;"

    clause = ""

    for i in AList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= A;"

    clause = ""

    for i in ASList: 
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= As;"

    clause = ""

    for i in BList:
        clause = clause + " | (currentAddr == 6'd" + str(i) + ")"
    
    print "else if (" + clause + ") currentGuess <= B;"

main()
