data "aws_caller_identity" "peer" {
  count    = lookup(var.region_enabled_map, local.aws_env)
  provider = aws.peer
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer" {
  count         = lookup(var.region_enabled_map, local.aws_env)
  vpc_id        = module.vpc.vpc_id
  peer_vpc_id   = var.virginia_vpc_id
  peer_owner_id = data.aws_caller_identity.peer[0].account_id
  peer_region   = "us-east-1"
  auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  count                     = lookup(var.region_enabled_map, local.aws_env)
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[0].id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}


resource "aws_route" "frankfurt_public_1a_routing" {
  count                     = lookup(var.region_enabled_map, local.aws_env)
  route_table_id            = module.vpc.route_table_main
  destination_cidr_block    = var.virginia_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[0].id
}

resource "aws_route" "virginia_public_1a_routing" {
  count                     = lookup(var.peering_region_enabled_map, local.aws_env)
  route_table_id            = module.vpc.route_table_main
  destination_cidr_block    = var.frankfurt_vpc_cidr_block
  vpc_peering_connection_id = var.vpc_peering_connection_id
}