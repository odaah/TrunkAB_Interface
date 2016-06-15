#!/bin/bash                                                     
 # Collect the current user's ssh and enable passwords          
 echo -n "Enter the SSH password for $(whoami) "                
 read -s -e password                                            
 echo -ne '\n'                                                  
 echo -n "Enter the Enable password for $(whoami) "             
 read -s -e enable                                              
 echo -ne '\n'                                                  
# Feed the expect script a device list & the collected passwords

#execute the command on distro
for device in `cat ~/TrunkAB/distros.txt`; do                 
 ./cmd_po_exp.exp $device $password $enable ;                  
  
sed -n '/#show cdp/,/#exit/p' results_po.log | awk '{print $2, $3}' | egrep -o "^Gi.*" | sort -u > ea_po_distro.out ;

./cmd_po-vlan_exp.exp $device $password $enable ;                  

sed -n '/Name\|VLANs Enabled\|Disabled/p' results_vlantrunk.log | egrep -v "#show|Capture" > $device-vlantrunk.out ;
 
 rm -f results_po.log ;
 rm -f ea_po_distro.out ;
 rm -f results_vlantrunk.log ;

 done
