
# Crypto
### A crypto wallet iOS app


## How to run server for log-in purpose

```bash
> cd Crypto/

> npm init

> npm install

> node cryptoServer.js 
#Server running at http://localhost:8080
```

## Establish tunnel for server endpoint
``` bash
> ngrok http 8080

Session Status                online
Session Expires               7 hours, 59 minutes
Version                       2.3.35
Region                        United States (us)
Web Interface                 http://127.0.0.1:4040
Forwarding                    http://3228d7af.ngrok.io -> http://localhost:8080
Forwarding                    https://3228d7af.ngrok.io -> http://localhost:8080

Connections                   ttl     opn     rt1     rt5     p50     p90
                              3       0       0.04    0.01    5.01    5.01
```

## Steps to follow after establishing tunnel
After you see the output from ngrok in above step, 

1. Copy the forwarding url ( eg: https://3228d7af.ngrok.io) and 
  paste it into LoginView.swift file as URL on line no. 20

2. Launch the app in simulator

3. Input the credentials 
 (username = admin, password = admin )

4. Click login button, you can see the crypto wallet


## Preview

<img src="./Screen_Shot_1.png" width="300" height="650">

<img src="./Screen_Shot_2.png" width="300" height="650">

<img src="./Screen_Shot_3.png" width="300" height="650">