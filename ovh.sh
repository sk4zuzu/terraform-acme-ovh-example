#!/usr/bin/env bash

: ${TF_VAR_OVH_APPLICATION_KEY:=$1}
: ${TF_VAR_OVH_DNS_ZONE:=$2}

set -o errexit -o nounset -o pipefail

which curl

auth_credential_POST() {
    curl \
        -fvSL \
        -XPOST \
        -H "X-Ovh-Application: ${TF_VAR_OVH_APPLICATION_KEY}" \
        -H "Content-type: application/json" \
        https://eu.api.ovh.com/1.0/auth/credential -d "{
            \"accessRules\": [
                {
                    \"method\": \"GET\",
                    \"path\": \"/domain/zone/${TF_VAR_OVH_DNS_ZONE}\"
                },
                {
                    \"method\": \"GET\",
                    \"path\": \"/domain/zone/${TF_VAR_OVH_DNS_ZONE}/record/*\"
                },
                {
                    \"method\": \"POST\",
                    \"path\": \"/domain/zone/${TF_VAR_OVH_DNS_ZONE}/record\"
                },
                {
                    \"method\": \"POST\",
                    \"path\": \"/domain/zone/${TF_VAR_OVH_DNS_ZONE}/refresh\"
                },
                {
                    \"method\": \"PUT\",
                    \"path\": \"/domain/zone/${TF_VAR_OVH_DNS_ZONE}/record/*\"
                },
                {
                    \"method\": \"DELETE\",
                    \"path\": \"/domain/zone/${TF_VAR_OVH_DNS_ZONE}/record/*\"
                }
            ],
            \"redirection\": \"https://${TF_VAR_OVH_DNS_ZONE}\"
        }"
}

auth_credential_POST

echo

read -p "Validate credentials (use the URL from the JSON payload) then press ENTER to continue..."

read -p "Is it really validated... ? o_0"

read -p "C'mon dude just do it OK... ? XD"

echo o/

# vim:ts=4:sw=4:et:syn=sh:
