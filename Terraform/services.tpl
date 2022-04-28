[Unit]
Description=Locust Service
Requires=network.target
After=network.target

[Service]
Type=simple
User=ec2-user

%{ for masterIp in master ~}
ExecStart=/bin/sh -c '/usr/local/bin/locust -P 8080 -f /home/ec2-user/project/main.py --worker --master-host=${masterIp}'
%{ endfor ~}
[Install]
WantedBy=multi-user.target

