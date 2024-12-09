### About

This bash script extracts the private key, certificate, and chain certificates from a .pfx file, removes any unnecessary metadata (such as Bag Attributes), and then packages the cleaned certificates and keys into a ZIP file (files are prepared in the apache format) for installation on the linux servers.<br><br>
It is designed to facilitate the export of SSL certificates, private keys, and intermediate certificates for a specified domain.

### How the Script Works:
Input:

The script prompts the user for two inputs:<br>
Domain Name: The domain associated with the certificate (e.g., example.com).<br>
PFX Password: The password for the .pfx file that contains the private key, certificate, and chain certificates.<br><br>
Extracting the Components:<br>
<br>
The script uses openssl commands to extract three components from the .pfx file:<br>
- Private Key: Extracted using the -nocerts option to avoid pulling in certificates.<br>
- Certificate (Public Key): Extracted using the -clcerts option to include only the end-entity certificate, excluding the CA certificates.<br>
- Chain Certificates (Intermediate Certificates): Extracted using the -cacerts option to include all intermediate certificates in the chain.<br><br>

Each of these components is cleaned using the awk command to strip away unwanted metadata like Bag Attributes, localKeyID, and friendlyName which may appear in the .pem format.<br>
<br>
Saving Files:<br>
The cleaned certificates and keys are saved in separate files:<br>
- example_com_private_key.pem (Private Key)<br>
- example_com_certificate.pem (Public Certificate)<br>
- example_com_chain_certs.pem (Intermediate Certificates)<br>

Creating a Folder:<br>
The script creates a directory named example_com_ssl_cert_pack to store the extracted files.<br>

Packaging:
The three PEM files are moved into the newly created directory.<br>
The directory is then zipped into a file named example_com_ssl_cert_pack.zip.<br><br>

Cleanup:<br>
The script removes the temporary directory (example_com_ssl_cert_pack) after zipping it, leaving only the ZIP file as output.<br><br>

Usage:<br>
Make the script executable:<br>

```console
chmod +x certificate-export.sh
```

Run the script:<br>
```console
./certificate-export.sh
```

Follow the prompts:<br>

The script will ask you to input the domain name and PFX password.<br><br>

Output:<br>
After running, you will receive a ZIP file named example_com_ssl_cert_pack.zip containing the following files:<br>
- example_com_private_key.pem (Private key)
- example_com_certificate.pem (SSL certificate)
- example_com_chain_certs.pem (Intermediate certificates)<br>

Dependencies:<br>
The script requires openssl and awk to extract and clean the PEM files.<br>
It works with .pfx files that contain the private key, SSL certificate, and chain certificates.<br>

Example:<br>
Run the script:

```console
bash certificate-export.sh
```

Enter the domain name: example.com and the PFX password.
The script extracts the necessary files, cleans them from metadata, and produces the following ZIP file: example_com_ssl_cert_pack.zip.<br>
This script simplifies the process of preparing SSL certificates for server installation and can be used by administrators to easily export and send certificates to hosting providers or other administrators.<br><br>
