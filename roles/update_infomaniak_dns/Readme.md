// Actually, the API does not provide API to management of sub domain
// => create the records manually, and then update by script
export INFOMANIAK_TOKEN=<<secret token from infomaniak website>>


export EXTENSION_DOMAIN=gogs

export MAIN_DOMAIN=meallier.fr
export SUB_DOMAIN=test
export FQDN="$EXTENSION_DOMAIN.$SUB_DOMAIN.$MAIN_DOMAIN"
export TARGET_FOR_EXTENSION=8.8.8.8
export TTL=1800


ACCOUNT_ID=`curl -s "https://api.infomaniak.com/1/product?service_name=domain&customer_name=${MAIN_DOMAIN}" --header "Authorization: Bearer $INFOMANIAK_TOKEN" | jq -r '.data[].id'`

RECORD_ID=`curl -s "https://api.infomaniak.com/1/domain/${ACCOUNT_ID}/dns/record" --header "Authorization: Bearer $INFOMANIAK_TOKEN" | jq -r --arg fqdn $FQDN '.data | map(select(.source_idn == $fqdn)) | .[0].id'`

// Update to the record

curl -s -X PUT -H "Authorization: Bearer $INFOMANIAK_TOKEN" -d target=$TARGET_FOR_EXTENSION -d ttl=$TTL "https://api.infomaniak.com/1/domain/${ACCOUNT_ID}/dns/record/${RECORD_ID}"