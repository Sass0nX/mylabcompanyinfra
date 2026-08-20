resource "aws_secretsmanager_secret" "secret_manager_name" {
    for_each = var.secrets
    name = each.key
}

resource "aws_secretsmanager_secret_version" "secret_manager_value" {
  for_each = var.secrets
  secret_id     = aws_secretsmanager_secret.secret_manager_name[each.key].id
  secret_string = jsonencode(each.value)
}