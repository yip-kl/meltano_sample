source .env

# Get credentials for the GKE cluster so that you can access it with kubectl.
gcloud container clusters get-credentials $COMPOSER_GKE_NAME \
  --project=$GCP_PROJECT \
  --location=$COMPOSER_GKE_LOCATION

# Define the name of the secret and the path to the service account key file.
export SA_SECRET_NAME=gcp-service-account
kubectl delete secret $SA_SECRET_NAME --ignore-not-found
kubectl create secret generic $SA_SECRET_NAME \
  --from-file key-files/$GCP_KEYFILE --namespace $SA_NAMESPACE