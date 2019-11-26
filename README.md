
TERRAFORM-ACME-OVH-EXAMPLE
==========================

## 1. PURPOSE

Configure [OVH application credentials](https://eu.api.ovh.com/console/#/me/api/credential#GET), then use [terraform ACME provider](https://www.terraform.io/docs/providers/acme/index.html) to get SSL certificates via [DNS-01 challenge](https://letsencrypt.org/docs/challenge-types/).

`This is just an example.`

## 2. PREREQUISITES

- OVH account
- OVH dns zone
- make
- curl

## 3. OVH API

Useful links:

- APPLICATION: [https://eu.api.ovh.com/createApp/](https://eu.api.ovh.com/createApp/)
- APPLICATION: [https://eu.api.ovh.com/console/#/me/api/application#GET](https://eu.api.ovh.com/console/#/me/api/application#GET)
- APPLICATION: [https://eu.api.ovh.com/console/#/me/api/application/%7BapplicationId%7D#GET](https://eu.api.ovh.com/console/#/me/api/application/%7BapplicationId%7D#GET)
- CREDENTIALS: [https://eu.api.ovh.com/console/#/me/api/credential#GET](https://eu.api.ovh.com/console/#/me/api/credential#GET)
- CREDENTIALS: [https://eu.api.ovh.com/console/#/me/api/credential/%7BcredentialId%7D#GET](https://eu.api.ovh.com/console/#/me/api/credential/%7BcredentialId%7D#GET)

Please keep in mind that POST type calls CANNOT be executed successfully from the [https://eu.api.ovh.com](https://eu.api.ovh.com) web interface.

## 4. TERRAFORM BINARIES

All required terraform binaries are statically linked (standard golang binaries). Installation is automated via make:
```
$ make
``` 

## 5. USAGE

Execute and follow instructions:
```
$ make

1. create application on the OVH website https://eu.api.ovh.com/createApp/
2. provide values for TF_VAR_{APPLICATION_KEY,OVH_DNS_ZONE} variables (edit Makefile.config)
3. run make setup
4. validate credentials (use URL from the JSON payload) on the OVH website
5. provide values for remaining TF_VAR_ variables (edit Makefile.config)
6. run make apply
7. use output values from terraform somewhere

```

[//]: # ( vim:set ts=2 sw=2 et syn=markdown: )
