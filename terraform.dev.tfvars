/* -------------------------------------------------------------------------- */
/*                                  Generics                                  */
/* -------------------------------------------------------------------------- */
generic_info = {
  region      = "ap-southeast-7",
  prefix      = "test",
  environment = "dev-th",
  name        = "app",
  custom_tags = {
    Workspace = "cmrs-pass-dev",
    Project     = "projectA"}
}

/* -------------------------------------------------------------------------- */
/*                                 Networking                                 */
/* -------------------------------------------------------------------------- */
networking_info = {
  vpc_id              = "vpc-0d6be2c0fe8bb363a",
  public_subnet_ids   = ["subnet-0bf984e955b2fdf80", "subnet-0fc8af97031f83e5c"]
  private_subnet_ids  = ["subnet-086ed7598eaecd0fa", "subnet-00a72389ec5a63220"]
  database_subnet_ids = ["subnet-0ae7f81fb2ff6106d", "subnet-0dc4eee4d0eb58361"]
  route_table_ids     = ["rtb-005afb677d41f6ad0", "rtb-0644c7d6364d5ad65"] # [Private, Public]
}



/* -------------------------------------------------------------------------- */
/*                                     RDS                                    */
/* -------------------------------------------------------------------------- */
rds_engine         = "postgres"
rds_engine_version = "17.2"
rds_instance_class = "db.t3.micro"
rds_storage = {
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
}
rds_storage_encrypted                               = true
rds_username                                        = "postgres"
rds_backup_retention_period                         = 7
rds_backup_window                                   = "03:00-04:00"
rds_maintenance_window                              = "Sat:04:00-Sat:05:00"
rds_deletion_protection                             = false
rds_enabled_cloudwatch_logs_exports                 = ["postgresql", "upgrade"]
rds_additional_cluster_security_group_ingress_rules = []
rds_parameter_family                                = "postgres17"
