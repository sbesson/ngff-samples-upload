#! /bin/sh
# A shell script allowing to deposit a file to Zenodo


ZIP_NAME=$1
DEPOSITION=$2

# # TBD Create a deposit and retrieve the links.bucket URL
# BUCKET=$(curl --request POST 'https://zenodo.org/api/deposit/depositions?access_token=$ZENODO_TOKEN' \
#      --header 'Content-Type: application/json'  \
#      --header "Authorization: Bearer $ZENODO_TOKEN" \
#      --data '{}' | jq --raw-output .links.bucket)

# Assumes an existing 
BUCKET=$(curl -H "Accept: application/json" -H "Authorization: Bearer $ZENODO_TOKEN" "https://www.zenodo.org/api/deposit/depositions/$DEPOSITION" | jq --raw-output .links.bucket)

# Upload the file with a progress bar
curl --progress-bar -o /dev/null --upload-file $ZIP_PATH \
     $BUCKET/$ZIP_NAME?access_token=$ZENODO_TOKEN
