#!/bin/bash
set -e
set -x
#--standalone-supported-challenges http-01 to use port 80
#--standalone-supported-challenges tls-sni-01 to use port 443

if [ $# != 0 ]
then 
gc='/bin/get_cert.sh'	
cat > "$gc" <<-EOCMD
#!/bin/sh
/letsencrypt/letsencrypt-auto certonly --standalone --agree-tos --standalone-supported-challenges http-01 $@
EOCMD
chmod +x "$gc"
#exec "$gc"
exec /usr/bin/supervisord --nodaemon
else 
	echo "please input parameters like this: --email xx@xxx.com -d xxx.com" 
fi