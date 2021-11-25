```
mkdir -p ./session && docker run -ti --rm --mount type=bind,source=$(pwd)/session,destination=/session -p 3737:8080  --privileged septimalmind/browservice:latest
```
