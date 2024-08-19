#!/bin/bash
#Essbase Client Wallet Rotation Script

DATE=`date +%m%d%y`
WALLET_ZIP_FILE=''
CLIENT_NAME=''
CONNECTION_NAME=''
WALLET_DIR='' 

#Consider using jq to parse json responses from curl 
# Ensure jq is installed
# if ! command -v jq &> /dev/null; then
#     echo "jq could not be found, please install it."
#     exit 1
# fi

#TODO: Get Wallet Files

#Define directory where .zip is stored
DOWNLOAD_DIR="$Home/Downloads"
#Get today's date 
TODAY=$(date +%Y-%m-%d)
#Use find command to find the .zip uploaded on today's date
WALLET_ZIP_FILE=$(find "$DOWNLOAD_DIR" -type f -name "*.zip" -newermt "$TODAY" ! -newermt "$TODAY +1 day" | head -n 1)
# Check if the ZIP file was found
if [[ -z "$WALLET_ZIP_FILE" ]]; then
    echo "Error: No wallet ZIP file found in $DOWNLOAD_DIR for today's date."
    exit 1
else
    echo "Wallet ZIP file found: $WALLET_ZIP_FILE"
fi


#TODO: Update Zip file permissions
chmod 600 "$WALLET_ZIP_FILE"
#Check if permissions were properly set
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to set permissions for $WALLET_ZIP_FILE."
    exit 1
else
    echo "Permissions set for $WALLET_ZIP_FILE."
fi



#TODO: Test Updated Connection Dry Run: 
#Documentation https://docs.oracle.com/en/database/other-databases/essbase/21/essrt/op-connections-actions-test-post.html
#create json (EOF) with service and walletPath properties
test_connection(){

}

#Upload Global Connection Wallet File
# **MUST CLARIFY AUTHENTICATION** via properties.bat file or some other method..
upload_wallet(){
    echo "Uploading Wallet..."
    curl -X PUT "https://myserver.example.com:9001/essbase/rest/v1/connections/$CONNECTION_NAME/wallet" -H Accept:application/json -H Content-Type:application/octet-stream --data-binary "@./dbwallet.zip" -u %User%:%Password%
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to Update wallet."
        exit 1
    fi

    #Check Service Name
    # ** check if service name is set to medium**
    response=$(curl -X GET "https://myserver.example.com:9001/essbase/rest/v1/connections/$CONNECTION_NAME?links=none" -H Accept:application/json -u %User%:%Password%)
    service=$(echo $response | jq ".service")
    if [[ $service == *"medium"* ]]; then
        echo "Service name is set to medium."
    fi
}


#Test Connection
# **MUST CLARIFY AUTHENTICATION** via properties.bat file or some other method..
final_connection_test(){
    echo "Testing New Connection..."
    curl -X POST -i "https://myserver.example.com:9001/essbase/rest/v1/connections/$CONNECTION_NAME/actions/test" -H Accept:application/json -u %User%:%Password%

    if [[ $? -ne 0 ]]; then
        echo "Error occurred while testing connection."
        exit 1
    fi
}