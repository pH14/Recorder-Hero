
def main():
    mainDict = [["CList","C"],
	 ["CSList","Cs"],
	 ["DList","D"],
	 ["DSList","Ds"],
	 ["EList","E"],
	 ["FList","F"],
	 ["FSList","Fs"],
	 ["GList","G"],
	 ["GSList","Gs"],
	 ["AList","A"],
	 ["ASList","As"],
	 ["BList","B"]]

    
    for listName in mainDict:
        print "for (i = 0; i < 5; i = i + 1) begin"
        print "   if (" + listName[0] + "[i] == currentAddr) currentGuess <= " + listName[1] + ";"
        print "end"


main()
