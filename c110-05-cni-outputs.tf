output "cni_iam_role_arn" {
  description = "CNI IAM Role ARN"
  value       = aws_iam_role.cni_iam_role.arn
}
output "cni_iam_policy_arn" {
  value = aws_iam_policy.cni_iam_policy.arn
}