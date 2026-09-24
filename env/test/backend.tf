terraform {

  backend "s3" {

    bucket = "speshway-project1-s3-120897"

    key = "test/terraform.tfstate"

    region = "ap-south-1"

    dynamodb_table = "terraform-lock"

    encrypt = true

    kms_key_id = "arn:aws:kms:ap-south-1:179897609830:key/21ccc3dc-931a-4838-9409-59a1041e7690"

  }

}

