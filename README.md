# Terraform_Ansible_Jenkins-Assignment

Created AWS services through Terraform code

Created Ansible Inventory and Playbook file to Install Docker on Jenkins and App hosts

Created Jenkins Build Pipeline



# Task 1:
Created AWS Infrastructure using Terraform modules and codes.
The GITHUB link has all the TF files which I created for the entire Infra includes:
AWS VPC,
1 IGW,
1 NAT-GW in AZ-a, 
Subnets (2 public & 2 private, 1 each in AZ-a &b), 
Route Tables for both subnets
Security Groups with one public and 2 private ones.
EC2 instances for Bastion, Jenkins and App Hosts
S3 for the backend

# Task 2:
Installed Jenkins on the Jenkins Instance 
Installed Ansible on the Bastion Host and installed Docker through Ansible Playbook from the Bastion Host to the Jenkins and App Hosts.
Created ALB and Target Groups with ports 80 and 8080 to redirect the request to /Jenkins and /app hosts.
Created ECR repo and pushed the Images.
# Task 3:
Created GITHUB repository and pushed the files to the repo in the master branch
Built the Jenkins Pipeline to build a docker image of the node application
Created the pipeline which pulls the above mentioned GITHUB repo to build the Pipeline.
Deployed Jenkins CI/CD to build and run the docker image in Jenkins and App hosts.
