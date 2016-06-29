# point domain name to IP address
# if on mac or linux, execute the following command

echo '{Host-Name} sandbox.hortonworks.com' | sudo tee -a /private/etc/hosts

# if on windows, execute the following command

echo '{Host-Name} sandbox.hortonworks.com' | tee -a /c/Windows/System32/Drivers/etc/hosts

# Download and Setup Truck Events Stream Simulator

# SSH into sandbox
ssh root@127.0.0.1 -p 2222

cd ~
git clone https://github.com/james94/iot-truck-streaming

#install maven
./iot-truck-streaming/setup/bin/install_maven.sh
