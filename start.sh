docker run -d -t -i \
    -p 25565:25565 \
    -e EULA=TRUE \
    -v "$(pwd)/data:/data" \
    --name mc \
    minecraft-server

