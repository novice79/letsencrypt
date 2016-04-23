# letsencrypt
for letsencrypt auto renew

# usage
docker run -d -p 80:80 -p 443:443 --name le \
-v "/root/proxy.log:/var/log/proxy.log" \
-v "/etc/letsencrypt:/etc/letsencrypt" \
-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
-t novice/letsencrypt:latest --email xx@xxx.com -d xxx.com

