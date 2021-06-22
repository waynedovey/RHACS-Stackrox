#!/bin/bash

helm version
helm repo add rhacs https://mirror.openshift.com/pub/rhacs/charts/
helm search repo -l rhacs/

helm repo update

helm install -n stackrox --create-namespace stackrox-central-services rhacs/central-services --set imagePullSecrets.allowNone=true --set central.exposure.route.enabled=true

export ROX_API_TOKEN=<CHANGEME>
export ROX_CENTRAL_ADDRESS=<CHANGEME>

roxctl -e "$ROX_CENTRAL_ADDRESS:443" central init-bundles generate cluster-init-bundle-name --output cluster-init-bundle.yaml

helm install -n stackrox --create-namespace stackrox-secured-cluster-services rhacs/secured-cluster-services -f cluster-init-bundle.yaml \
--set centralEndpoint=$ROX_CENTRAL_ADDRESS:443 \
--set clusterName=voilet-hub-cluster \
--set imagePullSecrets.allowNone=true

helm install -n stackrox --create-namespace stackrox-secured-cluster-services rhacs/secured-cluster-services -f cluster-init-bundle.yaml \
--set centralEndpoint=$ROX_CENTRAL_ADDRESS:443 \
--set clusterName=sydney-cluster \
--set imagePullSecrets.allowNone=true

helm install -n stackrox --create-namespace stackrox-secured-cluster-services rhacs/secured-cluster-services -f cluster-init-bundle.yaml \
--set centralEndpoint=$ROX_CENTRAL_ADDRESS:443 \
--set clusterName=melbourne-cluster \
--set imagePullSecrets.allowNone=true
