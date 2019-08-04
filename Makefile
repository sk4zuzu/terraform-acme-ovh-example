
include Makefile.config

BINDIR ?= $(HOME)/bin

TERRAFORM_VERSION               ?= 0.12.3
TERRAFORM_PROVIDER_ACME_VERSION ?= 1.3.5
TERRAFORM_PROVIDER_OVH_VERSION  ?= 0.5.0
TERRAFORM_PROVIDER_TLS_VERSION  ?= 2.0.1

TARGETS := \
$(BINDIR)/terraform \
$(BINDIR)/terraform-provider-acme \
$(BINDIR)/terraform-provider-ovh \
$(BINDIR)/terraform-provider-tls

define hashicorp_release_install
$(BINDIR)/$(1): $(BINDIR)/$(1)-$(2)
	rm -f $$@ && ln -s $$< $$@
$(BINDIR)/$(1)-$(2):
	curl -fSL https://releases.hashicorp.com/$(1)/$(2)/$(1)_$(2)_linux_amd64.zip \
	| zcat >$$@ \
	&& chmod +x $$@
endef

export

.PHONY: all setup init apply clean

all: $(TARGETS)
	@echo
	@echo "1. create application on the OVH website https://eu.api.ovh.com/createApp/"
	@echo "2. provide values for TF_VAR_{APPLICATION_KEY,OVH_DNS_ZONE} variables (edit Makefile.config)"
	@echo "3. run make setup"
	@echo "4. validate credentials (use URL from the JSON payload) on the OVH website"
	@echo "5. provide values for remaining TF_VAR_ variables (edit Makefile.config)"
	@echo "6. run make apply"
	@echo "7. use output values from terraform somewhere"
	@echo

setup:
	$(SHELL) ovh.sh

init: $(TARGETS)
	terraform init

apply: init
	terraform apply

clean:
	-rm -rf $(TARGETS) .terraform/ *.backup

$(eval \
	$(call hashicorp_release_install,terraform,$(TERRAFORM_VERSION)))

$(eval \
	$(call hashicorp_release_install,terraform-provider-acme,$(TERRAFORM_PROVIDER_ACME_VERSION)))

$(eval \
	$(call hashicorp_release_install,terraform-provider-ovh,$(TERRAFORM_PROVIDER_OVH_VERSION)))

$(eval \
	$(call hashicorp_release_install,terraform-provider-tls,$(TERRAFORM_PROVIDER_TLS_VERSION)))

# vim:ts=4:sw=4:noet:syn=make:
