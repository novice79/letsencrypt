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
exec "$gc" > /var/log/lep/init.log 2>&1
else 
	echo "no input, just do renew cert monthly"     
fi

for d in /etc/letsencrypt/live/* ; do
  if [ -d "$d" ]; then
    echo -e "private-key-file=$d/privkey.pem" >> /etc/nghttpx/nghttpx.conf
    echo -e "certificate-file=$d/fullchain.pem" >> /etc/nghttpx/nghttpx.conf
    echo -e "key=$d/privkey.pem" >> /etc/stunnel/stunnel.conf
    echo -e "cert=$d/fullchain.pem" >> /etc/stunnel/stunnel.conf
  fi
done
#sed -i -e 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
exec /usr/bin/supervisord --nodaemon