#!/bin/bash
echo "Set up server block: START"
WWWDIR=/var/www/sanctuarium
PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
SITES_AVAILABLE=/etc/nginx/sites-available
SITES_ENABLED=/etc/nginx/sites-enabled
sudo tee $SITES_AVAILABLE/sanctuarium <<- EOF >/dev/null
server {
        listen 80;
        listen [::]:80;

        root $WWWDIR/html;
        index index.html index.htm index.nginx-debian.html;

        server_name $PUBLIC_IP;

        location / {
            try_files \$uri \$uri/ =404;
        }
}
EOF
sudo ln -sfn $SITES_AVAILABLE/sanctuarium $SITES_ENABLED
echo "Set up server block: DONE"

echo "Restart Nginx: START"
sudo systemctl restart nginx
echo "Restart Nginx: DONE"