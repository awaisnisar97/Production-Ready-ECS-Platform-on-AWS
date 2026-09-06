# Troubleshooting I encountered during this project 

## AWS S3 bucket creation dependency 

- In order for my terraform state to be stored directly in a S3 backend, it was required to exist before terraform can initialise the backend and store the state remotely.
- Initially this was creating a dependency because the S3 bucket itself was being managed as part of the terraform infrastructure. 
- In order to rectify this I incorporated a bootstrap module, where I set up and deployed my S3 bucket first, which then could be referencedby the roo backend.tf configuration. 

## Terraform ECR dependency issue 

- During the docker build pipeline, the image was created and pushed to the ECR registry. However the ECR had yet to be created due to it being provisioned as part of a seperate terraform workflow, this ultimately meant the pipleine failed. 
- To resolve this, I incorporated the ECR repository into the boostrap module. ensuring that the repository was created before the application image pipeline attempted to push an image.
- I first ceated the ECR respository within the docker image workflow and then added a dependency to the docker build job,ensuring the build and push process would only run after the ECR respository had successfully, using needs: bootstrap-ecr.


# Github Actions --> AWS authentication failure 

- The GitHub Actions deployment pipeline initially failed when attempting to authenticate with AWS using GitHub's OpenID Connect (OIDC).
- The workflow was configured to assume an AWS IAM role, but AWS rejected the authentication request with an AccessDenied error.
- The issue was caused by an incorrect syntax in the IAM role's trust policy.
- The sub condition was not referencing the GitHub repository using the required OWNER/REPOSITORY format. The repository owner was missing from the configuration