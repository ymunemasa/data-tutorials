## 1-1: NiFiのUIを表示する

それでは、NiFiのUIからデータを受信するためのフローを構築していきましょう！
NiFiのUIはAmbariのNiFiサービスにあるQuick Linkから表示できます:

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/ambari/quick-links.png)

## 1-2: ProcessGroup `HTTP API`を作成する

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/add-process-group.png)

ProcessGroupとはNiFiのデータフロー内の処理をグループ化するためのコンポーネントです。
うまくグループ化すると複雑でも分かりやすいフローが作成できます。はじめに名前を付けることで、何をするグループなのか目的をはっきりさせる効果もありますね。

画面上部のProcessGroupアイコンをキャンバスへドラッグしてProcessGroupを追加します。

この後の操作はHTTP APIの中で行います。ProcessGroupをダブルクリックして、中へ入りましょう。

## 1-3: `HandleHttpRequest`プロセッサを追加する

画面上部のProcessorアイコンをキャンバスにドラッグすると、プロセッサ選択画面が表示されます:

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/search-processors.png)

`HandleHttp`と検索窓に入力して、HandleHttpRequestプロセッサを追加しましょう。

追加したHandleHttpRequestプロセッサを右クリックし、`Configure`を選択、`PROPERTIES`タブからプロセッサの設定を行います。
HTTPリクエストを受信するポートを80から9095に変更しましょう。

| Property | Value |
|----------|-------|
| Listening Port | 9095 |

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/configure-processor.png)

プロセッサには警告アイコンが表示され、`success`のリレーションがないことと、`HTTP Context Map`が未設定と警告が出ます。
とりあえずそのままにして、次のプロセッサを追加しましょう。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/processor-config-error.png)

## 1-4: `ReplaceText`を追加する

同様に`ReplaceText`プロセッサを追加します。
このプロセッサでは、HTTPレスポンスで返すボディの文字列を設定します。

| Property | Value |
|----------|-------|
| Replacement Value | {"Result": "OK"} |
| Replacement Strategy | Always Replace |

### FlowFileとは?

NiFiのデータフロー内を流れるデータオブジェクトです。
UUID, Attribute, Contentなどのデータを格納しています。

Attributeは任意のKey/Valueで、`filename`など、FlowFileのメタデータを保持します。
AttributeはJava VMヒープ領域に保持されます。

ContentはFlowFileのデータそのもので、不透明なバイト配列として扱われます。
メモリ上には保持されず、プロセッサ内で利用するときだけ、なるべくストリーミング形式で読み込み/書き込みされます。

※「なるべく」というのはJSONのパースなど、Content全体をロードせずには動かないプロセッサもあるためです。基本的にはJVMヒープよりも巨大なデータを扱えるようにストリーミング形式でデータを扱っています。

## 1-5: `HandleHttpResponse`を追加する

HTTPクライアントに結果を返す`HandleHttpResponse`を追加しましょう。
結果コードは決め打ちで`202 (Accepted)`としておきましょう。

| Property | Value |
|----------|-------|
| HTTP Status Code | 202 |

## 1-6: 3つのプロセッサをつなぐ

NiFiのデータフローは、プロセッサをRelationshipでつなぐことで流れをつくっていきます。
プロセッサの中心からマウスをドラッグし、接続先のプロセッサでドロップすることで、つなぐことができます。

以下の図を参考に、３つのプロセッサをRelationshipでつなぎましょう。
接続元のプロセッサが複数の出力Relationshipを持っている場合(success, failure ... etc)、確認ダイアログが表示されます。
ここでは、正常ルートを定義するので、`success`を選択しましょう:

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/connected-processors.png)

## 1-7: LogAttributeにFailureを流す

プロセッサ設定の不備などで、処理が失敗した場合、渡ってきたFlowFileは`failure`に流されます。
後で確認できるように、`LogAttribute`プロセッサを追加して、ReplaceTextとHandleHttpResponseのfailureをこちらに流しましょう:

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/failure-to-logattribute.png)

## 1-8: 不要なRelationshipをAuto-Terminateする

NiFiの内部を流れるFlowFileは、行き先がなくなる (終点までたどり着く) と、削除されます。
ガベージコレクションのようなものです。

終端のプロセッサでは、それ以上FlowFileを扱う必要がないので、`success`の先がありません。

以下のRelationshipをプロセッサの`SETTINGS`タブから、`Automatically Terminate Relationships`でチェックしましょう:

- HandleHttpResponse: success
- LogAttribute: success

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/auto-terminate.png)

## 1-9: Http Context Mapを作成する

HandleHttpResponseの`HTTP Context Map`から、`Create new service...`を選択し、StandardHttpContextMapを作成します。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/create-new-service.png)

再びHandleHttpResponseの設定画面が表示されるので、`HTTP Context Map`の右側に表示される右矢印をクリックしましょう。表示されるダイアログは、「ControllerServiceの設定に移る前に、プロセッサを保存しますか?」というものです。Yesをクリックしましょう。

ControllerServiceとは、複数のプロセッサで共有して利用するコンポーネントです。
HandleHttpRequestはHTTPリクエストを受信すると、StandardHttpContextMapにリクエストを保存し、下流のデータフローへ受信したデータを流します。その後、今回の例ではReplaceTextを利用してレスポンスのボディを設定しています。最後にHandleHttpResponseでレスポンスを返すという仕組みです。HandleHttpRequest/Response間には任意のプロセッサを配置することができます。

Controller Servicesタブの稲妻アイコンをクリックして、StandardHttpContextMapを有効化しましょう。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/enable-service.png)

同様にHandleHttpRequestの`HTTP Context Map`でも同じControllerServiceを指定します。
これでプロセッサに必要な設定が完了しました。

## 1-9: フローを開始し、cURLでテスト

キャンバスの空白部分をクリックし、選択を解除してから、操作パレットのスタートアイコンをクリックして、すべてのプロセッサを起動しましょう。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/start-processors.png)


サーバにSSHログインし(またはお使いのPCから)、以下のコマンドでHTTPリクエストを送信して、結果を確認しましょう:

```bash
$ curl -i -XPOST -H "Content-type: application/json" -d '{"name": "C", "age": 20}' localhost:9095

HTTP/1.1 202 Accepted
Date: Mon, 06 Mar 2017 07:27:48 GMT
Transfer-Encoding: chunked
Server: Jetty(9.3.9.v20160517)

{"Result": "OK"}
```

NiFiのUIに戻ってみると、HandleHttpRequestからHandleHttpResponseまでの正常ルートを1件のデータが通ったことが確認できます。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/nifi/http-post/flow-statistics.png)


### まとめクイズ

- NiFiでは処理を行う小粒のモジュールのことを何と呼びますか?
- NiFiでControllerServiceとはどのようなものですか? どういうときに必要になりますか?
- NiFi内部を流れるデータオブジェクトは何と呼びますか?

### [前へ](https://github.com/hortonworksjp/data-tutorials/blob/master/tutorials/hdf/Intro_NiFi_Kafka_Storm/HDF%E3%83%8F%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AA%E3%83%B3-0:-NiFi%2C-Kafka%2C-Storm%E3%82%92%E7%B5%84%E3%81%BF%E5%90%88%E3%82%8F%E3%81%9B%E3%81%A6%E5%88%A9%E7%94%A8%E3%81%99%E3%82%8B.md) | [次へ](https://github.com/hortonworksjp/data-tutorials/blob/master/tutorials/hdf/Intro_NiFi_Kafka_Storm/HDF%E3%83%8F%E3%83%B3%E3%82%B9%E3%82%99%E3%82%AA%E3%83%B3-2:-%E3%83%86%E3%82%99%E3%83%BC%E3%82%BF%E3%81%AE%E5%A4%89%E6%8F%9B.md)
