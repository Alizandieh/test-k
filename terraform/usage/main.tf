provider "aws" {
  region = "eu-west-3"
}

module "test-terraform" {
  source = "../module"

  role_name   = "test-role"
  group_name  = "test-group"
  user_name   = "test-user"
  policy_name = "test-policy"

  tags = {
    terraform = "true"
  }


}
