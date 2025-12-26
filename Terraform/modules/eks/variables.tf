variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "myeks-cluster"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.29"
  description = "Kubernetes version"
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.micro"]
  description = "Instance types for worker nodes"
}

variable "node_group_name" {
  type        = string
  description = "Name of the EKS node group"
  default     = "myeks-cluster-node-group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS node group"
}

variable "scaling_config" {
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
  })
  default     = { desired_size = 2, min_size = 2, max_size = 3 }
  description = "Scaling configuration for the EKS node group"
}

variable "tags" {
  type        = map(string)
  description = "Tags for the EKS node group"
  default     = {}
}

