本チュートリアルでは[Hortonworks DataFlow(HDF)](https://hortonworks.com/products/data-center/hdf/)で利用可能なOSSプロダクトを少しずつ触りながら、HDFを利用するとどんなシステムが構築できるのかを学習していきます。

## 0-1: Hortonworks DataFlow (HDF)とは

[Hortonworks DataFlow (HDF)](https://hortonworks.com/products/data-center/hdf/)とは、高速なストリーミング分析を容易に実現し、データ収集、キュレーション、分析、デリバリをリアルタイムで、オンプレミスでもクラウドでも実行可能な、Apache NiFi、Kafka、Stormが統合されたソリューションです。

## 0-2: Ambariをさわってみよう

### 0-2-1: Ambariにログイン

早速手を動かしながらチュートリアルを進めていきましょう。まずはAmbariにログインします。

本ハンズオンではシングルノードのHDFクラスタを使用します。1台のサーバ上でAmbari Server, Ambari Agent、およびAmbariからインストールしたHDFスタック (NiFi, Storm, Kafka)を起動しています。

Ambari管理画面にログインするには、お使いのPCのWebブラウザから、`http://<host>:8080/`へアクセスします。host部にはハンズオン講師から渡されたIPアドレスを利用してください。User/Passwordはどちらも`admin`です:

![](https://raw.githubusercontent.com/ijokarumawak/hdf-tutorials-ja/master/images/ambari/login.png)

### 0-2-1: HDFスタックの構成を確認

Adminの`Stack and Versions`をクリックすると、HDFスタックとしてAmbariに登録されているサービスの一覧、バージョン、インストール状況などが確認できます。

![](https://raw.githubusercontent.com/ijokarumawak/hdf-tutorials-ja/master/images/ambari/stack-and-versions.png)

### 0-2-2: HDFクラスタの構成を確認

`Hosts`をクリックすると、HDFクラスタに参加しているノードの一覧が確認できます。Ambariから新しいホストを追加すると、そのホスト上でAmbari Agentがインストールされます。その後、HDFの任意のサービスをデプロイします。

![](https://raw.githubusercontent.com/ijokarumawak/hdf-tutorials-ja/master/images/ambari/hosts.png)

## 0-3: HDFを活用したシステムを作ってみよう

NiFiはデータフローオーケストレーションツールとして、各種プロトコル、フォーマットでデータを収集するデータフローの構築、運用に便利です。Stormはリアルタイムストリーミング分析を得意としています。本ハンズオンでは、次のようなデータアプリケーションを作成します:

- NiFiを利用してHTTPプロトコルでデータを受信し、Kafkaトピックへとメッセージを登録
- StormでKafkaのメッセージを受信し、リアルタイム分析を行い、結果を別のKafkaトピックへと登録
- NiFiで結果のKafkaトピックからデータを受信し、ファイルシステムへ保存

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/sample-system.png?raw=true)

### [次へ](https://github.com/hortonworksjp/data-tutorials/blob/master/tutorials/hdf/Intro_NiFi_Kafka_Storm/HDF%E3%83%8F%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AA%E3%83%B3-1:-%E3%83%86%E3%82%99%E3%83%BC%E3%82%BF%E3%81%AE%E5%8F%96%E8%BE%BC.md)
