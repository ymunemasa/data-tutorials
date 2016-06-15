#!/bin/bash
export HDF_ZIP=$1
export HOST=$2
export PORT=$3
export VERSION=$4
export HDF=HDF-$VERSION
export HDF_FILE=$(basename $HDF_ZIP)

echo "HOST: $HOST"
echo "PORT: $PORT"
echo "HDF_FILE: $HDF_ZIP"
echo "Version: $VERSION"
echo "HDF-Version: $HDF"
echo "HDF-Filename: $HDF_FILE"

echo 'PLEASE ENTER THE PASSWORD TO MOVE HDF TO SANDBOX'
scp -P $PORT $HDF_ZIP root@$HOST:/root

echo 'PLEASE ENTER THE PASSWORD TO INSTALL HDF TO SANDBOX'
ssh root@$HOST -p $PORT <<ENDSSH

export VERSION=$4
export HDF2=HDF-$4

echo 'Installing NiFi....'

mkdir hdf
mv $HDF_FILE ./hdf
cd hdf
echo 'Extracting Archive'
tar -xvf $HDF_FILE > /dev/null
chown -R root:root \$HDF2
cd \$HDF2/nifi

echo 'Updating Run Configs'
sed -i s/nifi.web.http.port=8080/nifi.web.http.port=6434/g conf/nifi.properties
echo "NiFi is now installed on Sandbox at /root/hdf/\$HDF2/nifi"
echo "Run NiFi on the sandbox with the command \"/root/hdf/\$HDF2/nifi/bin/nifi.sh start\""
ENDSSH
