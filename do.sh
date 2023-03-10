#!/bin/bash -eux

deploy() {
    env="$1"
    terraform init
    terraform plan -var-file "$env.tfvars.json" -out tfplan

    read -p "Apply? [y/n] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return 1
    fi

    terraform apply tfplan
}

version-up() {
    version="$1"
    aws s3 sync ./site/ s3://terraform-20230307220052058900000002/$version/
    jq \
        --arg version "$version" \
        '.artifact_version = $version' dev.tfvars.json \
        >tmp && mv tmp dev.tfvars.json

    deploy dev
}

promote() {
    from=dev
    to=prd
    version=$(jq '.artifact_version' -r "$from.tfvars.json")

    jq \
        --arg version "$version" \
        '.artifact_version = $version' "$to.tfvars.json" \
        >tmp && mv tmp "$to.tfvars.json"

    deploy prd
}

"$@"
