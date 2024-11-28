#!/bin/bash

# Ask for domain and PFX password
read -p "Enter the domain name (e.g., example.com): " DOMAIN
read -sp "Enter the PFX password: " PFX_PASSWORD
echo

# Extract private key, certificate, and chain certificates with cleaner options
openssl pkcs12 -in "${DOMAIN}.pfx" -nocerts -nodes -passin pass:"$PFX_PASSWORD" | \
    awk '/-----BEGIN PRIVATE KEY-----/,/-----END PRIVATE KEY-----/ {print}' > "${DOMAIN}_private_key.pem"

openssl pkcs12 -in "${DOMAIN}.pfx" -clcerts -nokeys -passin pass:"$PFX_PASSWORD" | \
    awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/ {print}' > "${DOMAIN}_certificate.pem"

openssl pkcs12 -in "${DOMAIN}.pfx" -cacerts -nokeys -chain -passin pass:"$PFX_PASSWORD" | \
    awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/ {print}' > "${DOMAIN}_chain_certs.pem"

# Create folder and move cleaned files into it
mkdir -p "${DOMAIN}_ssl_cert_pack"
mv "${DOMAIN}_private_key.pem" "${DOMAIN}_certificate.pem" "${DOMAIN}_chain_certs.pem" "${DOMAIN}_ssl_cert_pack/"

# Package the folder into a ZIP file
zip -r "${DOMAIN}_ssl_cert_pack.zip" "${DOMAIN}_ssl_cert_pack"

# Cleanup (optional): Remove the folder after zipping
rm -rf "${DOMAIN}_ssl_cert_pack"

# Done
echo "Certificate files have been packaged into ${DOMAIN}_ssl_cert_pack.zip"
