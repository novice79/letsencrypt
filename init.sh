#!/bin/bash
set -e
set -x
gc='/bin/get_cert.sh'
	
cat > "$gc" <<-EOCMD
    /letsencrypt/letsencrypt-auto certonly --standalone --agree-tos $@
EOCMD
chmod +x "$gc"

exec "$gc"
exec /usr/bin/supervisord --nodaemon