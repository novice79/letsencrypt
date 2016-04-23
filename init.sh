#!/bin/bash
set -e
set -x
gc='/bin/get_cert.sh'
	
cat > "$gc" <<-EOCMD
    /letsencrypt/letsencrypt-auto certonly --standalone --agree-tos $@
EOCMD
chmod +x "$gc"
/bin/get_cert.sh > /var/log/le_init.log 2>&1
#exec "$gc"
exec /usr/bin/supervisord --nodaemon