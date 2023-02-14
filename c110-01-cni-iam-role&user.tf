resource "aws_iam_policy" "cni_iam_policy" {
  name        = "${local.name}-cni_iam_policy"
  path        = "/"
  description = "EKS CNI IAM Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AssignPrivateIpAddresses",
                "ec2:AttachNetworkInterface",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeInstanceTypes",
                "ec2:DetachNetworkInterface",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:UnassignPrivateIpAddresses"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateTags"
            ],
            "Resource": [
                "arn:aws:ec2:*:*:network-interface/*"
            ]
        }
    ]
})
}


output "cni_iam_policy_arn" {
  value = aws_iam_policy.cni_iam_policy.arn 
}

# Resource: Create IAM Role and associate the CNI IAM Policy to it
resource "aws_iam_role" "cni_iam_role" {
  name = "${local.name}-cni-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.oidc_provider.arn}"
        }
        Condition = {
          StringEquals = {            
            "${local.aws_iam_oidc_connect_provider_extract_from_arn}:sub": "system:serviceaccount:kube-system:aws-node"
          }
        }        

      },
    ]
  })

  tags = {
    tag-key = "${local.name}-cni-iam-role"
  }
}

# Associate EBS CNI IAM Policy to EBS CNI IAM Role
resource "aws_iam_role_policy_attachment" "cni_iam_role_policy_attach" {
  policy_arn = aws_iam_policy.cni_iam_policy.arn 
  role       = aws_iam_role.cni_iam_role.name
}