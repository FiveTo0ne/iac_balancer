%{ for index, item in fqdn ~}
[${prefix[index]}s]
    ${prefix[index]} ansible_host=${ipv4[index]} ansible_password=${pass[index]} ansible_become_password=${pass[index]}  inv_user=${prefix[index]} fqdn=${fqdn[index]}
%{ endfor ~}        
        
[all:vars]        
ansible_user=${user}       
letsencrypt_email=${email}   
