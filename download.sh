#! /bin/sh
# A shell script allowing to download a Zarr datasets hosted on uk1s3
# and create a zip that can be read by the Zarr Python library

set -e
set -x

ZARR_PATH=$1
ZIP_NAME=$2

# Use aws sync to retrieve a Zarr dataset locally
mkdir -p /data/$ZARR_PATH
aws --endpoint-url https://uk1s3.embassy.ebi.ac.uk s3 sync s3://idr/$ZARR_PATH /data/$ZARR_PATH

# Create a flat zip 
(cd /data/$ZARR_PATH && zip -r0 ../$ZIP_NAME .)
ZIP_PATH=/data/${ZARR_PATH%/*}/$ZIP_NAME

# Run some minimal validation
python $(dirname $0)/test.py $ZIP_PATH
