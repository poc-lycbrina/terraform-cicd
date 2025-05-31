/* -------------------------------------------------------------------------- */
/*                                  Generics                                  */
/* -------------------------------------------------------------------------- */
variable "generic_info" {
  description = "Generic infomation"
  type = object({
    region      = string
    prefix      = string
    environment = string
    name        = string
    custom_tags = map(any)
  })
}

/* -------------------------------------------------------------------------- */
/*                                 Networking                                 */
/* -------------------------------------------------------------------------- */
variable "networking_info" {
  description = <<EOF
  `vpc_id`              >> VPC to deploy the cluster in
  `public_subnet_ids`   >> Public subnets for AWS Application Load Balancer deployment
  `private_subnet_ids`  >> Private subnets for container deployment
  `database_subnet_ids` >> private subnets for ElastiCache cluster
  EOF
  type = object({
    vpc_id               = string
    public_subnet_ids    = list(string)
    private_subnet_ids   = list(string)
    database_subnet_ids  = list(string)
    secondary_subnet_ids = list(string)
    route_table_ids      = list(string)
  })
}


/* -------------------------------------------------------------------------- */
/*                                     RDS                                    */
/* -------------------------------------------------------------------------- */
variable "rds_engine" {
  description = "The database engine to use"
  type        = string
}

variable "rds_engine_version" {
  description = "The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10). The actual engine version used is returned in the attribute engine_version_actual, defined below."
  type        = string
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "rds_storage" {
  description = <<EOF
  allocated_storage     >> The allocated storage in gigabytes
  max_allocated_storage >> When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. Must be greater than or equal to allocated_storage or leave as default to disable Storage Autoscaling
  storage_type          = "gp3"

  EOF
  type = object({
    allocated_storage     = number
    max_allocated_storage = number
    storage_type          = string
    iops                  = optional(number)
    storage_throughput    = optional(number)
  })
  default = {
    allocated_storage     = 20
    max_allocated_storage = 50
    storage_type          = "gp3"
  }
}

variable "rds_storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
}

variable "rds_credential" {
  description = <<EOF
  username >> (Required unless a snapshot_identifier or replicate_source_db is provided) Username for the master DB user. Cannot be specified for a replica.
  password >> (Required unless a snapshot_identifier or replicate_source_db is provided) Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file.
  EOF
  type = object({
    username = string
    password = string
  })
  sensitive = true
}

variable "app_db_credential" {
  description = <<EOF
  username >> (Required unless a snapshot_identifier or replicate_source_db is provided) Username for the master DB user. Cannot be specified for a replica.
  password >> (Required unless a snapshot_identifier or replicate_source_db is provided) Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file.
  EOF
  type = object({
    username = string
    password = string
  })
  sensitive = true
}

variable "rds_backup_retention_period" {
  description = "The days to retain backups for. Mostly, for non-production is 7 days and production is 30 days. Default to 7 days"
  type        = number
  default     = 30
}

variable "rds_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = null
}

variable "rds_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}

variable "rds_deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "rds_enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace."
  type        = list(string)
  default     = []
}

variable "rds_additional_client_security_group_ingress_rules" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    description              = string
  }))
  description = "Additional ingress rule for client security group."
  default     = []
}

variable "rds_additional_cluster_security_group_ingress_rules" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = list(string)
    source_security_group_id = string
    description              = string
  }))
  description = "Additional ingress rule for cluster security group."
  default     = []
}

variable "rds_parameter_family" {
  description = "The database family to use"
  type        = string
}

variable "rds_parameters" {
  description = "A list of DB parameter maps to apply"
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default = []
}

variable "is_database_created" {
  description = "if create postgres database"
  type        = bool
  default     = true
}
