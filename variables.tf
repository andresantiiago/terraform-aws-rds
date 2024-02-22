variable "db_name" {
    type        = string
}

variable "identifier" {
    type        = string
}

variable "engine" {
    type        = string
}

variable "engine_version" {
    type        = string
}

variable "username" {
    type        = string
    default     = "foobar"
}

variable "password" {
    type        = string
    default     = "foobarbaz"
}

variable "instance_class" {
    type        = string
    default     = "db.m5.large"
}

variable "multi_az" {
    type        = bool
    default     = false
}

variable "availability_zone" {
    type        = string
    default     = "sa-east-1a"
}

variable "subnet_ids" {
    type        = list(string)
}

variable "vpc_id" {
    type        = string
}

variable "security_group_rules" {
    type        = any
}

variable "storage_type" {
    type        = string
    default     = "gp2"
}

variable "allocated_storage" {
    type        = string
}

variable "max_allocated_storage" {
    type        = string
}

variable "storage_encrypted" {
    type        = bool
    default     = true
}

variable "skip_final_snapshot" {
    type        = bool
    default     = true
}

variable "customer_owned_ip_enabled" {
    type        = bool
    default     = true
}

variable "publicly_accessible" {
    type        = bool
    default     = false
}

variable "tags" {
    type = any
}