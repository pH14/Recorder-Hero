import math

def main():
   mainDict ={"Cone":130.813,"CSone":138.591,"Done":146.832,
              "DSone":155.563,"Eone":164.814,"Fone":174.614,
              "FSone":184.997,"Gone":195.998,"GSone":207.652,
              "Aone":220,"ASone":233.082,"Bone":246.942,

              "Ctwo":261.626,"CStwo":277.183,"Dtwo":293.665,
              "DStwo":311.127,"Etwo":329.628,"Ftwo":349.228,
              "FStwo":369.994,"Gtwo":391.995,"GStwo":415.305,
              "Atwo":440,"AStwo":466.164,"Btwo":493.883,

              "Cthree":523.251,"CSthree":554.365,"Dthree":587.330,
              "DSthree":622.254,"Ethree":659.255,"Fthree":698.456,
              "FSthree":739.989,"Gthree":783.991,"GSthree":830.609,
              "Athree":880,"ASthree":932.328,"Bthree":987.767,

              "Cfour":1046.50,"CSfour":1108.73,"Dfour":1174.66,
              "DSfour":1244.51,"Efour":1318.51,"Ffour":1396.91,
              "FSfour":1479.98,"Gfour":1567.98,"GSfour":1661.22,
              "Afour":1760,"ASfour":1864.66,"Bfour":1975.53,

              "Cfive":2093,"CSfive":2217.46,"Dfive":2349.32,
              "DSfive":2489.02,"Efive":2637.02,"Ffive":2793.83,
              "FSfive":2959.96,"Gfive":3135.96,"GSfive":3322.44,
              "Afive":3520,"ASfive":3729.31,"Bfive":3951.07}

   points = 4096.0 #16384

   for note in mainDict.keys():
      mainDict[note] = int(math.floor(mainDict[note]/(48000.0/points)))

   
   for note in mainDict.keys():
      print "parameter[11:0] " + note + " = 12'b" + '{0:012b}'.format(mainDict[note]) + ";"

   print ""
   print ""

   for note in mainDict.keys():
      print "if (xk_index == 12'b" + '{0:012b}'.format(mainDict[note]) + ") begin"
      print "   state <= 2;"
      print "   haddr <= xk_index;"
      print "   rere <= xk_re_scaled * xk_re_scaled;"
      print "   imim <= xk_im_scaled * xk_im_scaled;"
      print "end"
                                                      
   for note in mainDict.keys():
      for note2 in mainDict.keys():
         if note != note2:
            if mainDict[note] == mainDict[note2]:
               print "FAIL!!!"
main()
