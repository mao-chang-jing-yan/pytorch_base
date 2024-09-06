#docker rm -f pytorch_base_container
#docker save -o pre_image.tar pytorch_base
#docker rmi pytorch_base


#docker build -t pytorch_base --no-cache .





# --gpus all \

docker pull ghcr.io/mao-chang-jing-yan/pytorch_base/pytorch_base
if [ "$1" = "with_gpu" ]; then
    docker run -it -d --name pytorch_base_container --gpus all --workdir /app \
    -p 12345:8888 \
    -p 10022:22 \
    -v $(pwd)/projects:/app/projects \
    -v $(pwd)/pyprojects:/app/pyprojects \
    --restart always \
    ghcr.io/mao-chang-jing-yan/pytorch_base/pytorch_base

else
   docker run -it -d --name pytorch_base_container --workdir /app \
    -p 12345:8888 \
    -p 10022:22 \
    -v $(pwd)/projects:/app/projects \
    -v $(pwd)/pyprojects:/app/pyprojects \
    --restart always \
    ghcr.io/mao-chang-jing-yan/pytorch_base/pytorch_base
fi