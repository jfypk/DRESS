import tuio
import requests
import os
import time
import sys

from dress.audio import play_audio


# AUDIO FILE -- Numbers and Paths 
shirt_files = 'Shirt/shirt'
shirt_backwards = '3'
completed_files = 'Completed/end'
congrats = '3'
help_inbound = '4'

# FLAGS FOR SHIRT, PANTS, BOXERS, DRAWERS
shirtf = 0 
shirtbackf = 0
pantsf = 0
pantsbackf = 0
boxerf = 0
boxerbackf = 0
justopened_1 = 0
justopened_2 = 0
justopened_3 = 0

# TIMER-COUNTERS
shirttimer = 1
pantstimer = 1
boxertimer = 1
delaytimer = .1
maxtimer = 40
keepgoing = 1
trackingoff = 1

# FIDUCIALS 
shirt_front = 7
shirt_back = 4


# PORT FOR REACTIVISION ON PI FEEDING TO PHYTHON
tracking = tuio.Tracking("100.10.100.10", 3333)     
indigo.server.log('starting detection')
trackingoff = 0

# initialize
# readybutton in indigo (1) executes "activate"; (2) plays M1 files; turns drw1 light green
#
# SHIRT
#           drw1-switch ON sets var, read by python, starts fiducials for shirt
#           if drw1-switch-ON-Var -- then look for shirt
#           until shirt is detected, turned around and .... (play sound files in python)
#           tell indigo to turn light off when drawer is closed
#
# PANTS     repeat Shirt // 
#
# BOXERS    repeat Shirt // 
#
#

try:
    while keepgoing == 1:
        shirttimer += 1
        
        myVar = indigo.variables["drawer_1_open"]                   # check if Drawer 1 is open
        if myVar.value == "true":
 #          indigo.server.log("drawer_1_open variable is 'true'")   
            time.sleep(delaytimer)                                  # delay every cycle

            if justopened_1 == 0:
 #              indigo.server.log('justopened is 0 - hopefully only once')
                justopened_1 = 1                                    # play audio -- take out shirt -- open the shirt
 #              indigo.server.log('justopened set to 1')
                for i in range(1,3):
                    play_audio(shirt_files + str(i))
                    time.sleep(2)

            if trackingoff == 1: 
                trackingoff = 0
                tracking = tuio.Tracking("100.10.100.10", 3333)     # TURN THIS BACK ON
                indigo.server.log('starting detection')


            tracking.update()                                       # load fiducial variables from reactivision
  #         for fid in tracking.objects():
  #              print fid                                           # * not needed but here just in case
            fid_ids = [fid.id for fid in tracking.objects()]
  #         indigo.server.log('checking for fiducials - fid_ids')                                       

  # CHECK IF FORWARDS/ BACKWARDS  - assumes drawer is left open during shirt donning
            if shirt_front in fid_ids:  
  #             indigo.server.log('shirt_front detected') 
                shirtf += 1											# *** Add logic here to incement iterations of detection until confirmed
                shirtf = 3                                          # *** FORCE detct on first detect // update logic for multiple checks
                if shirtf > 2:
                    indigo.server.log('Shirt_front confirmed')
                    tracking.stop()
                    indigo.server.log('tracking stopped - shirtfront')                              
                    play_audio(completed_files + congrats)
                    time.sleep(4)                                   # pause for audio
                    play_audio('Shirt/closeDrawer')                 # audio -- close drawer
                    #Set drawer1 light to off
                    #Set drawer2 light to on                        
                    keepgoing = 0                                   # *** UPDATE this once other cloths are in place
                else: 
                    keepgoing = 1          
        
            if shirt_back in fid_ids:    
                if shirtbackf < 3:                                  # number of times asked to turn around
                    shirtbackf += 1
                    indigo.server.log('shirt_back detected')
                    play_audio(shirt_files + shirt_backwards)   
                    # *** IMPORTANT RESET ALERT *** 
                    tracking.stop()   
                    indigo.server.log('tracking stopped - shirtback')                              
                    trackingoff = 1
                    time.sleep(5)                                   # delay to let pwd turn shirt around           
                else:
                    shirttimer = maxtimer                           # if number of tries is too much go to "call for help"

            if shirttimer == maxtimer:                              # shirt front not detected "call for help"
                 indigo.server.log('shirt -- needs help')
                 play_audio(completed_files + help_inbound)
                 keepgoing = 0
                 tracking.stop()
                 indigo.server.log('tracking stopped - shirttimer')

    indigo.server.log('ROUND 2 -- USE DRAWER 2 Trigger')
    justopened_1 = 0
    keepgoing = 1

    while keepgoing == 1:
        shirttimer += 1
        
        myVar = indigo.variables["drawer_2_open"]                   # check if Drawer 1 is open
        if myVar.value == "true":
 #          indigo.server.log("drawer_1_open variable is 'true'")   
            time.sleep(delaytimer)                                  # delay every cycle

            if justopened_1 == 0:
 #              indigo.server.log('justopened is 0 - hopefully only once')
                justopened_1 = 1                                    # play audio -- take out shirt -- open the shirt
 #              indigo.server.log('justopened set to 1')
                for i in range(1,3):
                    play_audio(shirt_files + str(i))
                    time.sleep(2)

            if trackingoff == 1: 
                trackingoff = 0
                tracking = tuio.Tracking("100.10.100.10", 3333)     # TURN THIS BACK ON
                indigo.server.log('starting detection')


            tracking.update()                                       # load fiducial variables from reactivision
  #         for fid in tracking.objects():
  #              print fid                                           # * not needed but here just in case
            fid_ids = [fid.id for fid in tracking.objects()]
  #         indigo.server.log('checking for fiducials - fid_ids')                                       

  # CHECK IF FORWARDS/ BACKWARDS  - assumes drawer is left open during shirt donning
            if shirt_front in fid_ids:  
  #             indigo.server.log('shirt_front detected') 
                shirtf += 1											# *** Add logic here to incement iterations of detection until confirmed
                shirtf = 3                                          # *** FORCE detct on first detect // update logic for multiple checks
                if shirtf > 2:
                    indigo.server.log('Shirt_front confirmed')
                    tracking.stop()
                    indigo.server.log('tracking stopped - shirtfront')                              
                    play_audio(completed_files + congrats)
                    time.sleep(4)                                   # pause for audio
                    play_audio('Shirt/closeDrawer')                 # audio -- close drawer
                    #Set drawer1 light to off
                    #Set drawer2 light to on                        
                    keepgoing = 0                                   # *** UPDATE this once other cloths are in place
                else: 
                    keepgoing = 1          
        
            if shirt_back in fid_ids:    
                if shirtbackf < 3:                                  # number of times asked to turn around
                    shirtbackf += 1
                    indigo.server.log('shirt_back detected')
                    play_audio(shirt_files + shirt_backwards)   
                    # *** IMPORTANT RESET ALERT *** 
                    tracking.stop()   
                    indigo.server.log('tracking stopped - shirtback')                              
                    trackingoff = 1
                    time.sleep(5)                                   # delay to let pwd turn shirt around           
                else:
                    shirttimer = maxtimer                           # if number of tries is too much go to "call for help"

            if shirttimer == maxtimer:                              # shirt front not detected "call for help"
                 indigo.server.log('shirt -- needs help')
                 play_audio(completed_files + help_inbound)
                 keepgoing = 0
                 tracking.stop()
                 indigo.server.log('tracking stopped - shirttimer')


    indigo.server.log('ROUND 3 -- USE DRAWER 3 Trigger -- TBD')







except Exception, e: # KeyboardInterrupt:
    tracking.stop()
    indigo.server.log('tracking stopped - end of while loop')                              
    print 1
