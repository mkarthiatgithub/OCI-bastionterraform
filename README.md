# Terraform OCI  Bastion Service

## Project description

In this repository I have documented my hands-on experience with Terrafrom for the purpose of OCI Bastion Service deployment


## How to use code 

### Deploy Using the Terraform CLI

#### STEP 1.

Clone the repo from GitHub.com 
#### STEP 3. 
Next create environment file with TF_VARs or update in terraform.tfvars file 


#### STEP 4.
Run *terraform init* with upgrade option just to download the lastest neccesary providers:


Terraform has been successfully initialized!


#### STEP 5.
Run *terraform apply* to provision the content of this code (type **yes** to confirm the the apply phase):

Plan: 30 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + KarthiOCIFlexPublicLoadBalancer_Public_IP = [
      + (known after apply),
    ]
  + karthiOCIWebserver_PrivateIP              = [
      + [
          + (known after apply),
          + (known after apply),
        ],
    ]
  + bastion_ssh_metadata                         = [
      + (known after apply),
      + (known after apply),
    ]

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

tls_private_key.public_private_key_pair: Creating...
tls_private_key.public_private_key_pair: Creation complete after 0s [id=b3ccdb0167c728cc743170dc94bea9fd681360d6]

