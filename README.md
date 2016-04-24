# letsencrypt
For letsencrypt request certificate && auto renew(monthly), 
include nghttpx(443 port) && stunnel(1979 port) within,
and leave port 80 for request & renew challenge of letsencrypt

# usage
If there is no cert, run it like this:
docker run -d -p 80:80 -p 443:443 -p 1979:1979 --name le \
-v "/root/log:/var/log/lep" \
-v "/etc/letsencrypt:/etc/letsencrypt" \
-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
-t novice/letsencrypt:latest --email xx@xxx.com -d xxx.com

else(/etc/letsencrypt/ already contained certs) just run it:
docker run -d -p 80:80 -p 443:443 -p 1979:1979 --name le \
-v "/root/log:/var/log/lep" \
-v "/etc/letsencrypt:/etc/letsencrypt" \
-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
-t novice/letsencrypt:latest

