terraform {
  required_version = ">= 1.0.1"

  required_providers {
    aws        = "= 3.73.0"
    local      = "= 2.1.0"
    null       = "= 3.1.0"
    template   = "= 2.2.0"
    random     = "= 3.1.0"
    kubernetes = "~> 1.11"
  }
}
