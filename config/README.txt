Place the flaskapp.service file at /etc/systemd/system/myflaskapp.service


Place the myflaskapp file at /etc/nginx/sites-available/myflaskapp


sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl start myflaskapp
sudo systemctl enable myflaskapp



