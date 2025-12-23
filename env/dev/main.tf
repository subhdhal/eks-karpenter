module "vpc"{
    source = "../test-modules"
    cidr_block = var.cidr_block
    tags = var.tags
}