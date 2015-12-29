# letsencrypt
just for letsencrypt in docker

# usage
docker run -it --rm -p 443:443 -p 80:80 --name letsencrypt \
-v "/etc/letsencrypt:/etc/letsencrypt" \
-v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
novice/letsencrypt:latest
**and then**
letsencrypt certonly --standalone --agree-tos --email xx@xxx.com -d xxx.com
