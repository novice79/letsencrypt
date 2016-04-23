#!/bin/bash
set -e
set -x

if [ $# != 0 ]
then 
gc='/bin/get_cert.sh'	
cat > "$gc" <<-EOCMD
#!/bin/sh
/letsencrypt/letsencrypt-auto certonly --standalone --agree-tos $@
EOCMD
chmod +x "$gc"
#exec "$gc"
exec /usr/bin/supervisord --nodaemon
else 
	echo "please input parameters like this: --email xx@xxx.com -d xxx.com" 
fi