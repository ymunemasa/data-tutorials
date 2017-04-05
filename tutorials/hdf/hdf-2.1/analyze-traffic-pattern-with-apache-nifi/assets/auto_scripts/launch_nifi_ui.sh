#!/bin/bash
./docker_sandbox_hdf.sh
#Access NiFi HTML UI via Mac CLI
echo "Launch NiFi HTML UI..."
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --kiosk http://sandbox.hortonworks.com:19090/nifi/
