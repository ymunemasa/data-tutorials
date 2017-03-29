cd /opt/
mkdir java
cd java
echo "Downloading jdk 1.8 version"
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.tar.gz"
tar -xvzf jdk-*-linux-x64.tar.gz
echo "Installing new version of jdk"
alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_101/bin/java 2
alternatives --install /usr/bin/javac javac /opt/java/jdk1.8.0_101/bin/javac 2
echo "Changing the configs of Nifi to use this jdk"
lineNumber=$(grep -n 'locateJava() {' /root/HDF-2.0.0.0/nifi/bin/nifi.sh  | sed 's/^\([0-9]\+\):.*$/\1/')
CONTENT="JAVAHOME=/opt/java/jdk1.8.0_101/"
sed -i "${lineNumber} a $CONTENT" /root/HDF-*/nifi/bin/nifi.sh
lastLineNumber=$(grep -n 'all command features' /root/HDF-2.0.0.0/nifi/bin/nifi.sh | sed 's/^\([0-9]\+\):.*$/\1/')
sed -i "$lineNumber,$lastLineNumber{s/JAVA_HOME/JAVAHOME/g}" /root/HDF-*/nifi/bin/nifi.sh
bootstrapLineNumber=$(grep -n 'java=java' /root/HDF-2.0.0.0/nifi/conf/bootstrap.conf  | sed 's/^\([0-9]\+\):.*$/\1/')
sed -i "$bootstrapLineNumber s/^/#/" /root/HDF-*/nifi/conf/bootstrap.conf
CONTENT_BOOTSTRAP="java=/opt/java/jdk1.8.0_101/bin/java"
sed -i "${bootstrapLineNumber} a $CONTENT_BOOTSTRAP" /root/HDF-2.0.0.0/nifi/conf/bootstrap.conf
