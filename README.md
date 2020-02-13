# XLink-Kai-Evolution in Docker optimized for Unraid
This Docker will download and install XLink Kai: Evolution.

XLink Kai: Evolution VII lets you connect with other console users around the world, and play online games for free. XLink Kai: Evo VII tricks your console into thinking that the other users it is connecting to over the Internet, are actually part of a Local Area Network. This is the basis of system-link gaming, where friends would gather around in the same house and play over 2 or more consoles. With XLink Kai: Evo VII, you now have the option to test your skills out with anybody in the world. As for the technical aspects of tunnelling network packets, we won't bore you with that...

Please note that you need an XLink Kai: Evolution XTag (XLink Kai Gamertag) you can register it here: https://www.teamxlink.co.uk/?go=register

UPDATE NOTICE: The container will check on every start/restart if there is a newer version of XLink Kai: Evolution and update it.

Please also check out the website of XLink Kai Evolution: https://www.teamxlink.co.uk/ huge thanks go to CrunchBite!


## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for XLink Kai: Evolution | /xlinkkaievolution |
| INTERFACE_NAME | The interfacename on wich XLink Kai: Evolution should run | eth0 |
| UMASK | The UMASK for newly created files | 000 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |


>**NOTE** This Docker must be started with the follwoing parameter "--privileged=true", "--cap-add=NET_ADMIN" and "--network='host'".

## Run example
```
docker run --name XLink-Kai-Evolution -d \
    -p 34522:34522 \
    --env 'INTERFACE_NAME=eth0' \
    --env 'UMASK=000' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /mnt/user/appdata/xlinkkaievolution:/xlinkkaievolution \
    --privileged=true \
    --cap-add NET_ADMIN \
    --network='host' \
    --restart=unless-stopped \
    ich777/xlinkkaievolution
```

### Webgui address: http://[SERVERIP]:[PORT]/



#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/