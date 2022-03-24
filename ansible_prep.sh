#!/usr/bin/env bash
my_file_id=$(curl -X POST \
    -H "BT-API-KEY: ${BT_API_KEY}" \
    --data "{\"data\": \"$(cat my.properties | base64)\", \"type\": \"token\"}" \
    -H 'Content-Type: application/json' \
    https://api.basistheory.com/tokens | jq -r .id)

my_api_id=$(curl -X POST \
    -H "BT-API-KEY: ${BT_API_KEY}" \
    --data "{\"data\": \"key_4taihgkj43646aasf\", \"type\": \"token\"}" \
    -H 'Content-Type: application/json' \
    https://api.basistheory.com/tokens  | jq -r .id)

echo "MY_API_TOKEN_ID: $my_api_id"
echo "MY_FILE_TOKEN_ID: $my_file_id"

echo "my_api_key: $my_api_id" > vars.yml
echo "my_properties_file: $my_file_id" >> vars.yml
