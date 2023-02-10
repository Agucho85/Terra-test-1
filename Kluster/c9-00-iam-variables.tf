
# Variable para agregar mas usuarios al assume rol de eks-admin con sts
variable "users_to_add" {
  description = "User to add as admin in eks."
  type        = set(string)
  default     = [
    "kuchuflo1",
    "kuchuflo2",
  ]
}