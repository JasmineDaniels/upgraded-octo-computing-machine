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

#TODO: Update Zip file permissions

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