
def main():
    mainDict =["Cone","CSone","Done",
              "DSone","Eone","Fone",
              "FSone","Gone","GSone",
              "Aone","ASone","Bone",

              "Ctwo","CStwo","Dtwo",
              "DStwo","Etwo","Ftwo",
              "FStwo","Gtwo","GStwo",
              "Atwo","AStwo","Bthree",

              "Cthree","CSthree","Dthree",
              "DSthree","Ethree","Fthree",
              "FSthree","Gthree","GSthree",
              "Athree","ASthree","Bthree",

              "Cfour","CSfour","Dfour",
              "DSfour","Efour","Ffour",
              "FSfour","Gfour","GSfour",
              "Afour","ASfour","Bfour",

              "Cfive","CSfive","Dfive",
              "DSfive","Efive","Ffive",
              "FSfive","Gfive","GSfive",
              "Afive","ASfive","Bfive"]

    for i,note in enumerate(mainDict):
        print "if (haddr == " + note + ") writeaddr <= 6'd" + str(i) + ";"

    print "case(currentAddr) begin"
    for i,note in enumerate(mainDict):
        print "   6'd" + str(i)+ ": currentGuess <= " + note.replace("one","").replace("two","").replace("three",'').replace("four","").replace("five","") + " - 1;"
    print "   default:"


main()
