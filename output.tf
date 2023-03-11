# output "ya_pass" { 
#     description = "vps pass's"
#     value = random_string.ya_pass.*.result
# }
# output "ya_login" { 
#     description = "vps logins"
#     value =   aws_route53_record.www.*.name
# }