variable "ami" {
  type = string
  default = "ami-036e229aa5fa198ba"
}

variable "instance_type" {
  type = string
  default = "t2.medium"
}

variable "instance_names" {
  
  type = list(string)
  default = [

    "idx1", 
    "idx2", 
    "idx3", 
    "idx4",
    "uf1",
    "uf2",
    "sh1", 
    "sh2", 
    "ds/mc", 
    "search_captain",
    "license_master",
    "cmaster"
  ]

}

variable "availability_zone" {
  type = string
  default = "eu-west-2a"
}