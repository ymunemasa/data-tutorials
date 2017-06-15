# チュートリアル 2: 地理情報でデータフローをエンリッチメント

## はじめに

このセクションでは、車両フィルタリングデータフローに地理的な位置情報エンリッチメントを施します。
複数のシステム間での自動化、管理された情報のフロー、そしてデータフローのモニタリングや調査用のNiFiの機能について、深い理解を得ることができるでしょう。
この改良を追加するには、Google Places Nearby APIをNiFiから利用し、車両の移動に応じて周辺情報を表示します。
NiFiでは他のテクノロジーをデータ処理に簡単に利用することができるので、外部APIの利用も実現可能なデザインパターンです。

このチュートリアルでは、地理的位置情報エンリッチメントセクションをデータフローに追加します:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab2-geo-location-enrichment-nifi-lab-series/complete_dataflow_lab2_geoEnrich.png)

[Lab2-NiFi-Learn-Ropes.xml](https://raw.githubusercontent.com/hortonworks/tutorials/hdp/assets/learning-ropes-nifi-lab-series/lab2-template/Lab2-NiFi-Learn-Ropes.xml)テンプレートファイルを利用しても良いですし、スクラッチでデータフローを作成する場合は、チュートリアルに進みましょう。

## 事前準備

- 「チュートリアル 0: NiFiのダウンロード、インストール、起動」を完了していること
- 「チュートリアル 1: シンプルなNiFiデータフロー構築」を完了していること

## OUTLINE

- Google Places API
- Step 1: NiFiでHTTP URLを作成するためのAPIキーの取得
- Step 2: 地理的位置情報エンリッチメントデータフローセクションの作成
- Step 3: NiFiデータフローの実行
- まとめ
- さらに理解を深めるために

## Google Places API

Google Places API Web ServiceはHTTPリクエストを利用し、施設、地理的位置情報、著名なPoint of Interestといった場所に関する情報を返します。Places APIには6種類のリクエストがあります: Place Searches, Place Details, Place Add, Place Photos, Place Autocomplete, Query Autocomplete。これらのリクエストの詳細は[Introducing the API](https://developers.google.com/places/web-service/intro)をご覧ください。

すべてのリクエストはHTTPリクエストでアクセスし、JSONかXMLのレスポンスが返ります。

Places APIを利用する上で必要となるコンポーネントは何でしょう?

- https:// プロトコル
- APIキー

## Step 1: NiFiでHTTP URLを作成するためのAPIキーの取得

これから作成するデータフローでは、変化する車両のロケーション付近の情報を検索し、データをエンリッチメントするのがミッションです。
このデータから２つのパラメータを取得します: 近辺施設の名称とSan Francisco Muni Transit Agencyです。
よってNiFiからNearby Search HTTPリクエストを利用します。

NiFiで必要なNearby Searchリクエストは下記形式のHTTP URLです:
```
https://maps.googleapis.com/maps/api/place/nearbysearch/output?parameters
```

`output`は`json`か`xml`の２つの形式が指定できます。チュートリアルではjsonを利用します。

Nearby Searchリクエストを実行するために必要なパラメータを取得しましょう。

1. クォータ管理でこのアプリケーションを特定するため、そしてアプリケーションから追加したPlacesが直ちにアプリケーション(NiFi)から利用できるよういするために、[APIキーを取得](https://developers.google.com/places/web-service/get-api-key)しましょう。

2. 標準のGoogle Places APIを利用します。青い**Get A Key**ボタンをクリックし、API Web Serviceをアクティベートします。

3. **Select a project where your application will be registered**と記載されたウィンドウが表示されます、`Create a new project`を選択します。このアプリケーション用のプロジェクトを作成します。
**Continue**をクリックします。
数秒待つと、新しい画面がロードされます。

4. 名前フィールドに**Server key 1**とある画面が表示されます、青い**Create**ボタンをクリックします。

5. 以下の表に示すように、ユニークなAPIキーが表に表示されます:

**表1: APIキーテーブルの例**

|名前|作成日|タイプ|キー|
|----|----|----|----|
|Server Key 1|June 14, 2016|Server|AIzaSyDY3asGAq-ArtPl6J2v7kcO_YSRYrjTFug|

HTTPリクエスト用APIキーが用意できました。
他にも必要なパラメータとして: **location**があります。チュートリアル1のおかげで、longitude、latitudeはすでに抽出済です。そして**radius**ですが、距離であり、50,000メートルを超えることはありません。
そして任意のパラメータである**type**を、検索対象の場所の種別を指定するために利用します。

6. 後ほど、**InvokeHTTP**のプロパティ値として利用できるように、以下のパラメータでHTTP URLを作成してみましょう。

- API Key = AIzaSyDY3asGAq-ArtPl6J2v7kcO_YSRYrjTFug
- Latitude = ${Latitude}
- Longitude = ${Longitude}
- radius = 500
- type = neighborhood

```
https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${Latitude},${Longitude}&radius=500&type=neighborhood&key=AIzaSyDY3asGAq-ArtPl6J2v7kcO_YSRYrjTFug
```

> 注: 上記URL内のAPIキーはご自身のものに置換してください。

## Step 2: 地理的位置情報エンリッチメントデータフローセクションの作成

地理的位置情報エンリッチメントをデータフローに追加するには、6つのプロセッサが必要です。
各プロセッサはエンリッチしたデータを宛先に転送する際に重要な役割を担います:

- **InvokeHTTP** HTTPリクエストを実行し、Google Places APIから車両ロケーション付近の場所データを取得します。
- **EvaluateJsonPath** neighborhoods_nearbyとcityデータ要素をJSONから抽出します。
- **RouteOnAttribute** neighborhoods_nearbyとcityが空でないフローファイルをルーティングします。
- **AttributesToJSON** JSONコンテンツを結合し、フローファイルをマージします。
- **PutFile** エンリッチしたフローファイルの地理的位置情報コンテンツをローカルファイルシステムに保存します。

### 2.1 学習の目的: データフローに地理的エンリッチメントの追加

- 地理的エンリッチメントAPIデータの取込、フィルタ、保存に利用するプロセッサを追加/設定/接続する
- 問題が発生したら解決する
- データフローを実行する

### InvokeHTTP

1. InvokeHTTPプロセッサをNiFiのグラフに追加します。チュートリアル1の**RouteOnAttribute**を**InvokeHTTP**に接続します。
Create Connectionウィンドウが表示されたら、**Filter Attributes**がチェックされていることを確認し、されていなければチェックして、**Add**をクリックします。

2. InvokeHTTPのプロパティ設定タブで**表1**に示すプロパティを設定します。

**表1**: 設定するInvokeHTTPプロパティの値

|プロパティ|値|
|----|----|
|Remote URL|https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${Latitude},${Longitude}&radius=500&type=neighborhood&key=AIzaSyDY3asGAq-ArtPl6J2v7kcO_YSRYrjTFug|

- **Remote URL** 先程作成したGoogle Places APIを利用するHTTP URLに接続し、取得したデータをデータフローにフィードします。
locationパラメータには２つのNiFiエクスプレッションを利用している点に注意してください。
これは、このプロセッサに新しくフローファイルが渡ってくるたびに、これら２つの値は変化するためです。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab2-geo-location-enrichment-nifi-lab-series/invokeHTTP_config_property_tab_window.png)

3. **Settings**タブを表示し、InvokeHTTPから`GoogleNearbySearchAPI`に名称を変更しましょう。
Auto terminate relationshipsにある**Failure、No Retry、Original、Retry**をチェックします。
**Apply**ボタンをクリックします。

### EvaluateJsonPath

1. EvaluateJSONPathプロセッサをNiFiのグラフに追加します。**InvokeHTTP**を**EvaluateJsonPath**に接続します。
Create Connectionウィンドウが表示されたら、**Response**がチェックされていることを確認し、Applyをクリックします。

2. EvaluateJsonPathのプロパティ設定タブで**表2**に示すプロパティを設定します。
注: `city`と`neighborhoods_nearby`を**New property**ボタンをクリックして追加し、それぞれの値をプロパティタブで入力します。

**表2**: 設定するEvaluateJsonPathプロパティの値

|プロパティ|値|
|----|----|
|Destination|flowfile-attribute|
|Return Type|json|
|city|$.results[0].vicinity|
|neighborhoods_nearby|$.results[*].name|

- **Destination** JSON Path式の結果をフローファイルの属性に保存します。
- **2つのユーザ定義属性** それぞれ次のプロセッサのNiFiエクスプレッション言語のフィルタ条件で利用する値を保持します。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab2-geo-location-enrichment-nifi-lab-series/evaluateJsonPath_config_property_tab_window.png)

3. **Settings**タブを表示します。
Auto terminate relationshipsにある**unmatched, failure**をチェックします。
**Apply**ボタンをクリックします。

### RouteOnAttribute

1. RouteOnAttributeプロセッサをNiFiのグラフに追加します。**EvaluateJsonPath**を**RouteOnAttribute**に接続します。
Create Connectionウィンドウが表示されたら、**matched**がチェックされていることを確認し、Applyをクリックします。

2. RouteOnAttributeのプロパティ設定タブで**New property**ボタンをクリックし、`RouteNearbyNeighborhoods`を追加し、**表3**に示すNiFiエクスプレッションの値を設定します。

**表3**: 新しいRouteOnAttributeプロパティの値を追加

|プロパティ|値|
|----|----|
|RouteNearbyNeighborhoods|${city:isEmpty():not():and(${neighborhoods_nearby:isEmpty():not()})}|

- **RouteNearbyNeighborhoods** JSONパス式で取得したフローファイルの属性値を利用し、いずれかの属性値が空のフローファイルをフィルタアウトします。そうでなければ、フローファイルを後続のプロセッサへ渡します。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab2-geo-location-enrichment-nifi-lab-series/routeOnAttribute_geoEnrich_config_property_tab_window.png)

3. **Settings**タブを表示し、名前をROuteOnAttributeから`RouteNearbyNeighborhoods`に変更します。
Auto terminate relationshipsにある**unmatched**をチェックします。
**Apply**ボタンをクリックします。


### AttributesToJson

1. AttributesToJsonプロセッサをNiFiのグラフに追加します。**RouteOnAttribute**を**AttributesToJson**に接続します。
Create Connectionウィンドウが表示されたら、**RouteNearbyNeighborhoods**がチェックされていることを確認し、Applyをクリックします。

2. AttributesToJSONのプロパティ設定タブで**表4**に示すプロパティを設定します。

**表4**: 設定するAttributesToJSONプロパティの値

|プロパティ|値|
|----|----|
|Attributes List|Vehicle_ID, city, Latitude, Longitude, neighborhoods_nearby, Last_Time|
|Destination|flowfile-content|

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab2-geo-location-enrichment-nifi-lab-series/attributesToJSON_geoEnrich_config_property_tab_window.png)

3. **Settings**タブを表示します。
Auto terminate relationshipsにある**failure**をチェックします。
**Apply**ボタンをクリックします。

### MergeContent

1. MergeContentプロセッサをNiFiのグラフに追加します。**AttributesToJson**を**MergeContent**に接続します。
Create Connectionウィンドウが表示されたら、**success**がチェックされていることを確認し、Applyをクリックします。

2. MergeContentプロパティ設定タブで**表5**に示すプロパティを設定します。
Demarcatorプロパティには、`,`を入力した後、`shift+enter`を入力します。

**表5**: 設定するMergeContentプロパティの値

|プロパティ|値|
|----|----|
|Minimum Number of Entries|10|
|Maximum Number of Entries|15|
|Delimiter Strategy|Text|
|Header|[|
|Footer|]|
|Demarcator|, {press-shift+enter}|

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab2-geo-location-enrichment-nifi-lab-series/mergeContent_geoEnrich_config_property_tab_window.png)

3. **Settings**タブを表示します。
Auto terminate relationshipsにある**failure,original**をチェックします。
**Apply**ボタンをクリックします。

### PutFile

1. PutFileプロセッサをNiFiのグラフに追加します。**MergeContent**を**PutFile**に接続します。
Create Connectionウィンドウが表示されたら、**merged**がチェックされていることを確認し、Applyをクリックします。

2. PutFileのプロパティ設定タブで**表6**に示すプロパティを設定します。

**表6**: 設定するPutFileプロパティの値

|プロパティ|値|
|----|----|
|Directory|/tmp/nifi/output/nearby_neighborhoods_search|

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab2-geo-location-enrichment-nifi-lab-series/putFile_geoEnrich_config_property_tab_window.png)

3. **Settings**タブを表示します。
Auto terminate relationshipsにある**success**をチェックします。
**Apply**ボタンをクリックします。
プロセッサを自身に接続し、Create Connectionウィンドウが表示されたら、**failure**をチェックします。


## Step 3: NiFiデータフローの実行

地理的位置情報エンリッチメントデータフローセクションを前チュートリアルのデータフローに追加しました。
データフローを実行し、期待する結果が得られているか、出力ディレクトリを確認してみましょう。

1. actionsツールバーにある、スタートボタン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/start_button_nifi_iot.png)をクリックします。以下のような画面になります:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab2-geo-location-enrichment-nifi-lab-series/running_dataflow_lab2_geoEnrich.png)

2. 期待するディレクトリにデータが書き込まれたかチェックします、ターミナルを開いてください。
Sandboxを利用している場合はSandboxにSSHで接続します、そうでない場合はローカルマシン上の出力ディレクトリに移動します。
PutFileプロセッサで指定したディレクトリに移動します。
ファイルを一覧表示し、直近で作成したファイルの一つを開き、地理的付近情報エンリッチメントデータの出力を確認します。
チュートリアルの出力ディレクトリは:`/tmp/nifi/output/nearby_neighborhoods_search`になっています。

```
cd /tmp/nifi/output/nearby_neighborhoods_search
ls
vi 38997303004413
```

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab2-geo-location-enrichment-nifi-lab-series/output_geoEnrich_nearby_neighborhoods_data.png)

## まとめ

おめでとうございます！
データフローの地理的エンリッチメントセクションでは、InvokeHTTPを利用し、Google Places Search APIを利用した近隣の地理的位置情報にアクセスする方法を学習しました。
URL内の緯度軽度が新しいフローファイルがプロセッサに渡るたびに変わるように、NiFiエクスプレッションの変数をInvokeHTTPのRemoteURLプロパティに追加しました。
EvaluateXPathに似た、JSONエクスプレッションを利用してJSONの要素(neighborhoods_nearby, city)を抽出する、EvaluateJsonPathの利用方法を学びました。
これで、外部APIを利用してNiFiのデータフローをさらに拡張できるようになりました。

## さらに理解を深めるために

- [Google Places API](https://developers.google.com/places/)
- [HTTP Protocol Overview](http://code.tutsplus.com/tutorials/http-the-protocol-every-web-developer-must-know-part-1--net-31177)
- [JSON Path Expressions](http://goessner.net/articles/JsonPath/index.html#e2)
- [JSON Path Online Evaluator](http://jsonpath.com/)

---

[前へ](Ropes-of-Apache-NiFi%3A-Tutorial-1.md) | [次へ](Ropes-of-Apache-NiFi%3A-Tutorial-3.md)