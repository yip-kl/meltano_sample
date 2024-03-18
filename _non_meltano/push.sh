source .env

gcloud auth configure-docker $GCP_IMAGE_LOCATION-docker.pkg.dev --quiet # Make sure you are using the right credential to execute this script with gcloud auth list
docker tag $MELTANO_IMAGE $MELTANO_IMAGE_DEST_TAG # Tag the image with the destination tag
docker push $MELTANO_IMAGE_DEST_TAG # Push to GCP