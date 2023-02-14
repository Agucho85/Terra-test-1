output "cni_iam_role_arn" {
  description = "CNI IAM Role ARN"
  value = aws_iam_role.cni_iam_role.arn
}