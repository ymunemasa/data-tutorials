# チュートリアル 3: NextBusライブストリームの取込

## はじめに

このチュートリアルでは、車両位置情報XMLのシミュレーションデータを生成するデータフローセクションを、NextBus San Francisco Muni AgencyのOceanView路線からのライブストリームデータをNiFiデータフローに取り込む新しいセクションで置き換えます。

このチュートリアルでは、データフローのNextBus SF Muniライブストリーム取込セクションを構築します:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab3-ingest-nextbus-live-stream-nifi-lab-series/complete_dataflow_lab3_live_stream_ingestion.png)

[Lab3-NiFi-Learn-Ropes.xml](https://raw.githubusercontent.com/hortonworks/tutorials/hdp/assets/learning-ropes-nifi-lab-series/lab3-template/Lab3-NiFi-Learn-Ropes.xml)テンプレートファイルをダウンロードして利用しても良いですし、スクラッチでデータフローを作成する場合はチュートリアルに進みましょう。

## 事前準備

- 「チュートリアル 0: NiFiのダウンロード、インストール、起動」を完了していること
- 「チュートリアル 1: シンプルなNiFiデータフロー構築」を完了していること
- 「チュートリアル 2: 地理情報でデータフローをエンリッチメント」を完了していること

## 概要

- NextBus Live Feed
- Step 1: NextBus Live Streamをデータフローに追加する
- Step 2: NiFiデータフローを実行する
- まとめ
- さらに理解を深めるために

## NextBus Live Feed

NextBus Live Feedは車両の位置情報、車両到着予測時刻、車両の経路や様々な運行会社(San Francisco Muni、Unitrans City of Davisなど)の乗客に関するナマの情報を公に提供しています。
NextBus APIを利用してXMLライブフィードデータにアクセスし、URLを生成する方法を学びます。
このURLの中ではクエリ文字列としてパラメータを指定します。
チュートリアルで利用するパラメータには、車両位置情報、運行会社、経路、時刻があります。

ライブフィードのドキュメントを参照して、次のURLをGetHTTPプロセッサで作成します:

```
http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=sf-muni&r=M&t=0
```

パラメータを一つずつみて見ましょう、URLの組み立て方が良くわかるはずです。
パラメータは4つあります:

- commands: command = vehicleLocations
- agency: a=sf-muni
- route: r=M
- time: t=0

個々のパラメータに関する詳細情報は、[BextBus's Live Feed Documentation](https://www.nextbus.com/xmlFeedDocs/NextBusXMLFeed.pdf)を参照してください。

## Step 1: NextBus Live Streamをデータフローに追加する

### GetHTTP

1. GetFile、UnpackContent、COntrolRateプロセッサを削除します。これらをGetHTTPプロセッサで置き換えます。

2. **GetHTTP**プロセッサをドラッグし、以前の3つのプロセッサがあった場所に配置します。
GetHTTPをSplitXMLの上にあるEvaluateXPathプロセッサに接続します。
Create Connectionウィンドウが表示されたら、**success**がチェックされていることを確認し、Applyをクリックします。

3. GetHTTPのプロパティ設定タブを表示します。
Nextbus XMLライブフィードURLをプロパティ値にコピー&ペーストしましょう。
**表1**に示すプロパティを設定します。

**表1**: 設定するGetHTTPプロパティの値

|プロパティ|値|
|----|----|
|URL|http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=sf-muni&r=M&t=0|
|Filename|vehicleLoc_SF_OceanView_${now():format("HHmmssSSS")}.xml|

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab3-ingest-nextbus-live-stream-nifi-lab-series/getHTTP_liveStream_config_property_tab_window.png)

4. 各プロパティが設定できました。
**Settings**タブを表示し、**Run Schedule**を0 secから`1 sec`に変更します、このプロセッサは1秒ごとにタスクを実行します。
過度なシステムリソースの利用を避けることができます。

5. **Settings**タブを開き、プロセッサの名前をGetHTTPから`IngestVehicleLoc_SF_OceanView`に変更します。
**Apply**ボタンをクリックします。

### 地理情報エンリッチメントセクションのPutFileを変更する

1. PutFileの**Properties**設定タブを開きます。
Directoryプロパティの値を以前の値から**表2**の値に変更します。

**表2**: 更新するPutFileのプロパティ

|プロパティ|値|
|----|----|
|Directory|/tmp/nifi/output/nearby_neighborhoods_liveStream|

NextBusライブストリームから受信するリアルタイムデータ用に**Directory**を新しい場所に変更します。

![[](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab3-ingest-nextbus-live-stream-nifi-lab-series/modify_putFile_in_geo_enrich_section.png)

2. **Apply**をクリックします。

## Step 2: NiFiデータフローを実行する

NextBus San Francisco Muniライブストリームの取込をデータフローに追加しました。
データフローを実行し、期待する結果が得られているか、出力ディレクトリを確認しましょう。

1. actionsツールバーにあるスタートボタン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/start_button_nifi_iot.png)をクリックします。以下のような画面になっているはずです:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab3-ingest-nextbus-live-stream-nifi-lab-series/complete_dataflow_lab3_live_stream_ingestion.png)

2. 出力ディレクトリにあるデータが正しいか確認しましょう。
以下のディレクトリに移動し、ランダムに一つを開き、データを確認します。

```
cd /tmp/nifi/output/nearby_neighborhoods_liveStream
ls
vi 58849126478211
```

以下の画像のような近隣情報が取得できましたか?

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab3-ingest-nextbus-live-stream-nifi-lab-series/nextbus_liveStream_output_lab3.png)

## まとめ

おめでとうございます！
NextBus APIを利用し、XMLライブフィードを車両ロケーションデータに結合する方法を学習しました。
GetHTTPプロセッサの利用方法も学び、ライブストリームをNextBus San Francisco MuniからNiFiへ取り込むことができました!

## さらに理解を深めるために

- [NextBus XML Live Feed](https://www.nextbus.com/xmlFeedDocs/NextBusXMLFeed.pdf)
- [Hortonworks NiFi User Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_UserGuide/content/index.html)
- [Hortonworks NiFi Developer Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_DeveloperGuide/content/index.html)

[前へ](Ropes-of-Apache-NiFi%3A-Tutorial-2)