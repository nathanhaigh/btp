#!/usr/bin/python

import boto
from boto.ec2.connection import EC2Connection
from boto.ec2.regioninfo import *


from pprint import pprint
import time


import xml.parsers.expat
import os.path

#################################################################################
#################################################################################
def printAll(connection):
    print "\nbefore reservations\n"
    reservations = connection.get_all_instances()
    for i,res in enumerate(reservations):
        #print "\nVALUE OF each element of connection.getallinstances:"
        #pprint (res.__dict__)

        print i,"\t",res.id,"\t",res.owner_id,"\t",
        instanceList = res.instances;
        for j,inst in enumerate(instanceList):

                if (i==0 and j==0):
                        firstInstanceID=inst.id
                        firstInstanc=inst
                #print "\nPrint value of inst. res.instances();"
                #pprint(inst.__dict__)
                #print "Valuue of inst.Instances"
                #spprint(inst.instances.__dict__)
                print inst.id,"\t",inst.image_id,"\t",inst.ip_address,"\t",
                print inst.private_ip_address,"\t",inst.private_dns_name,"\t",
                print inst.public_dns_name,"\t",inst.state,"\t",inst.key_name
#################################################################################
def printAllImages(connection):
        listOfImages= connection.get_all_images()
        print "Numbner of images is ",len(listOfImages)
        for i in range(len(listOfImages)):
                im = listOfImages[i]
                print i,"\t", im.name,"\t",im.architecture, "\t",im.state
                #pprint(im.__dict__)

#################################################################################
#################################################################################
def main():
        try:
		EC2_ACCESS_KEY=os.environ['EC2_ACCESS_KEY']
		EC2_SECRET_KEY=os.environ['EC2_SECRET_KEY']
		print "Keys are"+EC2_ACCESS_KEY+ " "+EC2_SECRET_KEY
        	region = RegionInfo(name="NeCTAR", endpoint="nova.rc.nectar.org.au")        
        	connection = boto.connect_ec2(
                    EC2_ACCESS_KEY,
                    EC2_SECRET_KEY,
                    is_secure=False,
                    region=region,
                    port=8773,
                    path="/services/Cloud")
       
        	#printAllImages(connection);
        	printAll(connection);
		#
		# start a connection
		#
	
		#read in script file as a string and use it as meta data in startup
		userdata = open('btp.sh', 'r').read()		
		print "userdata is\n"+userdata
    		myReservation = connection.run_instances(
				'ami-00000004',key_name='btphash',security_groups=['ICMP','ssh'],
				user_data=userdata
				)
		print "Rervation created "+myReservation.id;
		myIPList=[]
		for tempI in myReservation.instances:
			pprint (tempI)
			ip=tempI.ip_address
			print "IP ADDRES IS "+ip
			print "State is "+tempI.state
			runningState=tempI.state
			#loop until finished
			while (runningState != 'running'):	
				reservations = connection.get_all_instances()
    				for i,res in enumerate(reservations):
        				instanceList = res.instances;
        				#print i,"\tresid= ",res.id,"\tresonwer= ",res.owner_id,"\t",
					if (res.id == myReservation.id):
        					for j,inst in enumerate(instanceList):
							runningState=inst.state;		
							myIP=inst.ip_address
							print "new state is "+runningState
							if (runningState == 'running' ):
								myIPList.append(inst.ip_address)
                					print inst.id,"\t",inst.image_id,"\t",inst.ip_address,"\t",
                					print inst.private_ip_address,"\t",inst.private_dns_name,"\t",
                					print inst.public_dns_name,"\t",inst.state,"\t",inst.key_name	
						break
				print "Before sleep"
				time.sleep(1)
		print "IP Numbers are:"
		for myIP in myIPList:
			print myIP
			 

				

               	return connection
        except boto.exception as error:
                print "Connection Bucket error ",error
                return None
###############################################################################

if __name__=="__main__":
   main()
