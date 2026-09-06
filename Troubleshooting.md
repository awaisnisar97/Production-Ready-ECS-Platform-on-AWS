# Troubleshooting I encountered during this project 

## AWS S3 bucket creation dependency 

- In order for my terraform state to be stored directly in the S3 bucket, it was required to exist before the creation of the state file. 
- In order to rectify this I incorporated a bbotsrap module, where i declared and set up my S3 bucket and referenced the bucket created wihtin the root backend.tf. 

## Terraform ECR dependency issue 

- During my docker build pipeline it created the image and pushed to the ECR registry, however the ECR was yet to be created due to it being in a seprate terraform infrastructure build workflow. this ultimately meant the pipleine failed. 
- In order to rectify this i used the boostrap module, this is where you set up resources that are required before your main infrastructure can be deployed. 
- I did this by first referencing and building the ecr repositiory within the docker build pipeline then referencing the bootstrap module in the docker build by stating needs: bootstrap-ecr 


# Github Actions --> AWS authentication failure 

- The GitHub Actions deployment pipeline initially failed when attempting to authenticate with AWS using GitHub's OpenID Connect (OIDC).
- The workflow was configured to assume an AWS IAM role, but AWS rejected the authentication request with an AccessDenied error.
- The issue was caused by an incorrect syntax in the IAM role's trust policy.
- The sub condition was not referencing the GitHub repository using the required OWNER/REPOSITORY format. The repository owner was missing from the configuration