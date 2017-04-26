#!/bin/bash
USERNAME=maria_dev
PASSWORD=maria_dev
user_exists=$(id -u $USERNAME > /dev/null 2>&1; echo $?)
if [ $user_exists -eq 1 ]; then
sudo useradd $USERNAME
#read -s -p "Enter password : " PASSWORD
echo $USERNAME:$PASSWORD | sudo chpasswd
sudo -u hdfs hdfs dfs -mkdir /user/maria_dev
sudo -u hdfs hdfs dfs -chown -R maria_dev:hdfs /user/maria_dev
AMBARI_HOST=$(hostname -f)
CLUSTER_NAME=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/clusters |grep cluster_name|grep -Po ': "(.+)'|grep -Po '[a-zA-Z0-9\-_!?.]+')
echo "Assigning user to a Sandbox role Service Operator"
curl -iv -u admin:admin -H "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"SERVICE.OPERATOR", "principal_name":"maria_dev","principal_type":"USER"}}]' http://$AMBARI_HOST:8080/api/v1/clusters/$CLUSTER_NAME/privileges
echo "Assigning the user to a group in ambari"
curl -iv -u admin:admin -H "X-Requested-By: ambari"-X POST -d '[{"MemberInfo/user_name":"maria_dev","MemberInfo/group_name":"views"}]' http://$AMBARI_HOST:8080/api/v1/groups/views/members
#echo "Assigning Ambari Views"
#curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"maria_dev","principal_type":"USER"}}]' http://$AMBARI_HOST:8080/api/v1/views/HIVE/versions/1.5.0/instances/AUTO_HIVE_INSTANCE/privileges/

#Get Pig view versions
pig_version=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/PIG/versions | jq -r '.items[].ViewVersionInfo.version')
#Get Pig View instance name
pig_instance_name=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/PIG/versions/$pig_version/instances | jq -r '.items[].ViewInstanceInfo.instance_name')
#Assigning maria_dev to use Pig view
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"maria_dev","principal_type":"USER"}}]' http://$AMBARI_HOST:8080/api/v1/views/PIG/versions/$pig_version/instances/$pig_instance_name/privileges/

#Get Hive view versions
array_hive_version=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/HIVE/versions | jq -r '.items[].ViewVersionInfo.version')
hive_ver=( $array_hive_version )
hive_version=${hive_ver[1]}
#Get Hive View instance name
hive_instance_name=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/HIVE/versions/$hive_version/instances | jq -r '.items[].ViewInstanceInfo.instance_name')
#Assigning maria_dev to use Hive view
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"maria_dev","principal_type":"USER"}}]' http://$AMBARI_HOST:8080/api/v1/views/HIVE/versions/$hive_version/instances/$hive_instance_name/privileges/

#Get Zeppelin view versions
zeppelin_version=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/ZEPPELIN/versions | jq -r '.items[].ViewVersionInfo.version')
#Get Zeppelin View instance name
zeppelin_instance_name=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/ZEPPELIN/versions/$zeppelin_version/instances | jq -r '.items[].ViewInstanceInfo.instance_name')
#Assigning maria_dev to use Zeppelin view
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"maria_dev","principal_type":"USER"}}]' http://$AMBARI_HOST:8080/api/v1/views/ZEPPELIN/versions/$zeppelin_version/instances/$zeppelin_instance_name/privileges/

#Get Files view versions
files_version=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/FILES/versions | jq -r '.items[].ViewVersionInfo.version')
#Get Files View instance name
files_instance_name=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/FILES/versions/$files_version/instances | jq -r '.items[].ViewInstanceInfo.instance_name')
#Assigning maria_dev to use Files view
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"maria_dev","principal_type":"USER"}}]' http://$AMBARI_HOST:8080/api/v1/views/FILES/versions/$files_version/instances/$files_instance_name/privileges/

#Get Tez view versions
tez_version=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/TEZ/versions | jq -r '.items[].ViewVersionInfo.version')
#Get Tez View instance name
tez_instance_name=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/TEZ/versions/$tez_version/instances | jq -r '.items[].ViewInstanceInfo.instance_name')
#Assigning maria_dev to use Tez view
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"maria_dev","principal_type":"USER"}}]' http://$AMBARI_HOST:8080/api/v1/views/TEZ/versions/$tez_version/instances/$tez_instance_name/privileges/

#Get Storm view versions
storm_version=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/Storm_Monitoring/versions | jq -r '.items[].ViewVersionInfo.version')
#Get Storm View instance name
storm_instance_name=$(curl -u admin:admin -X GET http://$AMBARI_HOST:8080/api/v1/views/Storm_Monitoring/versions/$storm_version/instances | jq -r '.items[].ViewInstanceInfo.instance_name')
#Assigning maria_dev to use Storm view
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"maria_dev","principal_type":"USER"}}]' http://$AMBARI_HOST:8080/api/v1/views/Storm_Monitoring/versions/$tez_version/instances/$storm_instance_name/privileges/
sleep 15
else 
echo "$USERNAME already exists"
fi	








