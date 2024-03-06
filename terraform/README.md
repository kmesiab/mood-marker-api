# Terraform

This API runs in an AWS ECS cluster with an internet gateway
and an application load balancer.  It lives in one VPC
with two subnets in two availability zones.

## Getting Started

Navigate to the `./terraform` folder and run 

```bash
tf init
tf plan
```

## Resources To Be Created

1. Load Balancer
2. Internet Gateway
3. ECS Cluster
   1. ECS Service
   2. ECS Task Definition
4. VPC 
   1. Subnet 1
   2. Subnet 2

---

## Configure:

Update `route_53_hosted_zone_id` with your own hosted zone.
Modify all references to the domain name `langtool.net`

---
## Outputs

### app_url

`mood-maker-api-lb-333775669.us-west-2.elb.amazonaws.com`

### repository_url
`462498369025.dkr.ecr.us-west-2.amazonaws.com/mood-marker-api`

# [DRAFT]