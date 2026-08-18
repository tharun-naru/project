terraform {

  backend "s3" {

    bucket = "speshway-project1-s3-120897"

    key = "prod/terraform.tfstate"

    region = "ap-south-1"

    dynamodb_table = "terraform-lock"

    encrypt = true

    kms_key_id = "arn:aws:kms:ap-south-1:179897609830:key/1b15760b-4547-4e20-bc0b-586f8571468a"

  }

}

