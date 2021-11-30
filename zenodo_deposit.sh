#! /bin/sh
# A shell script allowing to download and zip Zarr datasets hosted on uk1s3
# and create a Zenodo deposit


ZARR_PATH=$1
ZIP_NAME=$2

# Use aws sync to retrieve a Zarr dataset locally
mkdir -p /data/$ZARR_PATH
aws --endpoint-url https://uk1s3.embassy.ebi.ac.uk s3 sync s3://idr/$ZARR_PATH /data/$ZARR_PATH

# Create a flat zip 
(cd /data/$ZARR_PATH && zip -r0 ../$ZIP_NAME .)
ZIP_PATH=${ZARR_PATH%/*}/$ZIP_NAME

# Run some minimal validation
python $(dirname $0)/test.py $ZIP_PATH

# Create a deposit and retrieve the links.bucket URL
BUCKET=$(curl --request POST 'https://zenodo.org/api/deposit/depositions?access_token=$ZENODO_TOKEN' \
     --header 'Content-Type: application/json'  \
     --header "Authorization: Bearer $ZENODO_TOKEN" \
     --data '{}' | jq --raw-output .links.bucket)

# If the deposit exists e.g. if it was created via the UI
# BUCKET=$(curl -H "Accept: application/json" -H "Authorization: Bearer $ZENODO_TOKEN" "https://www.zenodo.org/api/deposit/depositions/$DEPOSITION" | jq --raw-output .links.bucket)

# Upload the file with a progress bar
curl --progress-bar -o /dev/null --upload-file $ZIP_PATH \
     $BUCKET/$ZIP_NAME?access_token=$ZENODO_TOKEN
