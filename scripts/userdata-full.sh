#!/bin/bash
# Step 1: Install nginx (https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-22-04)
echo "Step 1: Updating and installing Nginx"
sudo apt update
sudo apt install nginx --yes
echo "Step 1: Done"

# Step 2: Set up directories and permissions
echo "Step 2: Set up directories and permissions"
WWWDIR=/var/www/sanctuarium
sudo mkdir -p $WWWDIR/html
sudo chown -R $USER:$USER $WWWDIR/html
sudo chmod -R 755 $WWWDIR
echo "Step 2: Done"

# Step 3: Add static HTML.
echo "Step 3: Add static HTML"
sudo tee $WWWDIR/html/index.html <<- EOF >/dev/null
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sanctuarium</title>
</head>

<body>
    <h1>Coming Soon!</h1>
</body>

</html>
EOF
echo "Step 3: Done"

# Step 4: Set up server block
echo "Step 4: Set up server block"
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
echo "Step 4: Done"


# Step 5: Restart Nginx
echo "Step 5: Restart Nginx"
sudo systemctl restart nginx
echo "Step 5: Done"