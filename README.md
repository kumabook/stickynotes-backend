# Sticky Notes Backend

[![Build Status](https://travis-ci.org/kumabook/stickynotes-backend.svg?branch=master)](https://travis-ci.org/kumabook/stickynotes-backend)
[![Coverage Status](https://coveralls.io/repos/github/kumabook/stickynotes-backend/badge.svg?branch=master)](https://coveralls.io/github/kumabook/stickynotes-backend?branch=master)

This is Sticky Notes app's backend project.

The backend provides data storage, data sync,
and user management for Sticky Notes apps.


## Self Host with Docker


You can try the backend server with docker and launch an instance with a postgres database like this:
```
git clone https://github.com/kumabook/stickynotes-backend.git
sudo docker-compose up
```

Here is an example of reverse proxy configuration

cat /etc/nginx/sites-enabled/stickynotes.conf
```
server {
   listen 443 ssl;
   listen [::]:443 ssl http2;
   server_name my.stickynotes.com;
   location / {
       proxy_pass         http://127.0.0.1:3000/;
       proxy_set_header   Host $host;
       proxy_set_header   X-Real-IP $remote_addr;
       proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
       proxy_set_header   X-Forwarded-Proto $scheme;
   }
}
```
