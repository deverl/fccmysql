



rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install flask gunicorn



Install these packages with pip


Package                Version
---------------------- ------------
blinker                1.9.0
click                  8.1.8
Flask                  3.1.0
gunicorn               23.0.0
itsdangerous           2.2.0
Jinja2                 3.1.6
MarkupSafe             3.0.2
mysql-connector-python 9.2.0
packaging              24.2
pip                    24.2
PyMySQL                1.1.1
PyYAML                 6.0.2
ua-parser              1.0.1
ua-parser-builtins     0.18.0.post1
user-agents            2.2.0
Werkzeug               3.1.3



Place the flaskapp.service file at /etc/systemd/system/myflaskapp.service


Place the myflaskapp file at /etc/nginx/sites-available/myflaskapp


sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl start myflaskapp
sudo systemctl enable myflaskapp



