Stormで処理したリアルタイム分析の結果をKafkaトピックから受信し、ファイルシステムに保存しましょう。

## 5-1: 必要なプロセッサを追加する

`Reporting` ProcessGroup内にプロセッサを追加します。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/consume-kafka/flow.png)

- ConsumeKafka_0_10: `report`トピックからメッセージを受信します
- UpdateAttribute: `filename` Attributeを設定します
- PutFile: ファイルシステムへFlowFileを出力します

もうRelationshipの設定にも慣れてきたのではないでしょうか。

- 正常系をつなぐ
- 異常系を別ルートへ
- 不要なものはAuto-Terminate

です。

## 5-2: ConsumeKafka_0_10

| Property | Value |
|----------|-------|
| Kafka Brokers | 0.hdf.aws.mine:6667 |
| Topic Name(s) | report |
| Group ID | nifi |

## 5-3: UpdateAttribute

| Property | Value | Memo |
|----------|-------|------|
| filename | latest.json | |
| mime.type | application/json | 必須ではありませんが、設定しておくとFlowFileのPreviewがちゃんと見えたりして便利です |

## 5-4: PutFile

| Property | Value | Memo |
|----------|-------|------|
| Directory | /opt/hdf-handson/report | |
| Conflict Resolution Strategy | replace | すでに同一のファイル名がある場合は上書きします |

## 5-5: 分析結果を確認しながらテスト

ターミナルを２つ開きます。それぞれ、サーバにSSHでログインし、

一つ目のターミナルでは、次のコマンドでNiFiにHTTPでデータを登録しましょう。curlだと値を変えながら実行するのが多少面倒なので、スクリプトを用意しておきました:

```bash
# /opt/hdf-handson/bin/post-data <name> <age>
/opt/hdf-handson/bin/post-data A 35
```

もう一つのターミナルでは、watchコマンドでファイルを監視しておきましょう:

```bash
watch cat /opt/hdf-handson/report/latest.json
```

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/consume-kafka/test.png)

### [前へ](https://github.com/hortonworksjp/data-tutorials/blob/master/tutorials/hdf/Intro_NiFi_Kafka_Storm/HDF%E3%83%8F%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AA%E3%83%B3-4:-Storm%E3%81%A6%E3%82%99%E3%83%AA%E3%82%A2%E3%83%AB%E3%82%BF%E3%82%A4%E3%83%A0%E5%88%86%E6%9E%90.md) | [次へ](https://github.com/hortonworksjp/data-tutorials/blob/master/tutorials/hdf/Intro_NiFi_Kafka_Storm/HDF%E3%83%8F%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AA%E3%83%B3-6:-%E3%81%8A%E3%81%BE%E3%81%91-Zeppelin%E3%81%A6%E3%82%99%E5%8F%AF%E8%A6%96%E5%8C%96.md)
