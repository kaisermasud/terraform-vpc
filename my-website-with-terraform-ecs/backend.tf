# store the terraform state file in s3
terraform {
    backend "s3" {
      bucket   = "my-website-backend-remote-state"
      key      = "my-website-with-terraform-ecs.tfstate"
      region   = "us-east-1"
      profile  = "terraform-user"
    }
    
}