#!/usr/bin/env python
import serial
import time

ser = serial.Serial('/dev/tty.usbserial-DPE0BNVH')
i = 0

print 'Sending image...'

if False:
    t = 0
    switchColor = True 
    for y2 in range(0, 12):
        switchColor = not switchColor
        for y in range(0, 64):

            for checker in range(0, 16):

                for x in range(0, 64):
                    if switchColor:
                        if ((checker%2) == 0):
                            bitstring = '11111100'
                        else:
                            bitstring = '00111100'
                    else:
                        if ((checker%2) == 0):
                            bitstring = '00111100'
                        else:
                            bitstring = '11111100'
                        

                    #print 'Writing %s, %s' % (bitstring, x)

                    byteval = chr(int(bitstring, 2))
                    ser.write(byteval)
                    time.sleep(0.00001)
                    t += 1

    print "Sent",t,"pixels"
    ser.close()

if True:
    f = open('matlab/bono_pixels.coe')
    f.readline()
    f.readline()
    while True:
        ## example of sending binary data (i.e. as read from a coe file)                                                                                                      
        if i == 784643:
            i = 0
        else:
            i += 1

        
        img_byte = f.readline()[:-3]
        #print 'Sending line #%s %s' % (i, img_byte)
        bitstring = img_byte
        #bitstring = '00000000' 
        #bitstring = '11110000'
        byteval = chr(int(bitstring,2))
        #raw_input('Press enter to send "%s" which has byteval %s' % (bitstring, repr(byteval)))  ## need to use repr for printing bytes                                       
        ser.write(byteval)

        #time.sleep(0.5)
        time.sleep(0.00001)

    ser.close()

if False:
    for i in range(0, 512):
        bitstring = bin(i%256)
        byteval = chr(int(bitstring,2))
        ser.write(byteval)
        time.sleep(0.00001)

    ser.close()

