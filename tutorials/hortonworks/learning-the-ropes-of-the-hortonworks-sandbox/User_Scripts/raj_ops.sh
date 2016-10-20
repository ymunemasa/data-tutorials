#!/bin/bash
USERNAME=raj_ops
PASSWORD=raj_ops
user_exists=$(id -u $USERNAME > /dev/null 2>&1; echo $?)
if [ $user_exists -eq 1 ]; then
useradd $USERNAME
echo $USERNAME:$PASSWORD | chpasswd
egrep "^$USERNAME" /etc/passwd >/dev/null
echo "Creating a HDFS directory"
sudo -u hdfs hdfs dfs -mkdir /user/raj_ops
sudo -u hdfs hdfs dfs -chown -R raj_ops:hdfs /user/raj_ops
echo "Creating a user in ambari"
curl -iv -u admin:admin -H "X-Requested-By: ambari" -X POST -d '{"Users/user_name":"raj_ops","Users/password":"raj_ops","Users/active":"true","Users/admin":"false"}' http://sandbox.hortonworks.com:8080/api/v1/users
echo "Assigning the user to a group in ambari"
curl -iv -u admin:admin -H "X-Requested-By: ambari"-X POST -d '[{"MemberInfo/user_name":"raj_ops","MemberInfo/group_name":"views"}]' http://sandbox.hortonworks.com:8080/api/v1/groups/views/members
echo "Assigning user to a Sandbox role Cluster Administrator"
curl -iv -u admin:admin -H "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"CLUSTER.ADMINISTRATOR", "principal_name":"raj_ops","principal_type":"USER"}}]' http://sandbox.hortonworks.com:8080/api/v1/clusters/Sandbox/privileges
echo "Assigning Ambari Views"
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"raj_ops","principal_type":"USER"}}]' http://127.0.0.1:8080/api/v1/views/HIVE/versions/1.5.0/instances/AUTO_HIVE_INSTANCE/privileges/
#Pig view
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"raj_ops","principal_type":"USER"}}]' http://127.0.0.1:8080/api/v1/views/PIG/versions/1.0.0/instances/PIG_INSTANCE/privileges/
#Files view
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"raj_ops","principal_type":"USER"}}]' http://127.0.0.1:8080/api/v1/views/FILES/versions/1.0.0/instances/AUTO_FILES_INSTANCE/privileges/
#Zeppelin view
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"raj_ops","principal_type":"USER"}}]' http://127.0.0.1:8080/api/v1/views/ZEPPELIN/versions/1.0.0/instances/AUTO_ZEPPELIN_INSTANCE/privileges/
#YARN Queue Manager
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"raj_ops","principal_type":"USER"}}]' http://127.0.0.1:8080/api/v1/views/CAPACITY-SCHEDULER/versions/1.0.0/instances/AUTO_CS_INSTANCE/privileges/
#Tez View
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"raj_ops","principal_type":"USER"}}]' http://127.0.0.1:8080/api/v1/views/TEZ/versions/0.7.0.2.5.0.0-1225/instances/TEZ_CLUSTER_INSTANCE/privileges/
#Storm View
curl -iv -u admin:admin -H  "X-Requested-By: ambari" -X POST -d '[{"PrivilegeInfo":{"permission_name":"VIEW.USER", "principal_name":"raj_ops","principal_type":"USER"}}]' http://127.0.0.1:8080/api/v1/views/Storm_Monitoring/versions/0.1.0/instances/Storm_View/privileges/
else 
echo "$USERNAME already exists"
fi	
