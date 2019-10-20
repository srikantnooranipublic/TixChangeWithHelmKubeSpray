#!/bin/bash


MAIN_FOLDER=`dirname $BASH_SOURCE`


. $MAIN_FOLDER/scripts/include.sh

#$MAIN_FOLDER/scripts/preReqInstaller.sh


clear

rm -rf $INSTALLATION_FOLDER/logs/ 2> /dev/null
mkdir -p $INSTALLATION_FOLDER/logs 2> /dev/null

logMsg "Deploy and setup TixChange on K8s."

logMsg " *********"
logMsg "1. Make sure HOST_IP field is updated in config.ini"
logMsg "2. Make sure ssh key is setup among all your nodes to connect from this box without passwd"
logMsg "3. Make sure you have 40G available in the install folder ($INSTALLATION_FOLDER) volume"
logMsg "4. Make sure you run this as root"
logMsg " *********"

logMsg "Press y to proceed"

read INPUT

OPTION=""

if [ X$INPUT != "Xy" ]; then
  logMsg "Did not get \"y\". exiting ..." 
  exit
else 
  logMsg "Choose your option and press enter"
  Usage

  read OPTION
fi



case $OPTION in 
   a) 

     stopDeleteAll

     cd $INSTALL_SCRIPT_FOLDER
     $MAIN_FOLDER/scripts/preReqInstaller.sh
	
     cd $INSTALL_SCRIPT_FOLDER
     $MAIN_FOLDER/scripts/K8sInstaller.sh	


     sleep 10
     #echo "5pwd is $PWD. $INSTALL_SCRIPT_FOLDER"
     cd $INSTALL_SCRIPT_FOLDER
     installTixChangeHelm

     sleep 10
     #logMsg "reinstall BPA "
     #stopDeleteBPA
     #sleep 3
     #installBPA

     sleep 10
     installPromExporter

     sleep 10
     #echo "4pwd is $PWD. $INSTALL_SCRIPT_FOLDER"
     cd $INSTALL_SCRIPT_FOLDER
     installUMA

     logMsg "Waiting few seconds for app to startup"
     sleep 15
     #echo "6pwd is $PWD. $INSTALL_SCRIPT_FOLDER"
     cd $INSTALL_SCRIPT_FOLDER

     installAndConfigureSelenium
     sleep 10


     configureEM em1
     configureEM em2

     runFinalSanityCheck


     logMsg ""
     logMsg ""
     logMsg ""
     logMsg "************************"
     logMsg ""
     logMsg ""
     logMsg ""
     logMsg "1. Update your laptop (where you are running the browser) /etc/hosts with following IP"
     logMsg "    $TIX_IP $UC1_URL"
     logMsg "    $TIX_IP $UC2_URL"
     logMsg "  *** NOTE: if you see urls and no IPs above then update /etc/hosts manually ***"
     logMsg "2. This is a Blue/Green deployment - with UC1 running on $UC1_URL/jtixchange_web/shop/index.shtml and UC2 $UC2_URL/jtixchange_web/shop/index.shtml"
     logMsg "3. Selenium is generating load for both. Access TixChange from browser at $UC1_URL/jtixchange_web/shop/index.shtml"
     logMsg "4. Log File is available under $INSTALLATION_FOLDER/logs"
     logMsg ""
     logMsg ""
     logMsg "************************"

     
     ;;

   r)

     stopDeleteAppComponents

     logMsg " Now Re-installing just the Application components (Tixchange, UMA, Selenium, EM Side - MM, Univ, Exp View) "

     sleep 10
     #echo "pwd is $PWD. $INSTALL_SCRIPT_FOLDER"
     cd $INSTALL_SCRIPT_FOLDER
     installTixChangeHelm

     #sleep 10
     #installBPA

     sleep 10
     installPromExporter

     sleep 10
     #echo "4pwd is $PWD. $INSTALL_SCRIPT_FOLDER"
     cd $INSTALL_SCRIPT_FOLDER
     installUMA

     logMsg "Waiting few seconds for app to startup"
     sleep 15
     #echo "6pwd is $PWD. $INSTALL_SCRIPT_FOLDER"
     cd $INSTALL_SCRIPT_FOLDER
     installAndConfigureSelenium
     
     configureEM em1
     configureEM em2

     runFinalSanityCheck
     ;;
   u) 

     stopDeleteUMA

     logMsg " Installing just the UMA components"
     installUMA
     ;;
   t) 

     stopDeleteTixChange

     logMsg " Installing just the TixChange components + Selenium + EM side MM,ExpView, Univ"
     installTixChangeHelm
    
     #sleep 10 
     #logMsg "reinstall BPA "
     #stopDeleteBPA 
     #sleep 3
     #installBPA

     logMsg " re-installaing Selenium"
     stopDeleteSelenium
     sleep 5
     installAndConfigureSelenium
     sleep 5
     
     configureEM em1
     configureEM em2

     runFinalSanityCheck
     ;;
   s) 
     stopDeleteSelenium

     logMsg " Installing just the selenium components"
     installAndConfigureSelenium
     
     runFinalSanityCheck
     ;;
   c) 
     logMsg "Clean All. Are you sure ??" 
     logMsg "Press Enter to continue or Ctrl-C"
     
     read INPUT
    
     stopDeleteAll
     ;;
   e)
     logMsg "Setup EM (Universes, Exp Views, mgmt mod). sleep 10sec before starting. Hope agents are already reporting"
     
     
     configureEM em1
     configureEM em2
     
     ;;
   b)
     logMsg "BPA is disabled for now"
     #logMsg "installing and configuring HTTPD, BT Listener for BPA"
    
    
     #stopDeleteBPA 
     #sleep 3
     #installBPA
    
     ;;
   *) 
     logMsg "Not a valid option"
     Usage
     ;;     
esac

