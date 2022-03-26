```bash

sudo docker rmi dockerunity:v0

sudo docker build \
--build-arg http_proxy=http://192.168.73.39:1080 \
--build-arg https_proxy=http://192.168.73.39:1080 \
-t dockerunity:v0 .

sudo docker-compose run --rm dockerunity bash

# unityhub://2021.2.17f1/efb8f635e7b1

```
