package terraform.validation

# Mandatory tags
mandatory_tags := {
  "Department",
}

# Allowed values for specific tags
allowed_values := {
  "Department": {"IT","HR"}
}

# List of applicable Terraform resource types
resource_types := {
  "aws_instance", "aws_security_group", "aws_acm_certificate", "aws_athena_database", 
  "aws_api_gateway_rest_api", "aws_mwaa_environment", "aws_cloudformation_stack",
  "aws_cloudfront_distribution", "aws_cloudtrail", "aws_cloudwatch_log_group",
  "aws_codebuild_project", "aws_config_config_rule", "aws_chatbot_slack_channel_configuration",
  "aws_dlm_lifecycle_policy", "aws_dms_replication_instance", "aws_dynamodb_table",
  "aws_elasticache_cluster", "aws_efs_file_system", "aws_elb", "aws_elasticsearch_domain",
  "aws_cloudwatch_event_rule", "aws_kinesis_firehose_delivery_stream", "aws_grafana_workspace",
  "aws_iot_topic_rule", "aws_kinesis_stream", "aws_lambda_function", "aws_db_instance",
  "aws_route53_zone", "aws_route53_domain_registration", "aws_s3_bucket",
  "aws_servicecatalog_portfolio", "aws_shield_protection", "aws_sns_topic",
  "aws_ssoadmin_managed_policy_attachment", "aws_sqs_queue", "aws_sfn_state_machine",
  "aws_waf_web_acl", "aws_wafregional_web_acl", "aws_ecr_repository", "aws_ecrpublic_repository",
  "aws_ecs_cluster", "aws_eks_cluster", "aws_service_discovery_service", "aws_secretsmanager_secret",
  "aws_cognito_user_pool", "aws_cognito_identity_pool", "aws_guardduty_detector",
  "aws_securityhub_account", "aws_xray_group", "aws_glue_catalog_database",
  "aws_cloud9_environment_ec2", "aws_sagemaker_model", "aws_emr_cluster",
  "aws_ssm_parameter", "aws_msk_cluster", "aws_ses_domain_identity", "aws_transfer_server",
  "aws_appautoscaling_target", "aws_imagebuilder_image_recipe", "aws_pinpoint_app",
  "aws_mq_broker", "aws_wafv2_web_acl", "aws_synthetics_canary", "aws_quicksight_group",
  "aws_emrserverless_application", "aws_iam_policy"
}

# Default to deny unless explicitly allowed
default allow := false

# Allow only if there are no deny messages
allow if {
  not deny
}

# Deny if a resource is missing mandatory tags
deny[msg] if {
  some resource in input.resource_changes
  resource.type in resource_types
  not contains(resource.change.actions, "delete")  # Ignore deleted resources

  tags := object.get(resource.change.after, "tags", {})

  # Safe way to collect missing tags
  missing_tags := {tag | tag = mandatory_tags[_]; object.get(tags, tag, null) == null}

  count(missing_tags) > 0

  msg := sprintf("Resource '%s' is missing mandatory tags: %v", [resource.address, missing_tags])
}

# Deny if a tag has an invalid value
deny[msg] if {
  some resource in input.resource_changes
  resource.type in resource_types
  not contains(resource.change.actions, "delete")  # Ignore deleted resources

  tags := object.get(resource.change.after, "tags", {})

  some tag in mandatory_tags
  tag_value := object.get(tags, tag, null)
  tag_value != null
  allowed_values[tag]
  not tag_value in allowed_values[tag]

  msg := sprintf("Resource '%s' has an invalid value '%s' for tag '%s'", [resource.address, tag_value, tag])
}
