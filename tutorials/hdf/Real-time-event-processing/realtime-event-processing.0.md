# NiFi, SAM, Schema Registry, Supersetでリアルタイムプロセッシング
原文: [REAL-TIME EVENT PROCESSING IN NIFI, SAM, SCHEMA REGISTRY AND SUPERSET](https://hortonworks.com/tutorial/real-time-event-processing-in-nifi-sam-schema-registry-and-superset/)

> このチュートリアルは、MacおよびLinux OSユーザー向けです。

## はじめに
このチュートリアルでは、視覚的なキャンバスでStream Analytics Manager（SAM）のトポロジを構築する方法を学びます。Schema Registryにスキーマを作成し、SAMとNiFiがフローにデータを引き込むために使用します。SAMトポロジがデプロイされたら、Druid上で実行されるSuperSetを使用していろいろな可視化スライスを作成する方法を学びます。

## 事前準備
- [Downloaded HDF 3.0 Sandbox](https://jp.hortonworks.com/downloads/#sandbox)
- [Deployed and Installed HDF 3.0 Sandbox](https://jp.hortonworks.com/tutorial/sandbox-deployment-and-install-guide/)

1. ローカルマシンで`/private/etc/hosts`に`sandbox-hdf.hortonworks.com`を追加します。

```
127.0.0.1   localhost   sandbox-hdf.hortonworks.com
```

2. SAMのデモの依存関係をローカルマシンにダウンロードします。

```sh
cd ~/Downloads
wget https://github.com/hortonworks/data-tutorials/raw/master/tutorials/hdf/realtime-event-processing-in-nifi-sam-sr-superset/assets/templates.zip
unzip templates.zip
```

このテンプレートフォルダには、NiFiフロー、SAMトポロジ、SAM custom UDF、Schema Registryのスキーマが含まれています。

### SAMのデモを実行するために、HDFのセットアップをする
1. Amberiに`http://sandbox-hdf.hortonworks.com:9080`でアクセスし、`admin / admin`でログインします。
2. 左にあるサイドバーから“Streaming Analytics Manager (SAM)”を選択し、Summaryタブが表示されたら“Service Actions”をクリックします。“Start”ボタンをクリックして“maintenance mode”をオフにします。
3. ホストマシンでターミナルを開き、SSHでHDF sandboxに入ります。“bootstrap-storage.sh drop-create”のコマンドは、SAMのメタデータを格納するためにMySQLのテーブルをリセットします。“bootstrap.sh pulls”コマンドは、SAM（Streamline）のデフォルトコンポーネント、Notifier、UDF、roleを作成します。以下のコマンドを実行します。

```sh
ssh root@localhost -p 12222
cd /usr/hdf/current/streamline
./bootstrap/bootstrap-storage.sh drop-create
./bootstrap/bootstrap.sh
```

4. Ambariダッシュボードの左サイドバーにあるSAM Serviceに移動します。その後、“Configs” -> “Streamline Config”をクリックします。フィルタボックスで“registry.url”を検索し、“registry.url”フィールドに`http://sandbox-hdf.hortonworks.com:17788/api/v1`を入力します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/sam_registry_url-4.png)

設定を保存し、“updated registry.url”と入力します。SAM Serviceを再起動します。

5. Druid Serviceに移動し、“Config”、“Advanced”をクリックしてディレクトリを更新し、検索ボックスに**druid.indexer.logs.directory**と入力します。`/home/druid/logs`で設定を更新します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/druid_indexer_logs_directory-4.png)

6. **druid.storage.storageDirectory**を検索し、`/home/druid/data`で設定を更新します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/druid_storage_storageDirectory-4.png)

両方の設定が更新されたら、設定を保存し、“updated directories, so druid can write to them”を呼びます。

7. 左サイドバーからHDFSを選択し、先ほどのSAMと同じようにサービスを起動します。
8. HDFSを起動したのと同じ方法で、Storm、Ambari Metrics、Kafka、Druid、Registry、Streaming Analytics Manager（SAM）を起動します。

## 概要
- [概念](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#%E6%A6%82%E5%BF%B5)
- [Step 1: Druid ServiceにMAPBox APIキーを追加する](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#step-1-druid-service%E3%81%ABmapbox-api%E3%82%AD%E3%83%BC%E3%82%92%E8%BF%BD%E5%8A%A0%E3%81%99%E3%82%8B)
- [Step 2: Kafkaトラックトピックが作成されていることを確認する](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#step-2-kafka%E3%83%88%E3%83%A9%E3%83%83%E3%82%AF%E3%83%88%E3%83%94%E3%83%83%E3%82%AF%E3%81%8C%E4%BD%9C%E6%88%90%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%82%8B%E3%81%93%E3%81%A8%E3%82%92%E7%A2%BA%E8%AA%8D%E3%81%99%E3%82%8B)
- [Step 3: Schema Registryにトラックスキーマを作成する](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#step-3-schema-registry%E3%81%AB%E3%83%88%E3%83%A9%E3%83%83%E3%82%AF%E3%82%B9%E3%82%AD%E3%83%BC%E3%83%9E%E3%82%92%E4%BD%9C%E6%88%90%E3%81%99%E3%82%8B)
- [Step 4: GeoEnrich Kafka DataにNiFiフローを導入する](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#step-4-geoenrich-kafka-data%E3%81%ABnifi%E3%83%95%E3%83%AD%E3%83%BC%E3%82%92%E5%B0%8E%E5%85%A5%E3%81%99%E3%82%8B)
- [Step 5: Druid SuperSetのためのデータを前処理するためにSAMトポロジをデプロイする](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#step-5-druid-superset%E3%81%AE%E3%81%9F%E3%82%81%E3%81%AE%E3%83%87%E3%83%BC%E3%82%BF%E3%82%92%E5%89%8D%E5%87%A6%E7%90%86%E3%81%99%E3%82%8B%E3%81%9F%E3%82%81%E3%81%ABsam%E3%83%88%E3%83%9D%E3%83%AD%E3%82%B8%E3%82%92%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4%E3%81%99%E3%82%8B)
- [Step 6: アプリケーションでData-Loaderを実行する](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#step-6-%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%A7data-loader%E3%82%92%E5%AE%9F%E8%A1%8C%E3%81%99%E3%82%8B)
- [Step 7: スライスを持つSuperSetダッシュボードを作成する](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#step-7-%E3%82%B9%E3%83%A9%E3%82%A4%E3%82%B9%E3%82%92%E6%8C%81%E3%81%A4superset%E3%83%80%E3%83%83%E3%82%B7%E3%83%A5%E3%83%9C%E3%83%BC%E3%83%89%E3%82%92%E4%BD%9C%E6%88%90%E3%81%99%E3%82%8B)
- [まとめ](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#%E3%81%BE%E3%81%A8%E3%82%81)
- [参考文献](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#%E5%8F%82%E8%80%83%E6%96%87%E7%8C%AE)
- [付録: リアルタイムイベント処理のデモについてのトラブルシューティング](https://github.com/ijokarumawak/hdf-tutorials-ja/wiki/realtime-event-processing.0#%E4%BB%98%E9%8C%B2-%E3%83%AA%E3%82%A2%E3%83%AB%E3%82%BF%E3%82%A4%E3%83%A0%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88%E5%87%A6%E7%90%86%E3%81%AE%E3%83%87%E3%83%A2%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6%E3%81%AE%E3%83%88%E3%83%A9%E3%83%96%E3%83%AB%E3%82%B7%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0)

## 概念
### SuperSet
SuperSetは、視覚的、直観的、対話的なデータ探索プラットフォームです。このプラットフォームは、可視化されたデータセットにて、友人やビジネスクライアントとダッシュボードを迅速に作成して共有する方法を提供します。様々な可視化オプションはデータを分析するために使用し、それについて説明します。Semantic Layerは、データストアをUIに表示する方法を制御することをユーザに許可します。このモデルは安全であり、特定の機能だけが特定のユーザによってアクセスできる複雑なルールをユーザに与えます。SuperSetは、Druidやマルチシステムと互換がある柔軟性を提供している他のデータストア（SQLAlchemy、Python ORMなど）と結合できます。

### Druid
Druidは、データのビジネスインテリジェンスクエリのために開発されたオープンソースの分析データベースです。Druidは、リアルタイムなデータ取り込みを低レイテンシで行い、柔軟なデータ探索と迅速な集約を提供します。デプロイメントは、多数のペタバイトのデータに関連して、何兆ものイベントに達することがよくあります。

### Stream Analytics Manager (SAM)
Stream Analytics Managerは、ストリーム処理開発者が従来の数行のコードを記述するのに比べてわずか数分でデータトポロジを構築できるドラッグ&ロップのプログラムです。今すぐに、各コンポーネントまたはプロセッサがデータの計算を実行する方法をユーザは設定および最適化できます。ウィンドウ処理機能、複数のストリーム結合、その他のデータ操作を実行できます。SAMは現在、Apache Stormと呼ばれるストリーム処理エンジンをサポートしていますが、後にSparkやFlinkなどの他のエンジンもサポートします。その際には、ユーザーが選択したいストリーム処理エンジンを選択できるようになるでしょう。

### Schema Registry
Schema Registry（SR）は、RESTfulインターフェイス経由でAvroスキーマを格納および取得します。SRには、すべてのスキーマを含むバージョン履歴が保存されます。シリアライザは、スキーマを格納するKafkaクライアントに接続するために提供され、Avro形式で送信されたKafkaメッセージを取得します。

## Step 1: Druid ServiceにMAPBox APIキーを追加する
Mapboxは地図でデータの可視化を作成できるサービスで、SuperSetで使用します。SuperSetでMapboxの地図の可視化機能を使用するためには、MapBox APIキーをDruidの設定として追加する必要があります。
1. APIキーを取得するためには、`mapbox.com`に移動し、アカウントを作成します。その後、Mapbox Studio -> “My Access Tokens” -> “Create a new token” -> `DruidSuperSetToken`という名前を付け、初期設定を保持しておきます。

### Mapbox Studio
![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/mapbox_studio-4.png)

### My access tokens
![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/my_access_tokens-4.png)

### Create a new token: DruidSuperSetToken
- 初期設定のパラメータのままで、トークンの名前を`DruidSuperSetToken`にします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/create_new_token_druidsuperset-4.png)

2. Ambari Druid Serviceから、Configs -> Advanced -> フィルタフィールドにて`MAPBOX_API_KEY`を検索すると、**MAPBOX_API_KEY**の属性が表示されます。 mapbox.comから取得した**MAPBOX_API_KEY**を記入してください。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/update_mapbox_api_field-4.png)

- Saveをクリックし、Save Configurationに`MAPBOX_API_KEY added`を入力し、もう一度Saveを押下します。

3. **Druid SuperSet**コンポーネントを再起動します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/restart_druid-4.png)

## Step 2: Kafkaトラックトピックが作成されていることを確認する
1. hdfsユーザに切り替え、ディレクトリを作成し、すべてのユーザに権限を与えます。これにより、SAMはすべてのディレクトリにデータを書き込むことができます。
```sh
su hdfs
hdfs dfs -mkdir /apps/trucking-app
hdfs dfs -chmod 777 /apps/trucking-app
cd /usr/hdp/current/kafka-broker/bin/
./kafka-topics.sh --list --zookeeper sandbox-hdf.hortonworks.com:2181
```

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/list_kafka_topics-4.png)

## Step 3: Schema Registryにトラックスキーマを作成する
Schema Registryに`sandbox-hdf.hortonworks.com:17788`、またはAmbariのQuick Linksにある“Registry UI”からアクセスします。4つのトラックスキーマを作成していきます。

1. 新しいスキーマを追加するためには“+”ボタンをクリックします。“Add New Schema”というウィンドウが表示されます。
2. **表1**の情報をもとに、新規のスキーマ（最初のスキーマ）に次の特性を追加します。

**表1**: raw-truck\_events\_avroスキーマ

| PROPERTY    | VALUE                                     |
|-------------|-------------------------------------------|
| Name        | raw-truck_events_avro                     |
| Desc        | Raw Geo events from trucks in Kafka Topic |
| Group       | truck-sensors-kafka                       |
| Browse File | raw-truck_events_avro.avsc                |

**ファイル参照**: 先ほどダウンロードした“templates”フォルダに移動すると、"Schema"フォルダに全てのスキーマテンプレートがあります。

スキーマ情報のフィールドを入力してテンプレートをアップロードしたら、**Save**をクリックします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/raw_truck_events_avro-4.png)

> 注釈: Groupは論理グループのようなものです。アプリケーション開発者が同じ全てのSchema Registryからスキーマを取得し、それらのプロジェクトに関連した名前でグループ化する1つの方法です。

3. **表2**の情報をもとに、**2番目の新しいスキーマ**を追加します。

**表2**: raw-truck\_speed\_events\_avroスキーマ

| PROPERTY    | VALUE                                       |
|-------------|---------------------------------------------|
| Name        | raw-truck_speed_events_avro                 |
| Desc        | Raw Speed Events from trucks in Kafka Topic |
| Group       | truck-sensors-kafka                         |
| Browse File | raw-truck_speed_events_avro.avsc            |

スキーマ情報のフィールドを入力してテンプレートをアップロードしたら、**Save**をクリックします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/raw-truck_speed_events_avro-4.png)

4. **表3**の情報をもとに、**3番目の新しいスキーマ**を追加します。

**Table 3**: truck\_events\_avroスキーマ

| PROPERTY    | VALUE                                                |
|-------------|------------------------------------------------------|
| Name        | truck_events_avro                                    |
| Desc        | Schema for the kafka topic named ‘truck_events_avro’ |
| Group       | truck-sensors-kafka                                  |
| Browse File | truck_events_avro.avsc                               |

スキーマ情報のフィールドを入力してテンプレートをアップロードしたら、**Save**をクリックします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/truck_events_avro-4.png)

5. **表4**の情報をもとに、**4番目の新しいスキーマ**を追加します。

**Table 4**: truck\_speed\_events\_avroスキーマ

| PROPERTY    | VALUE                                                      |
|-------------|------------------------------------------------------------|
| Name        | truck_speed_events_avro                                    |
| Desc        | Schema for the kafka topic named ‘truck_speed_events_avro’ |
| Group       | truck-sensors-kafka                                        |
| Browse File | truck_speed_events_avro.avsc                               |

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/truck_speed_events_avro-4.png)

**Save**をクリックします。

## Step 4: GeoEnrich Kafka DataにNiFiフローを導入する
1. Ambari NiFi Service Summaryウィンドウの“Quick Links”からNiFiを起動するか、`http://sandbox-hdf.hortonworks.com:19090/nifi`でNiFi UIを開きます。
2.  “Operate panel”のNiFi upload templateボタンを使用して、先ほどダウンロードした“templates” -> “nifi”フォルダにある`Nifi_and_Schema_Registry_Integration.xml`をアップロードします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/upload_nifi_template-4.png)

3. Templateアイコンを“components toolbar”からキャンバスにドラッグし、アップロードしたばかりのテンプレートを追加します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/template_of_nifi_flow_use_case1-4.png)

4. “Operate panel”の左隅にある歯車をクリックし、“Controller Services”タブを開きます。
5. “HWX Schema Registry”サービスを確認します。Schema RegistryのREST API URLがHDF 3.0 Sandboxで実行されている適切なSchema Registryを指していることを確認します。`http://sandbox-hdf.hortonworks.com:17788/api/v1`であるはずです。
6. “HWX Schema Registry”サービスが有効であることを確認します。“HWX Schema Registry”に依存する他のすべての関連するサービスが有効であることを確認します。下図のように有効になっていない場合は、**稲妻**の記号をクリックして有効にします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/nifi_controller_services-4.png)

7. NiFiフローのルートレベルから、左下の“NiFi Flow”に示すように、**NiFiフローを開始します**。“Use Case 1”のプロセスグループを右クリックし、“Start”を選択します。“Data-Loader”が実行されるまで、データの登録は開始されません。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/start_nifi_flow_pg_uc1-4.png)

## Step 5: Druid SuperSetのためのデータを前処理するためにSAMトポロジをデプロイする
1. Ambari SAM Service Summaryウィンドウの“Quick Links”からStreaming Analytics Manager（SAM）を起動するか、`http://sandbox-hdf.hortonworks.com:17777/`でSAM UIを開きます。
2. 左隅にあるツールの“Configuration”をクリック -> “Service Pool”リンクを選択します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/service_pool_sam-4.png)

3. Ambari API URLに http://sandbox-hdf.hortonworks.com:8080/api/v1/clusters/Sandbox を入力します。
4. ユーザ名`admin`、パスワード`admin`でログインします。

- **SAM Service PoolをAmbari API URLに指し示します。**

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/insert_ambari_rest_url_service_pool-4.png)

- **SAMクラスタが作成されました。**

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/cluster_added-4.png)

5. ホーム画面に戻るために、左上にあるSAMのロゴをクリックします。
6. ツールの“Configuration”をクリックし、“Environments”をクリックします。以下の表について、以下のプロパティ値を持つ新しい環境を追加するために、“+”ボタンをクリックします。

表5: Environment metadata

| PROPERTY    | VALUE                  |
|-------------|------------------------|
| Name        | HDF3_Docker_Sandbox    |
| Description | SAM Environment Config |
| Service     | Include all services   |

OKをクリックして環境を作成します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/HDF3_Docker_Sandbox-4.png)

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/environment_created_successfully-4.png)

7. 左隅にある“Configuration”ボタンをクリックし、次に“Application Resources”をクリックして、UDFタブを押下します。新しいUDFを追加するためには‘+’をクリックします。以下の表について、“Add UDF”ウィンドウのフィールドに下記のプロパティ値を入力し、OKをクリックします。

| PROPERTY     | VALUE                                     |
|--------------|-------------------------------------------|
| Name         | ROUND                                     |
| Display Name | ROUND                                     |
| Description  | Rounds a double to integer                |
| Type         | FUNCTION                                  |
| Classname    | hortonworks.hdf.sam.custom.udf.math.Round |
| UDF JAR      | sam-custom-udf-0.0.5.jar                  |

> 注釈: UDF JARは、以前ダウンロードした“sam”フォルダの“templates”フォルダにあります。

- **新しいUDFを追加**

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/add_udf_round-4.png)

- **ROUND UDFが追加されました**

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/round_udf_added-4.png)

SAMのロゴを押下し、“My Applications”ページに戻ります。

8. “+”ボタンをクリックして新しいアプリケーションを追加します。“Import Application”を選択し、“sam”フォルダから“IOT-Trucking-Ref-App.json”のテンプレートを選択します。

- Application Name: `IOT-Trucking-Demo`
- Environment: HDF3\_Docker\_Sandbox

**OK**をクリックします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/iot-trucking-demo-4.png)

9. キャンバスに表示されるSAMトポロジから、2つのKafka Sinkを確認します。それぞれをダブルクリックし、“Security Protocol”で“PLAINTEXT”が選択されていることを確認します。Kafka BrokerのURLは、`sandbox-hdf.hortonworks.com:6667`を指しているはずです。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/kafka_sinks_edit_broker_url-4.png)

10. Druid Sinkを確認し、ZOOKEEPER CONNECT STRING URLが`sandbox-hdf.hortonworks.com:2181`に設定されていることを確認します。それ以外であったらその値を変更します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/verify_druid_url-4.png)

11. SAMトポロジをデプロイするためには、右下の**Run**アイコンをクリックします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/run_the_sam_app-4.png)

- 注釈: “Are you sure want to continue with this configuration?”のウィンドウが表示され、デフォルトの設定を維持してOKをクリックします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/build-app-jars-4.png)

デモが正常にデプロイされたことを示すはずです。

## Step 6: アプリケーションでData-Loaderを実行する
1. hdfsユーザーを終了し、Data-Loaderを実行してデータを生成し、Kafka Topicに転送します。
```sh
exit
cd /root/Data-Loader
tar -zxvf routes.tar.gz
nohup java -cp /root/Data-Loader/stream-simulator-jar-with-dependencies.jar  hortonworks.hdp.refapp.trucking.simulator.SimulationRegistrySerializerRunnerApp 20000 hortonworks.hdp.refapp.trucking.simulator.impl.domain.transport.Truck  hortonworks.hdp.refapp.trucking.simulator.impl.collectors.KafkaEventSerializedWithRegistryCollector 1 /root/Data-Loader/routes/midwest/ 10000 sandbox-hdf.hortonworks.com:6667 http://sandbox-hdf.hortonworks.com:17788/api/v1 ALL_STREAMS NONSECURE &
```

Data-Loaderを実行させることによって、Kafkaトピックにデータが保存され、NiFiとSAMがKafkaトピックからデータを取り出します。

2. nohup.outファイルにデータが取り込まれていることを確認します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/data-loader-output-4.png)

### 6.1 データフローとストリーム処理データを確認する
3. NiFi UIに戻ると、Kafka Consumerからトラックイベントに引っ張ってきているはずです。そうでなければ、それ以前に問題があります。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/nifi_pg_data_flows-4.png)

4. SAM UIに戻り、左上にあるSAMのロゴをクリックしてSAMのルートレベルに移動します。現在のページから移動するかどうかを尋ねるメッセージが表示されたら、OKをクリックします。次に、アプリケーションの概要を提供する必要があります。アプリケーションの詳細を表示するには、appをクリックします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/overview_sam_app-4.png)

5. Storm Monitorをクリックし、Stormがタプルを処理していることを確認します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/storm_process_data-4.png)

## Step 7: スライスを持つSuperSetダッシュボードを作成する
1. Ambariダッシュボードから、Druid Serviceをクリックします。その後、“Quick Links”ドロップダウンを押下し、SuperSetを選択します。
2. 初期設定でログインしていない場合、ログインの認証情報は`admin / hadoophadoop`です。
3. “Sources”、“Refresh Druid Metadata”の順にクリックします。SAMトポロジによって作成された2つのデータソースは、25分以内に表示されます。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/druid_datasource_appears-4.png)

4. “Data Source”の`violation-events-cube-2`を選択すると、データの可視化を作成できる“Datasource & Chart Type”ページが表示されます。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/datasource_chart_type-4.png)

### “サンバースト図”でDriverViolationsSunburstの可視化を作成する
1. Data Source & Chart Typeから、“Table View”をクリックし、Chart typeを`Sunburst`に設定します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/set_table_view-4.png)

2. “Time”から、“Time Granularity”を`one day`に設定します。“Since”を`7 days ago`に、“Until”を`now`に設定します。
3. Hierarchyを`driverName, eventType`に設定します。
4. 左上にある“緑のQueryボタン”を押下してクエリを実行し、出力を確認します。Sunburstの可視化には18.49秒かかります。

5. Save asボタンをクリックして、Save asには`DriverViolationsSunburst`と入力し、add to new Dashboardには`TruckDriverMonitoring`を入力して、保存をします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/TruckDriverMonitoring-4.png)

### “Mapbox”でDriverViolationMapの可視化を作成する
1. “Table View”で`Mapbox`を選択します。
2. **Time**には、先ほどの設定を維持します。
3. “Longitude”と“Latitude”を名前付き変数（longitudeとlatitude）に変更します。
4. “Clustering Radius”を`20`に設定します。
5. “GroupBy”を`latitude,longitude,route`に設定します。
6. “Label”を`route`に設定します。
7. “Map Style”を`Outdoors`に設定します。
8. Viewportから、“Default Long field”を`-90.1`に、Latを`38.7`に、Zoomを`5.5`に設定します。
9. クエリを実行します。
10. “Save As”ボタンをクリックして、“Save as”を選択し`DriverViolationMap`と名付けます。その後、“Add slice to existing dashboard”を選択し、ドロップダウンから`TruckDriverMonitoring`を選びます。“Save”を押下します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/TruckDriverMonitoring-4.png)

### SuperSetスライスの可視化ダッシュボードにアクセスする
1. Dashboardsタブをクリックすると、ダッシュボードのリストが表示されます。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/superset_dashboard_list-4.png)

2. TruckDriverMonitoringのダッシュボードを選択します。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/dashboard_slices-4.png)

### 他のSuperSetの可視化を試す（任意）
1. “TruckDriverMonitoring”のダッシュボードにて、“+”ボタンで新しいスライスを作成し、他の可視化を探索します。
2. 新しい可視化スライスを作成します。

## まとめ
おめでとうございます！堅牢なキュー（Kafka）、データフローマネジメントエンジン（NiFi）、ストリーム処理エンジン（Storm）を使用してトラックのイベントデータを処理するSAMのデモをデプロイしました。Stream Analytics Managerを使用して複雑なデータを計算するために視覚的なデータフローを作成し、Druid SuperSetでデータを可視化する方法について学びました。

## 参考文献
- [Stream Analytics Manager (SAM)](https://docs.hortonworks.com/HDPDocuments/HDF3/HDF-3.0.0/bk_streaming-analytics-manager-user-guide/content/ch_sam-manage.html)
- [Druid SuperSet Visualization](https://community.hortonworks.com/articles/80412/working-with-airbnbs-superset.html)
- [SuperSet](http://airbnb.io/superset/)
- [Druid](http://druid.io/docs/latest/design/index.html)
- [Schema Registry](http://docs.confluent.io/current/schema-registry/docs/index.html)

## 付録: リアルタイムイベント処理のデモについてのトラブルシューティング
### 付録A: SAMアプリケーションのシャットダウン
1. data-loaderを強制終了する。
```sh
(ps -ef | grep data-loader)
```

2. NiFiがkafkaのキューを吐かせ、NiFiフローのデータが0になります。
3. Ambariからすべてのサービスを停止します。
4. HDF 3.0 Sandboxのインスタンスをシャットダウンします。

### 付録B: Kafkaトピックが存在しなかった場合、Kafkaトピックを作成する
1. SSHでHDS 3.0 Sandboxに入ります。
```sh
ssh root@localhost -p 12222
sudo su -
```

2. 新しいアプリケーションをデプロイするために、既にアプリケーションが存在する場合に備えて、Kafka Topicを削除してください。
```sh
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --delete --if-exists --zookeeper sandbox-hdf.hortonworks.com:2181 --topic raw-truck_events_avro
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --delete --if-exists --zookeeper sandbox-hdf.hortonworks.com:2181 --topic raw-truck_speed_events_avro
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --delete --if-exists --zookeeper sandbox-hdf.hortonworks.com:2181 --topic truck_events_avro
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --delete --if-exists --zookeeper sandbox-hdf.hortonworks.com:2181 --topic truck_speed_events_avro
```

3. Kafka Topicを再作成する。
```sh
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --create --if-not-exists --zookeeper sandbox-hdf.hortonworks.com:2181 --replication-factor 1 --partition 1 --topic raw-truck_events_avro
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --create --if-not-exists --zookeeper sandbox-hdf.hortonworks.com:2181 --replication-factor 1 --partition 1 --topic raw-truck_speed_events_avro
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --create --if-not-exists --zookeeper sandbox-hdf.hortonworks.com:2181 --replication-factor 1 --partition 1 --topic truck_events_avro
/usr/hdp/current/kafka-broker/bin/kafka-topics.sh --create --if-not-exists --zookeeper sandbox-hdf.hortonworks.com:2181 --replication-factor 1 --partition 1 --topic truck_speed_events_avro
```

### 付録C: SAMトポロジにNotification Sinkを追加する
1. 左にあるprocessorバーをNotification Sinkまでスクロールします。Notification Sinkをドラッグしてトポロジに接続します。デフォルトコネクションを受け入れます。

- Notification Sinkまでスクロールします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/notification_sink-4.png)

- キャンバスにNotification Sinkをドラッグします。

![image](https://2xbbhjxc6wk3v21p62t8n4d4-wpengine.netdna-ssl.com/wp-content/uploads/2017/06/drag_notification_sink_to_canvas-4.png)

2. Notification sinkを編集し、下記のプロパティ値を追加します。

| PROPERTY      | VALUE                 |
|---------------|-----------------------|
| Username      | hwx.se.test@gmail.com |
| Password      | StrongPassword        |
| Host          | smtp.gmail.com        |
| Port          | 587                   |
| From/To Email | hwx.se.test@gmail.com |
| Subject       | Driver Violation      |
| Message       | Driver ${driverName} is speeding at ${speed_AVG} mph over the last 3 minutes |

### 付録D: SAMのデモの拡張機能を追加する
SAMのデモの拡張機能には、カスタムプロセッサとUDFが付属しています。これらのコンポーネントは、“Application Resources” -> “Custom Processor”または“UDF”に追加することによって、トポロジに組み込むことができます。

1. SAMのデモの拡張機能をダウンロードします。
```sh
git clone https://github.com/georgevetticaden/sam-custom-extensions.git
```

2. HDF 3.0 Sandboxにmavenをダウンロードします。
```sh
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
mvn --version
```

3. maven clean packageを実行して、カスタムプロセッサとUDFのためのプロジェクトコードを独自のjarファイルにパッケージ化します。
```sh
mvn clean package -DskipTests
```

OKを押下します。
