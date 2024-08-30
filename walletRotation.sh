#!/bin/bash
#Essbase Client Wallet Rotation Script

DATE=`date +%m%d%y`
WALLET_DIR='' 
WALLET_ZIP_FILE=""

#TODO: Get Wallet Files

#TODO: Update Zip file permissions

#TODO: **MUST CLARIFY AUTHENTICATION** 

#Test Updated Connection Dry Run: 
test_connection(){
echo "Testing Connection" 
CONNECTION_NAME=$1
cat << EOF > conn_details.json
{
    "name" : "$CONNECTION_NAME",
    "type" : "DB",
    "subtype" : "ORACLE",
    "walletPath" : $WALLET_DIR,
    "repoWallet" : "false",
    "user" : "",
    "password" : "",
    "service" : ""
}
EOF
curl -X POST -i "https://myserver.example.com:9001/essbase/rest/v1/connections/actions/test" -H Accept:application/json -H Content-Type:application/json --data "conn_details.json" -u %User%:%Password%
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to Test Connection."
    exit 1
fi
}

#Upload Global Connection Wallet File 
upload_wallet(){
    echo "Uploading Wallet..."
    CONNECTION_NAME=$1
    curl -X PUT "https://myserver.example.com:9001/essbase/rest/v1/connections/$CONNECTION_NAME/wallet" -H Accept:application/json -H Content-Type:application/octet-stream --data-binary $WALLET_ZIP_FILE -u %User%:%Password%
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
        #TODO: Add Else Case
    fi
}


#Test Connection
final_connection_test(){
    echo "Testing New Connection..."
    CONNECTION_NAME=$1
    curl -X POST -i "https://myserver.example.com:9001/essbase/rest/v1/connections/$CONNECTION_NAME/actions/test" -H Accept:application/json -u %User%:%Password%

    if [[ $? -ne 0 ]]; then
        echo "Error occurred while testing connection."
        exit 1
    fi
}

#List Connections
list_connections(){
    connections=($(curl -X GET "https://myserver.example.com:9001/essbase/rest/v1/connections?links=none" -H Accept:application/json -u %User%:%Password% | jq -r ".[].name"))
    for connection_name in ${connections[*]}
    do 
    test_connection $connection_name
    upload_wallet $connection_name
    final_connection_test $connection_name
    done
}

list_connections