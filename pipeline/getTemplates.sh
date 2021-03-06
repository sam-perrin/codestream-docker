#!/bin/bash
set +x
source /build/capv.secret
set -x
# GOVC Connection variables
export GOVC_INSECURE=1
export GOVC_URL="${input.vCenter_URL}"
export GOVC_USERNAME="${input.vCenter_Username}"
export GOVC_DATASTORE="${input.vCenter_Datastore}"
export GOVC_NETWORK="${input.vCenter_Network}"
export GOVC_RESOURCE_POOL="${input.vCenter_ResourcePool}"
export GOVC_DATACENTER="${input.vCenter_Datacenter}"
export GOVC_FOLDER="${input.vCenter_Folder}"
export GOVC_CLUSTER="${input.vCenter_Cluster}"

export photonOsVersion=${input.Kubernetes_Version}
export haproxyVersion=${input.Haproxy_Version}
export IMPORT_METHOD=${input.Import_Method}

# # Test if the folder exists
# FOLDER=$(govc folder.info -json ${input.vCenter_Folder} | jq -r '.Folders[] | .Name')
# if [[ $FOLDER ]]
# then 
#   echo "Folder exists - skipping..."
# else
#   govc folder.create $GOVC_DATACENTER/vm/${input.vCenter_Folder}
# fi
# # Create Template folder
# TEMPLATEFOLDER=$(govc folder.info -json ${input.vCenter_Folder}/Templates | jq -r '.Folders[] | .Name')
# if [[ $TEMPLATEFOLDER ]]
# then 
#   echo "Folder exists - skipping..."
# else
#   govc folder.create $GOVC_DATACENTER/vm/${input.vCenter_Folder}/Templates
# fi
# # Create Management folder
# MANAGEMENTFOLDER=$(govc folder.info -json ${input.vCenter_Folder}/${input.Capv_Cluster_Name} | jq -r '.Folders[] | .Name')
# if [[ $MANAGEMENTFOLDER ]]
# then 
#   echo "Folder exists - skipping..."
# else
#   govc folder.create $GOVC_DATACENTER/vm/${input.vCenter_Folder}/${input.Capv_Cluster_Name}
# fi

export photonTemplate=$(govc find vm -name photon-3-kube-v$photonOsVersion)
export haproxyTemplate=$(govc find vm -name capv-haproxy-v$haproxyVersion)

# Test if the K8s Template exists
if [[ -z $photonTemplate ]]; then
  echo "No photon template found, downloading OVA"
  wget "http://storage.googleapis.com/capv-images/release/v$photonOsVersion/photon-3-kube-v$photonOsVersion.ova" -N
  if [[ "$IMPORT_METHOD" -eq "OVFTOOL" ]]; then
    ovftool --noSSLVerify --acceptAllEulas --skipManifestCheck --vmFolder="$GOVC_FOLDER" "--net:nic0=$GOVC_NETWORK" --datastore="$GOVC_DATASTORE" --diskMode=thin --name=photon-3-kube-v$photonOsVersion photon-3-kube-v$photonOsVersion.ova "vi://$GOVC_USERNAME:$GOVC_PASSWORD@$GOVC_URL/$GOVC_DATACENTER/host/$GOVC_CLUSTER/"
  else
    govc import.spec photon-3-kube-v$photonOsVersion.ova | python3 -m json.tool > photon-3-kube-v$photonOsVersion.json
    cat <<< $(jq --arg network "$GOVC_NETWORK" --arg name "photon-3-kube-v$photonOsVersion" '.Name = $name | .NetworkMapping[0].Network = $network | .DiskProvisioning = "thin"' photon-3-kube-v$photonOsVersion.json) > photon-3-kube-v$photonOsVersion.json
    govc import.ova -folder "/$GOVC_DATACENTER/vm/$GOVC_FOLDER" -options photon-3-kube-v$photonOsVersion.json photon-3-kube-v$photonOsVersion.ova
  fi
  # Take a snapshot, re-mark as template
  govc snapshot.create -vm photon-3-kube-v$photonOsVersion root
  govc vm.markastemplate photon-3-kube-v$photonOsVersion
else
  echo "Found existing photon template"
fi

# Test if the Proxy Template exists
if [[ -z $haproxyTemplate ]]; then
  echo "No haproxy template found, downloading OVA"
  wget "https://storage.googleapis.com/capv-images/extra/haproxy/release/v$haproxyVersion/capv-haproxy-v$haproxyVersion.ova" -N
  if [[ "$IMPORT_METHOD" -eq "OVFTOOL" ]]; then
    ovftool --noSSLVerify --acceptAllEulas --skipManifestCheck --vmFolder="$GOVC_FOLDER" "--net:nic0=$GOVC_NETWORK" --datastore="$GOVC_DATASTORE" --diskMode=thin --name=capv-haproxy-v$haproxyVersion capv-haproxy-v$haproxyVersion.ova "vi://$GOVC_USERNAME:$GOVC_PASSWORD@$GOVC_URL/$GOVC_DATACENTER/host/$GOVC_CLUSTER/"
  else
    govc import.spec capv-haproxy-v$haproxyVersion.ova | python3 -m json.tool > capv-haproxy-v$haproxyVersion.json
    cat <<< $(jq --arg network "$GOVC_NETWORK" --arg name "capv-haproxy-v$haproxyVersion" '.Name = $name | .NetworkMapping[0].Network = $network | .DiskProvisioning = "thin"' capv-haproxy-v$haproxyVersion.json) > capv-haproxy-v$haproxyVersion.json
    govc import.ova -folder /$GOVC_DATACENTER/vm/$GOVC_FOLDER -options capv-haproxy-v$haproxyVersion.json capv-haproxy-v$haproxyVersion.ova
  fi
  # Take a snapshot, re-mark as template
  govc snapshot.create -vm capv-haproxy-v$haproxyVersion root
  govc vm.markastemplate capv-haproxy-v$haproxyVersion
else
  echo "Found existing haproxy template"
fi