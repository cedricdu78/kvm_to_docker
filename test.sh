set -e -u -x

TAG=$1

echo create tar
cd bionic/ && tar -czf ../bionic.tar.gz . && cd ..
cd focal/ && tar -czf ../focal.tar.gz . && cd ..
cd jammy/ && tar -czf ../jammy.tar.gz . && cd ..
cd noble/ && tar -czf ../noble.tar.gz . && cd ..

echo import to docker
cat ./noble.tar.gz | docker import -c "EXPOSE 22" - noble-qcow2:$TAG
cat ./jammy.tar.gz | docker import -c "EXPOSE 22" - jammy-qcow2:$TAG
cat ./focal.tar.gz | docker import -c "EXPOSE 22" - focal-qcow2:$TAG
cat ./bionic.tar.gz | docker import -c "EXPOSE 22" - bionic-qcow2:$TAG

rm *.gz
