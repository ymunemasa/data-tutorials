Welcome to HDF Tutorials

[Hortonworksが提供しているチュートリアル](https://github.com/hortonworks/data-tutorials)を行うために、「Hortonworks Data Platform (HDP)」と「Hortonworks DataFlow (HDF)」が入ったビッグデータ分析基盤テスト用の環境を構築します。一つのインスタンスに全てのサービスをインストールしますので、パフォーマンステストには向きませんが、インストールから試したいという方は参考にしてください。
Azureや、Docker, VMwware, Virutal Boxでは、Sandboxというあらかじめ全て設定済みの環境がありますが、今回は素の仮想インスタンス上に一から構築してみます。
今回は、IBMとHortonworksとの提携も発表されたことなので、Bluemix Infrastructure上に作成してみたいと思います。ただし、どのクラウド、オンプレミスサーバー、仮想マシン上でも同様に構築できると思います。

IBMとHortonworksとの提携

- [Hortonworksとの協業にみる、IBMの製品戦略の大きな変化](https://enterprisezine.jp/dbonline/detail/9769)
- [日本IBMとホートンワークス、データ分析プラットフォーム製品を両社で再販](http://ascii.jp/elem/000/001/543/1543262/)
- [IBM & Hortonworks、Facebook & Microsoft - 加速するAI業界再編の動き](http://it.impressbm.co.jp/articles/-/14979)

日本語化されているチュートリアル

- [Hadoop Tutorial – Getting Started with HDP](https://github.com/hortonworksjp/hdp-tutorials-ja)
- [HDFハンズオン: NiFi, Kafka, Stormを組み合わせて利用する]
(https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/HDF%E3%83%8F%E3%83%B3%E3%82%BA%E3%82%AA%E3%83%B3-0:-NiFi,-Kafka,-Storm%E3%82%92%E7%B5%84%E3%81%BF%E5%90%88%E3%82%8F%E3%81%9B%E3%81%A6%E5%88%A9%E7%94%A8%E3%81%99%E3%82%8B)
- [NiFi, SAM, Schema Registry, Supersetでリアルタイムイベントプロセッシング](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0.2h)


# Bluemix でインスタンスのオーダー
[Bluemix Infrastructure ポータル](https://control.softlayer.com/)から、下記のスペックを選択し、一番下にある[Add to Order]をクリック

- Data Center: TOK02
- Flavor: Memory 4 X 2.0 GHz Cores x 32GB x 100GB (SAN)
- OS: CentOS 7.x Minimal Install (64 bit)

## FQDNの登録（Local PCで作業）
今回は、毎回、IPアドレスを入力するのが面倒なので、Local PCに登録しました。

```
sudo sh -c "echo '<作成されたインスタンスのIPアドレス> <FQDN>' >> /private/etc/hosts"
(例: 161.111.11.11)
(例: hdp1.handson.jp)
```

# Ambari Serverのインストール

- Terminal / SSH Clientから、作成されたインスタンスにSSH接続 （例: ssh root@161.111.11.11)

```
[root@hdp1 ~]# passwd
Changing password for user root.
New password: <new password>
Retype new password: <new password>
passwd: all authentication tokens updated successfully.
[root@hdp1 ~]# setenforce 0
[root@hdp1 ~]# wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.2.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
[root@hdp1 ~]# yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel
[root@hdp1 ~]# yum -y install ambari-server
[root@hdp1 ~]# ambari-server setup -s --java-home=/usr/lib/jvm/jre/
[root@hdp1 ~]# ambari-server start
```

# Ambari Agentのインストール
```
[root@hdp1 ~]# yum -y install ambari-agent
[root@hdp1 ~]# cat /etc/ambari-agent/conf/ambari-agent.ini |sed 's/localhost/hdp1.handson.jp/g' > /etc/ambari-agent/conf/ambari-agent.ini.new 
（hdp<参加者番号> 例: hdp1, hdp2, hdp3..)

[root@hdp1 ~]# mv -f /etc/ambari-agent/conf/ambari-agent.ini.new /etc/ambari-agent/conf/ambari-agent.ini
[root@hdp1 ~]# ambari-agent start
[root@hdp1 ~]# ln -s /usr/bin/jps /usr/lib/jvm/jre//bin/jps
[root@hdp1 ~]# ln -s /usr/bin/jar /usr/lib/jvm/jre/bin/jar
[root@hdp1 ~]# yum -y install ntp
[root@hdp1 ~]# systemctl enable ntpd
[root@hdp1 ~]# service ntpd start
```

# HDF Management Pack のインストール
```
[root@hdp1 ~]# ambari-server stop
[root@hdp1 ~]# wget http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.0.0.0/tars/hdf_ambari_mp/hdf-ambari-mpack-3.0.0.0-453.tar.gz
[root@hdp1 ~]# mv hdf-ambari-mpack-3.0.0.0-453.tar.gz /tmp
[root@hdp1 ~]# cd /tmp
[root@hdp1 ~]# ambari-server install-mpack --mpack=/tmp/hdf-ambari-mpack-3.0.0.0-453.tar.gz --verbose
[root@hdp1 ~]# ambari-server start
[root@hdp1 ~]# 
```

# Amabari UIでの設定 (HDP)

- http://hdp1.handson.jp:8080 にアクセス （インスタンスのFQDN名） user/passwd: `admin`/`admin`
- Lanunch Install Wizard
<img width="1280" alt="2017-09-18-10.11.08.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/90173253-8774-d620-59e7-8035fcff3470.jpeg">

- Cluster名の決定
<img width="1280" alt=" 2017-09-18 14.49.51.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/19da4d2d-4e0b-2ae1-6d87-6ae87c790fdd.jpeg">

- HDP2.6を選択
<img width="1280" alt="2017-09-18-10.24.48.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/104b2fc8-2d11-90c8-d062-28474404e0a2.jpeg">

- ホスト名を入力し、Manual Registrationを選択
<img width="1280" alt="2017-09-18-10.25.19.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/d45d2748-e805-6928-2cc7-c6d765c32d81.jpeg">

- 必要なサービスを選択


| チュートリアル | 選択するサービス| 
|--------------|---------------|
| HDP系チュートリアル  | HDFS, YARN + MapReduce, Tez, Hive, Pig, ZooKeeper, Ambari Metrics, SmartSence, Spark2, Zeppelin Notebook, Slider        |
| HDF系チュートリアル  | HDFS, YARN + MapReduce, ZooKeeper, Ambari Metrics, SmartSence, NiFi, Storm, Kafka, Spark2, Zeppelin Notebook        |


- （Spark2を選択した場合）Spark2 Thrift, Livy, Clientをチェック
<img width="1280" alt="2017-09-18-10.58.21.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/9f9975e6-78af-d941-e9c4-009e997f4b6e.jpeg">

- 問題のある所を確認、修正
<img width="1280" alt="2017-09-18-10.59.36.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/1f97d5f3-4425-64dc-deef-993e2d31b7b5.jpeg">

- 設定項目のレビュー後、Deploy
<img width="1280" alt=" 2017-09-18 15.02.42.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/f6844974-ff9e-cda4-6ccf-43ba93ec6cdf.jpeg">

- インストールが完了すれば、Next
<img width="1280" alt=" 2017-09-18 15.02.55.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/a074bbb3-f48b-5248-18e0-d8b8ac065501.jpeg">

## NiFiのプロセスは正常に起動しているが、Webに接続できない場合の対処
NICが2枚ささっていて、NiFiのプロセスが内部IPアドレスを参照してしまっている場合があります。この場合、明示的に、`nifi.web.http.host` で外部IPアドレスを指定し、NiFiのサービスをAmbariから再起動。

```
[root@hdp1 ~]# netstat -antu | grep LISTEN
tcp6       0      0 :::9995                 :::*                    LISTEN     
tcp6       0      0 127.0.0.1:9995          :::*                    LISTEN 
```

<img width="995" alt=" 2017-09-19 9.05.43.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/e63e0137-4964-1951-e1c2-e1b2b7c9e06d.jpeg">

# Tezの設定をチューニング
AmbariダッシュボードからTez、Configにて、```tez.session.am.dag.submit.timeout.secs``` を600から60に変更

#　Storm UIを追加
Stormを利用する場合は、Storm UIを追加しておきましょう。

 - Manage Ambariをクリック
<img width="1280" alt=" 2017-09-18 23.56.38.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/29ecf823-8da8-71b1-1b62-6399f591e830.jpeg">

 - Viewsをクリックし、Storm_Monitoringを選択
<img width="1280" alt=" 2017-09-18 23.56.46.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/6268f652-fc93-1fe0-2e47-568c2b77256e.jpeg">

 - 必要項目を設定し、Save
<img width="1280" alt=" 2017-09-18 23.57.22.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/a84cb217-2303-3b57-7424-c76780ae51e8.jpeg">

 - 追加されたViewをクリック
<img width="1280" alt=" 2017-09-18 23.57.29.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/aa977510-aba8-a960-0534-88a37ae5ee08.jpeg">

 - StormのUIを確認できる
<img width="1280" alt=" 2017-09-18 23.57.39.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/b29623c8-c7f6-57a9-9042-0cc38e6fa9d0.jpeg">

# adminで、HDFS上に、ディレクトリ、ファイルを作成するようにする
[Hadoop Tutorial – Getting Started with HDP](https://github.com/hortonworksjp/hdp-tutorials-ja) で、データをアップロードする箇所があるので、adminで作業するために設定しておきましょう。

```
[root@hdp1 ~]# sudo su - hdfs
Last login: Sun Sep 17 21:20:14 CDT 2017
[hdfs@hdp1 ~]$ hdfs dfs -mkdir /user/admin
[hdfs@hdp1 ~]$ hdfs dfs -chown admin:hadoop /user/admin
```

それでは、[Hortonworks チュートリアル](https://github.com/hortonworks/data-tutorials)の旅にでましょう。


---
# 補足情報

## 再起動時の対応
再起動後、`ambari-agent`が起動されていることを確認し、サービス一覧の`Action`から`Start All`をクリックすると、サービスが起動されます。
![ss 2017-09-20 8.35.15.png](https://qiita-image-store.s3.amazonaws.com/0/42406/4839fdd8-c2e3-9da1-be17-7d66fcc2614a.png)

## SecondaryNameNodeの起動ができない場合
再起動したときに、下記のようなログが出力され、SeondayNameNodeの起動に失敗することがあります。一つの理由として、Ambari Agentが正常に起動してない可能性があります。`ambari-agent restart` 後、`ambari-server restart`で試してみてください。

```
FATAL namenode.SecondaryNameNode (SecondaryNameNode.java:main(683)) - Failed to start secondary namenode
java.net.BindException: Port in use: hdp.handson.jp:50090
```

## サービスの自動起動の設定
インスタンスを再起動したあとに、サービスを自動起動するように設定しておくと便利でしょう。
<img width="1280" alt=" 2017-09-19 10.53.44.jpg" src="https://qiita-image-store.s3.amazonaws.com/0/42406/6a1e3e32-9f66-ac26-445b-a3d96a83ef31.jpeg">

## SAM, Schema Registry, Druid, Supersetのインストール、設定
SAM, Schema Registry, Druid, Superset は、databaseの作成を行う必要があります。時間のあるときにここにも記載するつもりですが、それまで必要な場合は、[Installing HDF Services on an Existing HDP Cluster](https://docs.hortonworks.com/HDPDocuments/HDF3/HDF-3.0.0/bk_installing-hdf-on-hdp/content/ch_install-databases.html)を参照ください。

## IBM Data Science Experience を使った分析
時間のあるときにも試してみたいと思います。


