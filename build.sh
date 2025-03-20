rm -R dnd_flutter/
rm -R dnd_java/
git clone https://github.com/XfableX/dnd_flutter.git
git clone https://github.com/XfableX/dnd_java.git
chmod -R 777 dnd_flutter
chmod -R 777 dnd_java
cd dnd_java
./gradlew build
cd ..
cd dnd_flutter
IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
docker run --rm -it -v ${PWD}:/dnd_flutter --workdir /dnd_flutter ghcr.io/cirruslabs/flutter:stable flutter build web --dart-define=WEBHOST=$IP
cd ..
echo "Running on http://$IP:80"
docker compose up --detach
