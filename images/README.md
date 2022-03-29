```bash

# unityhub://2021.2.17f1/efb8f635e7b1

sudo docker rmi dockerunity:v0

sudo docker build \
--build-arg http_proxy=http://192.168.73.39:1080 \
--build-arg https_proxy=http://192.168.73.39:1080 \
--build-arg HTTP_PROXY=http://192.168.73.39:1080 \
--build-arg HTTPS_PROXY=http://192.168.73.39:1080 \
--build_arg u3d_version=2021.2.17f1 \
--build_arg u3d_change_set=efb8f635e7b1 \
-t dockerunity:v0 .

sudo docker-compose run --rm dockerunity bash

```
