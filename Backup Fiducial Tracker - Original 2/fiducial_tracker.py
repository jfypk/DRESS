import tuio
import requests
import os
import time

#usr = 'nyu'
#pwd = 'dress2015'
#login = requests.auth.HTTPDigestAuth(usr, pwd)
#url = 'dress.goprism.com'

# fiducial ID 7 -- move these into a config
shirt_front = 7 
shirt_back = 4
pants_front = 28 
pants_back = 31
boxers_front = 0 
boxers_back = 2

is_shirt_backwards = 'shirt_back_detected'
is_shirt_correct = 'shirt_front_detected'
is_pants_backwards = 'pants_back_detected'
is_pants_correct = 'pants_front_detected'
is_boxers_backwards = 'boxers_back_detected'
is_boxers_correct = 'boxers_front_detected'

tracking = tuio.Tracking("100.10.100.10", 3333) 
#tracking = tuio.Tracking("dress.local", 3333) 
req = ''
num_iters = 100
i = 1
indigo.server.log('starting detection')
try:
    while i < num_iters:
        tracking.update()
        fid_ids = [fid.id for fid in tracking.objects()]

        print (fid_ids)

        indigo.server.log('Fiducial', fid_ids[0])
        
        if shirt_front in fid_ids:
            indigo.variable.updateValue('shirt_front_detected', 'true')
            indigo.server.log('shirt_front_detected POSITIVE')
 #           indigo.server.log('shirt front detected')
            time.sleep(0.5) 

        else:
            indigo.variable.updateValue('shirt_front_detected', 'false')
 #           indigo.server.log('shirt front not detected')

        if shirt_back in fid_ids:
            indigo.variable.updateValue('shirt_back_detected', 'true')
            time.sleep(0.5) 

        else:
            indigo.variable.updateValue('shirt_back_detected', 'false')

        if pants_front in fid_ids:
            indigo.variable.updateValue('pants_front_detected', 'true')
  #          indigo.server.log('pants front detected')
            time.sleep(0.5) 

        else:
            indigo.variable.updateValue('pants_front_detected', 'false')
  #          indigo.server.log('pants front not detected')

        if pants_back in fid_ids:
            indigo.variable.updateValue('pants_back_detected', 'true')
  #          indigo.server.log('pants back detected')
            time.sleep(0.5) 

        else:
            indigo.variable.updateValue('pants_back_detected', 'false')
            
        if boxers_front in fid_ids:
            indigo.variable.updateValue('boxers_front_detected', 'true')
   #         indigo.server.log('boxers front detected')
            time.sleep(0.5) 

        else:
            indigo.variable.updateValue('boxers_front_detected', 'false')

        if boxers_back in fid_ids:
            indigo.variable.updateValue('boxers_back_detected', 'true')
    #        indigo.server.log('boxers back detected') 
            time.sleep(0.5) 

        else:
            indigo.variable.updateValue('boxers_back_detected', 'false')    

        i += 1
        time.sleep(0.1)
    tracking.stop()
    indigo.server.log('stopping detection')
except Exception, e: # KeyboardInterrupt:
    tracking.stop()
    indigo.server.log('error in detection ' + str(e))
