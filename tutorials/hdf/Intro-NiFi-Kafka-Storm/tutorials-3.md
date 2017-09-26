## 3-1: `Reporting` ProcessGroupを作成する

Kafkaへメッセージ登録を行う部分は、HTTP APIとは別の、`Reporting`というProcessGroupに作成します。
単一のグループで作業を進め、大きなデータフローになってくると、管理が煩雑になってしまいます。
チュートリアルでは、以下の２つに分けています:

- データを外部から収集し、共通のフォーマットに変換する部分
- 共通のフォーマットのデータを入力として、Kafkaにメッセージ登録を行う部分

こうすることで、HTTP以外の、TCPやMQTTなどでメッセージを受信するルートを増やす際に、変換部分のみを実装すれば良くなります。
グループの区切り方は様々です、一つの参考にしてください。

Root (一番親) のProcessGroupに戻り、`Reporting`という名前のProcessGroupを作成しましょう。
以降の作業はReporting内で行います。

## 3-2: 必要なコンポーネントを配置する

このProcessGroupでは、データを受け取ってKafkaへと登録する機能を実装します。
他のProcessGroupからFlowFileを渡すために、`Reporting`グループへ`Input Port`を追加します。
Input Portの名前は`ingest`としましょう。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/publish-kafka/flow.png)

そして、`PublishKafka_0_10`、`LogAttribute`をつなげます。
不要なRelationshipはAuto-terminateしてください。

## 3-3: PublishKafka_0_10の設定

ハンズオン用の環境では、すでに`input`という名前でKafkaトピックが作成されています。
NiFiから以下のようにPublishKafkaを設定して、メッセージを登録しましょう。

Kafkaメッセージはkeyとvalueを持っています。
Keyには、渡ってきたFlowFileの`message.key` Attributeを利用しましょう。

Valueには、FlowFileのcontentが渡されます:

| Property | Value |
|----------|-------|
| Kafka Brokers | 0.hdf.aws.mine:6667 |
| Topic Name | input |
| Kafka Key | ${message.key} |

## 3-4: HTTP APIからReportingへデータを流し込む

ルートProcessGroupへと戻り、HTTP APIからReportingへとRelationをつなぎましょう。
このように、ProcessGroup間はInput PortとOutput Portでデータの連携が可能です。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/publish-kafka/http-api-to-reporting.png)

## 3-5: Console Consumerで確認しながらテスト

サーバにSSHでログインし、以下のコマンドでConsole Consumerを起動しておきます。
NiFiからメッセージがPublishされると、こちらで確認できるはずですね:

```bash
cd /usr/hdf/current/kafka-broker
./bin/kafka-console-consumer.sh --topic input --bootstrap-server 0.hdf.aws.mine:6667 --new-consumer
```

### [前へ](tutorials-2.md)| [次へ](tutorials-4.md)
