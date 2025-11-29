#!/bin/bash

APP_NAME="mywebapp"
APP_DIR="/var/www/${APP_NAME}"
SERVICE_FILE="/etc/systemd/system/${APP_NAME}.service"
NGINX_CONF="/etc/nginx/sites-available/${APP_NAME}"
NGINX_LINK="/etc/nginx/sites-enabled/${APP_NAME}"
SOURCE_DIR="$(pwd)/app"

echo "========== Starting Deployment =========="

# 1) Install nginx if not installed
if ! command -v nginx >/dev/null 2>&1; then
    echo "[INFO] Installing nginx..."
    sudo apt update
    sudo apt install -y nginx
else
    echo "[OK] Nginx already installed."
fi

# 2) Copy app files
echo "[INFO] Copying app files..."
sudo mkdir -p $APP_DIR
sudo cp -r $SOURCE_DIR/* $APP_DIR/
sudo chown -R www-data:www-data $APP_DIR

# 3) Create systemd service
echo "[INFO] Creating systemd service..."
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=My Web App Service
After=network.target

[Service]
Type=simple
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/python3 -m http.server 8000
Restart=always
User=www-data

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl enable $APP_NAME
sudo systemctl restart $APP_NAME

# 4) Configure Nginx reverse proxy
echo "[INFO] Configuring nginx..."
sudo bash -c "cat > $NGINX_CONF" <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
    }
}
EOF

sudo ln -sf $NGINX_CONF $NGINX_LINK
sudo nginx -t
sudo systemctl restart nginx

echo "========== Deployment Finished =========="
echo "Visit: http://YOUR_SERVER_IP/"
