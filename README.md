
 Purpose: Single script demo env installer - installs, configures and runs complete Tixchange with Universal Monitoring agent in K8s + Selenium with no manual intervention 

Author Srikant.Noorani@Broadcom.com

Jun 2019

MIT License - provided on an as is basis


TixchangeWithHelmKubeSpray

************
<br><b>Here is what you get with the single installer</b>

<br>- Installs and configures K8s on all the nodes using Kubespray
<br>-Installs and configures Helm Chart using Kubespray
<br>-Installs, configures and runs TixChange and Universal Monitoring Agent . Both Tixchange and UMA is “Helmi’fied”. No need to download agents or configure BA snippet into the agent.
<br>-Installs, configures and runs Selenium load scripts. Since its Selenium no need to run manual transactions from the browser
<br>-AXA to APM Slow login use case run every hour on top hour automatically
<br>-Automatically creates Universes with right filters, Experience View and mgmt module with preconfigured alerts
<br>-Automatically correlates Inferred DB vertex with Kubernetes POD and Host
 *************

./mainInstaller.sh
<br>Choose your option and press enter

Options:
 
 <br> a : install all (K8s,Helm, UMA, TixChange, Selenium, EM side - Universes, Exp View, Mgmt Mod) 
 <br> r : re-install & run just app components (helm, uma, tixchange, selenium, EM side - Universes, Exp View, Mgmt Mod) 
 <br> u : install & run just uma  
 <br> t : install & run just tixChange  
 <br> s : install & run just selenium
 <br> e : EM side configuration: Setup Universes, import mgmt module etc
 <br> c : cleanup and unintsall everything


more info available at https://cawiki.ca.com/display/SASWAT/Tixchange+in+K8s+V2.0

