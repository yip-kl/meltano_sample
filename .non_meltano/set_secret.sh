# Get credentials for the GKE cluster so that you can access it with kubectl.
export GCP_PROJECT=adroit-hall-301111
export COMPOSER_GKE_NAME=us-central1-example-environ-e17e2153-gke
export COMPOSER_GKE_LOCATION=us-central1

gcloud container clusters get-credentials $COMPOSER_GKE_NAME \
  --project=$GCP_PROJECT \
  --location=$COMPOSER_GKE_LOCATION

# Define the name of the secret and the path to the service account key file.
export SA_SECRET_NAME=gcp-service-account
export SA_NAMESPACE=composer-user-workloads # Default namespace of Composer 2 workloads. VERY IMPORTANT: If the wrong namespace is used, the pod cannot start because it cannot retrieve the secret

kubectl delete secret $SA_SECRET_NAME --ignore-not-found
kubectl create secret generic $SA_SECRET_NAME \
  --from-file key-files/adroit-hall-301111-417090a2983b.json --namespace $SA_NAMESPACE