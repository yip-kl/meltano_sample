export MELTANO_IMAGE=meltano_bbm
export GCP_PROJECT=adroit-hall-301111
export GCP_LOCATION=us-central1
export MELTANO_IMAGE_DEST_TAG=$GCP_LOCATION-docker.pkg.dev/$GCP_PROJECT/meltano-repo/$MELTANO_IMAGE
gcloud auth configure-docker $GCP_LOCATION-docker.pkg.dev --quiet # Make sure you are using the right credential to execute this script with gcloud auth list
docker tag $MELTANO_IMAGE $MELTANO_IMAGE_DEST_TAG # Tag the image with the destination tag
docker push $MELTANO_IMAGE_DEST_TAG # Push to GCP