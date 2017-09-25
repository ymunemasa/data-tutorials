# チュートリアル 1: シンプルなNiFiデータフロー構築

## はじめに

このチュートリアルでは、車両位置、速度、その他センサーデータをSan Francisco Muni trafficシミュレータから取得するNiFiデータフローを作成し、特定の数車両についての観測データを探し、見つかった観測情報を新規ファイルに保存します。
このチュートリアルはデータをストリームするわけではありませんが、NiFiデータフローアプリケーション開発におけるファイルI/Oの重要性と、それをストリーミングデータのシミュレーションに活かす方法が登場します。

本チュートリアルでは、次の画像のデータフローを作成します:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/completed-data-flow-lab1.png)

**画像 1**: 完成したデータフローは3つのセクションから成ります: 車両位置XMLシミュレータからのデータを取り込む、フローファイルから車両位置詳細属性を抽出する、それらの詳細属性が空でない場合JSONファイルに変換する。
データフロー各セクション内の、各プロセッサ個別の用途についてより詳細に学習していきます。

[Lab1-NiFi-Learn-Ropes.xml](https://raw.githubusercontent.com/hortonworks/tutorials/hdp/assets/learning-ropes-nifi-lab-series/lab1-template/Lab1-NiFi-Learn-Ropes.xml)テンプレートをダウンロードして利用しても良いですし、スクラッチでデータフローを構築する場合は、**Step 1**に進みましょう。

1. Actionsツールバーにある、テンプレートアイコン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/nifi_template_icon.png)をクリックします。

2. **Browse**をクリックし、テンプレートファイルを見つけ、**Open**に続き、**Import**をクリックします。

3. NiFi HTMLインタフェースの左上をから、テンプレートアイコン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/add_nifi_template.png)をグラフ上にドラッグし、**NiFi-DataFlow-Lab1.xml**テンプレートファイルを選択します。

4. **start**ボタン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/start_button_nifi_iot.png)をクリックし、データフローをアクティベートします。データフロー作成プロセスに慣れ親しむために、以下のハンズオンの手順を読むことを強く推奨します。

## 事前準備

- 「NiFiの慣例を学ぶ」を完了していること
- 「チュートリアル 0: NiFiのダウンロード、インストール、起動」を完了していること

## 概要

- Step 1: NiFiデータフローの作成
- Step 2: XMLシミュレータデータフローセクションの作成
- Step 3: 重要属性抽出データフローセクションの作成
- Step 4: フィルタ&JSON変換データフローセクションの作成
- Step 5: NiFiデータフローの実行
- まとめ
- 付録 A: NiFiデータフローレビュー
- 付録 B: プロセッサグループのラベル作成
- より理解を深めるために

## Step 1: NiFiデータフローの作成

すべてのデータフローを構成する要素はプロセッサです。
これらのツールはデータの取込、ルーティング、抽出、分割、集約、保存のアクションを実行します。
チュートリアルのデータフローに含まれるこれらのプロセッサが担う役割の概要を簡単に説明します:

- **GetFile** 交通情報ストリームZipファイルから車両位置情報を読み取る
- **UnpackContent** Zipファイルを解凍する
- **ControlRate** フローを流れるフローファイルのレートを制御する
- **EvaluateXPath(x2)** XMLファイルからノード(要素、属性、その他)を抽出する
- **SplitXml** XMLファイルを複数の親要素の子からなるフローファイルに分割する
- **UpdateAttribute** 各フローファイルにユニークな名前をつける
- **RouteOnAttribute** 車両位置情報データにもとづき、フィルタリングを行う
- **AttributesToJSON** フィルタリングした属性をJSONフォーマットで表現する
- **MergeContent** 複数のフローファイルをJSONコンテンツを結合し単一のフローファイルにマージする
- **PutFile** 車両位置情報データをローカルファイルシステム上のディレクトリに書き込む

上記各プロセッサの詳細を学ぶには、[NiFi's Documentation](https://nifi.apache.org/docs.html)を参照してください。

### 1.1 学習の目的: データフロー作成プロセスの概要

- 移動データの取込、フィルタ、変換、保存を行うNiFiデータフローを構築する
- 各プロセッサのリレーションシップ、コネクションを設定する
- 問題が発生したら解決する
- NiFiデータフローを実行する

これから作成するデータフローでは、表 1に示す計測データから次のXML属性を抽出します。
EvaluateXPathを利用した抽出方法は、データフロー作成時に説明します。

**表 1: 計測データから抽出するXML属性**

|属性名|型|コメント|
|-----|----|------|
|id|string|Vehicle ID|
|time|int64|Observation timestamp|
|lat|float64|Latitude (degrees)|
|lon|float64|Longitude (degrees)|
|speedKmHr|float64|Vehicle speed (km/h)|
|dirTag|float64|Direction of travel|

データを抽出、フィルタ、変換した後、計測位置データを保持する新しいファイルが、表2に示すInput Directoryに保存されます。
RouteOnAttribute、AttributesToJSON、PutFileプロセッサを利用して表2の条件を満たす方法は後で学習します。

**表 2: その他のデータフロー要件**

|パラメータ|値|
|---------|----|
|Input Directory|/tmp/nifi/input|
|Output Directory|/tmp/nifi/output/filtered_transitLoc_data|
|File Format|JSON|
|Filter For|id, time, lat, lon, speedKmHr, dirTag|

計測センサーデータをSan Francisco MuniのM-Ocean Viewルートから取得、フィルタ、変換、保存するデータフローを構築しましょう。
Traffic XMLシミュレータを利用してNiFiが生成したデータをNextBusとGoogleによって可視化すると、以下の画像のようになります:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/live_stream_sf_muni_nifi_learning_ropes.png)


### 1.2 プロセッサの追加

1. **components**ツールバーのプロセッサアイコン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/processor_nifi_iot.png)をグラフへドラッグアンドドロップします。

**Add Processor**ウィンドウが表示され、**プロセッサ一覧**、**タグクラウド**、**フィルタバー**の3つの方法で目的のプロセッサを探します

- プロセッサ一覧: 約180のプロセッサがあります
- タグクラウド: カテゴリで絞り込みます
- フィルタバー: 目的のプロセッサを検索します

2. **GetFile**プロセッサを選択すると、簡潔なプロセッサの機能の説明が表示されます。

- **GetFile**はディレクトリ内の車両位置シミュレータデータファイルを取得します。

**Add**ボタンをクリックし、プロセッサをグラフに追加します。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/add_processor_getfile_nifi-learn-ropes.png)

3. **UnpackContent, ControlRate, EvaluateXPath, SplitXML, UpdateAttribute, EvaluateXPath, RouteOnAttribute, AttributesToJSON, MergeContent, PutFile**プロセッサをプロセッサアイコンを使って追加します。

本データフローにおける各プロセッサの役割は以下のとおりです:

- **UnpackContent** 交通シミュレータZipファイルからフローファイルのコンテンツを解凍します。
- **ControlRate** 交通シミュレータを実行するプロセッサのフローファイルがフローへと転送されるレートを制御します。
- **EvaluateXpath** 各フローファイルが返す車両位置データの最終更新タイムスタンプを抽出します。
- **SplitXML** 親の子要素を複数のフローファイルに分割します。XMLファイル内に車両情報が子要素として含まれるので、各車両要素を個別に保存します。
- **UpdateAttribute** 各フローファイルの名称属性を更新します。
- **EvaluateXpath** 各フローファイルの車両要素から属性を抽出します: 車両ID、方向、緯度、軽度、速度
- **RouteOnAttribute** 車両ID、速度、緯度、軽度、タイムスタンプ、方向がフィルタ条件に一致する場合のみ、フローファイルを後続のフローに流します。
- **AttributesToJSON** フローファイルから属性を抽出し、JSON形式に変換することで、XMLから選択した属性のみのJSON形式を生成します。
- **MergeContent** フローファイルの数をもとに、JSONフローファイルのグループをマージし、単一のフローファイルにまとめます。
- **PutFile** フローファイルのコンテンツをローカルファイルシステム上の指定したディレクトリに書き込みます。

前述の手順に従って、これらのプロセッサを追加します。次の画像のようになります:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/added_processors_nifi_part1.png)

> 注: プロセッサに関する詳細情報を得るには、ExecuteProcessを右クリックし、**usage**を選択します。アプリケーション内にウィンドウが開き、プロセッサのドキュメンテーションが表示されます。また、プロセッサグループの背景として色付きのラベルを利用する方法は**付録 B**を参照してください。

1.3 一般的なプロセッサの問題を解決する

先程の画像内にある9つのプロセッサの左上には、ワーニングシンボル![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/warning_symbol_nifi_iot.png)が表示されているのに気づいたでしょうか。これらのワーニングシンボルはプロセッサが不正であることを示しています。

1. 問題を解決するには、プロセッサ上でホバリングします、例えば、**GetFile**プロセッサ上でホバリングすると、警告メッセージが表示されます。
このメッセージはこのプロセッサを実行するために必要な情報を示しています。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/warning_getFile_processor_nifi_lab1.png)

このワーニングメッセージは、プロセッサがデータを取得するディレクトリパスを指定する必要があり、リレーションシップを確立するコネクションが必要であることを示しています。
各プロセッサには各々のアラートメッセージがあります。すべてのワーニングメッセージを除去し、実行可能なデータフローとするために各プロセッサを設定し、接続しましょう。

1.4 プロセッサを設定し接続する

いくつかのプロセッサを追加しました、これらのプロセッサを**Configure Processor**ウィンドウで設定します。ウィンドウには4つのタブ: **Settings, Scheduling, Properties, Comments**があります。
主にPropertiesタブで、プロセッサが正しく動作するために必要な情報を設定することになります。
太字で表示されているプロパティはプロセッサを正しく設定するために必須のプロパティです。
特定のプロパティの詳細情報は、プロパティ名の隣に表示されている![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/question_mark_symbol_properties_config_iot.png)ヘルプアイコン上にマウスをホバリングすると、プロパティの説明が表示されます。
各プロセッサを設定すると同時に、各プロセッサをリレーションシップで接続し、データフローを完成させましょう。

プロセッサの設定、接続について詳しく知るには、[Hortonworks Apache NiFi User Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_UserGuide/content/ch_UserGuide.html)のBuilding a DataFlow: section 6.2, 6.5を参照してください。


## Step 2: XMLシミュレータデータフローセクションの作成

### 2.1 GetFile

1. [trafficLocs_data_for_simulator.zip](https://github.com/hortonworks/tutorials/blob/hdp/assets/learning-ropes-nifi-lab-series/trafficLocs_data_for_simulator.zip?raw=true)をダウンロードします。

### オプション 1: Sandbox上でNiFiを実行

**Sandbox上でNiFiを実行**する場合、shellへSSH接続します。(ローカルマシンの場合は次のセクションへ):

```
ssh root@127.0.0.1 -p 2222
```

新規の`/tmp/nifi/input`ディレクトリを作成し、zipファイルをSandboxに以下のコマンドで転送しましょう:

```
mkdir -p /tmp/nifi/input
exit
scp -P 2222 ~/Downloads/trafficLocs_data_for_simulator.zip root@localhost:/tmp/nifi/input
```

### オプション 2: ローカルマシン上でNiFiを実行

**ローカルマシン上でNiFiを実行**する場合、新規フォルダ`/tmp/nifi/input`を以下のコマンドで作成します:

```
mkdir -p /tmp/nifi/input
cp ~/Downloads/trafficLocs_data_for_simulator.zip /tmp/nifi/input
```

**GetFile**プロセッサを右クリックし、**configure**をドロップダウンメニューから選択します。
![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/configure_processor_nifi_iot.png)

**表 3**: 更新するGetfileのプロパティ

|プロパティ|値|
|---------|----|
|Input Directory|/tmp/nifi/input|
|Keep Source File|true|


- **Input Directory** データフローへと取り込むデータの場所
- **Keep Source File** ディレクトリ内のソースファイルをデータ取り込み後も残すか否か

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/getFile_config_property_tab_window.png)

**画像 3**: GetFileのConfiguration Propertyタブウィンドウ

3. これで各プロパティが更新されました。**Schedulingタブ**を表示し、**Run Schedule**を0 secから`1 sec`に変更します、このプロセッサは1秒ごとに実行されるようになります。システムリソースを過度に利用することを避けるためです。

4. 必須の項目を更新したので、**Apply**をクリックします。**GetFile**から矢印のアイコンを**UnpackContent**プロセッサにドラッグして接続します。Create Connectionウィンドウが表示されたら、**success**のチェックボックスがチェックされていることを確認してください。チェックされていない場合はチェックし、Addをクリックします。

### 2.2 UnpackContent

1. プロセッサ設定の**Properties**タブを開きます。表4に示すプロパティを追加します、すでに値が設定されている場合は上書きしてください。

**表 4**: 更新するUnpackContentプロパティの値

|プロパティ|値|
|---------|----|
|Packaging Format|zip|

- **Packaging Format** ファイル作成時に利用された圧縮形式を指定します。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/unpackContent_config_property_tab_window.png)

**画像 4**: UnpackContent Configuration Property Tab Window

2. プロセッサ設定の**Settings**タブを表示し、Auto terminate relationshipsにある**failure**と**original**をチェックし、**Apply**をクリックします。

3. **UnpackContent**を**ControlRate**に接続します。Create Connectionウィンドウが表示されたら、**success**がチェックされていることを確認し、されていない場合はチェックして、Addをクリックします。

### 2.3 ControlRate

1. プロセッサ設定の**Properties**タブを開きます。表5に示すプロパティを追加します、すでに値が設定されている場合は上書きしてください。


**表 5**: 更新するControlRateプロパティの値

|プロパティ|値|
|---------|----|
|Rate Control Criteria|flowfile count|
|Maximum Rate|1|
|Time Duration|6 second|

- **Rate Control Criteria** 転送する前にフローファイルの数をカウントするようにします。
- **Maximum Rate** 一度に1フローファイルずつ転送するようにします。
- **Time Duration** 6秒ごとに1フローファイルだけこのプロセッサから転送されるようにします。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/controlRate_config_property_tab_window.png)

**画像 5**: ControlRate Configuration Property Tab Window

2. プロセッサ設定の**Settings**タブを表示し、Auto terminate relationshipsにある**failure**をチェックし、**Apply**をクリックします。

3. **ControlRate**を**EvaluateXPath**に接続します。Create Connectionウィンドウが表示されたら、**success**がチェックされていることを確認し、されていない場合はチェックして、Addをクリックします。


## Step 3: 重要属性抽出データフローセクションの作成

### 3.1 EvaluateXPath

1. プロセッサ設定の**Properties**タブを開きます。表6に示すプロパティを追加します、すでに値が設定されている場合は上書きしてください。
表6の二つ目のプロパティは、**New Property**ボタンを選択して、XPath式の新規ダイナミックプロパティを追加します。以下の表にあるプロパティ名と値をプロパティタブで入力します:

**表 6**: 更新するEvaluateXPathプロパティの値

|プロパティ|値|
|---------|----|
|Destination|flowfile-attribute|
|Last_Time|//body/lastTime/@time|

- **Destination** XPath式の評価結果をフローファイルの属性として保存します。
- **Last_Time** XMLファイルからtimeノードの値を取得する、フローファイルの属性とXPathの式です。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/evaluateXPath_config_property_tab_window.png)

**画像 6**: EvaluateXPath Configuration Property Tab Window

2. プロセッサ設定の**Settings**タブを表示し、Auto terminate relationshipsにある**failure**と**unmatched**をチェックし、**Apply**をクリックします。

3. **EvaluateXPath**を**SplitXML**に接続します。Create Connectionウィンドウが表示されたら、**matched**がチェックされていることを確認し、されていない場合はチェックして、Addをクリックします。

### 3.2 SplitXML

1. SplitXMLの**Properties**設定はデフォルトのままとします。

2. プロセッサ設定の**Settings**タブを表示し、Auto terminate relationshipsにある**failure**と**original**をチェックし、**Apply**をクリックします。

3. **SplitXML**を**UpdateAttribute**に接続します。Create Connectionウィンドウが表示されたら、**split**がチェックされていることを確認し、されていない場合はチェックして、Addをクリックします。

### 3.3 UpdateAttribute

1. **New property**ボタンをクリックし、NiFiエクスプレッション用に新規のダイナミックプロパティを追加します。
以下の表のプロパティ名と値をプロパティタブから追加してください:

**表 7**: 追加するUpdateAttributeプロパティの値

|プロパティ|値|
|---------|----|
|filename|${UUID()}|

- **filename** 各フローファイルにユニークな識別子を付与します

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/updateAttribute_config_property_tab_window.png)

**画像 7**: UpdateAttribute Configuration Property Tab Window

2. **UpdateAttribute**を**EvaluateXPath**に接続します。Create Connectionウィンドウが表示されたら、**success**がチェックされていることを確認し、されていない場合はチェックして、Addをクリックします。

### 3.4 EvaluateXPath

1. プロセッサ設定の**Properties**タブを開きます。表8に示すプロパティを設定します、すでに値が設定されている場合は上書きしてください。
表8のその他のプロパティは**New property**ボタンをクリックして、XPath式用のダイナミックプロパティを追加します。
下記表の次のプロパティ名と値をプロパティタブから追加してください:

**表 8**: 更新するEvaluateXPathプロパティの値

|プロパティ|値|
|---------|----|
|Destination|flowfile-attribute|
|Direction_of_Travel|//vehicle/@dirTag|
|Latitude|//vehicle/@lat|
|Longitude|//vehicle/@lon|
|Vehicle_ID|//vehicle/@id|
|Vehicle_Speed|//vehicle/@speedKmHr|

- **Destination** XPath式の結果をフローファイルの属性に保存するため、flowfile-attributeを設定します。 
- **5つのユーザ定義属性** 次のプロセッサでNiFiエクスプレッションフィルタリングの条件に利用する値を保持します。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/evaluateXPath_extract_splitFlowFiles_config_property_tab.png)

**画像 8**: EvaluateXPath Configuration Property Tab Window

2. プロセッサ設定の**Settings**タブを表示し、Auto terminate relationshipsにある**failure**と**unmatched**をチェックし、**Apply**をクリックします。

3. **EvaluateXPath**を**RouteOnAttribute**に接続します。Create Connectionウィンドウが表示されたら、**matched**がチェックされていることを確認し、されていない場合はチェックして、Addをクリックします。


## Step 4: フィルタ&JSON変換データフローセクションの作成

### 4.1 RouteOnAttribute

1. プロセッサ設定の**Properties**タブを開きます。
**New property**ボタンを選択して新規ダイナミックプロパティを追加します。
以下の表に示すとおり、プロパティ名と値をプロパティタブから追加してください:

**表 9**: 更新するRouteOnAttributeプロパティの値

|プロパティ|値|
|---------|----|
|Filter_Attributes|${Direction_of_Travel:isEmpty():not():and(${Last_Time:isEmpty():not()}):and(${Latitude:isEmpty():not()}):and(${Longitude:isEmpty():not()}):and(${Vehicle_ID:isEmpty():not()}):and(${Vehicle_Speed:equals('0'):not()})}|

- **Filter_Attributes** XPath式で取得したフローファイルの属性値を利用し、少なくともひとつの属性が空であるか、speed属性が0のフローファイルをフィルタアウトします。そうでないフローファイルは後続のプロセッサに渡されます。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/routeOnAttribute_config_property_tab_window.png)

**画像 9**: RouteOnAttribute Configuration Property Tab Window

2. プロセッサ設定の**Settings**タブを表示し、Auto terminate relationshipsにある**unmatched**をチェックし、**Apply**をクリックします。

3. **RouteOnAttribute**を**AttributesToJSON**に接続します。Create Connectionウィンドウが表示されたら、**Filter_Attributes**がチェックされていることを確認し、されていない場合はチェックして、Addをクリックします。

### 4.2 AttributesToJSON

1. プロセッサ設定の**Properties**タブを開きます。表10に示すプロパティを追加します、すでに値が設定されている場合は上書きしてください。


**表 10**: 更新するAttributesToJSONプロパティの値

|プロパティ|値|
|---------|----|
|Attributes List|Vehicle_ID, Direction_of_Travel, Latitude, Longitude, Vehicle_Speed, Last_Time|
|Destination|flowfile-content|

- **Attribute List** パラメータで指定したフローファイル属性をJSON形式で出力します
- **Destination** 出力をフローファイルのコンテンツに保存します

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/attributesToJSON_config_property_tab_window.png)

**画像 10**: AttributesToJSON Configuration Property Tab Window

2. プロセッサ設定の**Settings**タブを表示し、Auto terminate relationshipsにある**failure**をチェックし、**Apply**をクリックします。

3. **AttributesToJSON**を**MergeContent**に接続します。Create Connectionウィンドウが表示されたら、**success**がチェックされていることを確認し、されていない場合はチェックして、Addをクリックします。

### 4.3 MergeContent

1. プロセッサ設定の**Properties**タブを開きます。表11に示すプロパティを追加します、すでに値が設定されている場合は上書きしてください。


**表 11**: 更新するControlRateプロパティの値

|プロパティ|値|
|---------|----|
|Minimum Number of Entries|10|
|Maximum Number of Entries|15|
|Delimiter Strategy|Text|
|Header|[|
|Footer|]|
|Demarcator|, {now-press-shift-enter}|

- **Minimum Number of Entries** 少なくとも指定した数のフローファイルを待ち受け、それらを単一のフローファイルにマージします
- **Maximum Number of Entries** 指定した数を超えるフローファイルは受け付けず、それらをマージします
- **Delimiter Strategy** ヘッダ、フッタとDemarcatorのフォーマット条件をTextに指定します
- **Header** ファイルの先頭に指定の値を挿入します
- **Footer** ファイルの末尾に指定の値を挿入します
- **Demarcator** ファイル内の各行の末尾に指定の値を挿入します

2. プロセッサ設定の**Settings**タブを表示し、Auto terminate relationshipsにある**failure**と**original**をチェックし、**Apply**をクリックします。

3. **MergeContent**を**PutFile**に接続します。Create Connectionウィンドウが表示されたら、**merged**がチェックされていることを確認し、されていない場合はチェックして、Addをクリックします。

### 4.4 PutFile

1. プロセッサ設定の**Properties**タブを開きます。表12に示すプロパティを追加します、すでに値が設定されている場合は上書きしてください。


**表 12**: 更新するPutFileプロパティの値

|プロパティ|値|
|---------|----|
|Directory|/tmp/nifi/output/filtered_transitLoc_data|

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/putFile_config_property_tab_window.png)

**画像 12**: PutFile Configuration Property Tab Window

2. プロセッサ設定の**Settings**タブを表示し、Auto terminate relationshipsにある**failure**と**success**をチェックし、**Apply**をクリックします。

## Step 5: NiFiデータフローの実行

1. ワーニングシンボルが消えたらプロセッサが正常に設定できています。
プロセッサには赤いストップシンボル![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/stop_symbol_nifi_iot.png)が左上に表示され、実行の準備ができています。
すべてのプロセッサを選択するには、**シフトキー**を押しながら、データフロー全体をマウスでドラッグします。

2. すべてのプロセッサを選択したら、actionsツールバーのスタートボタン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/start_button_nifi_iot.png)をクリックします。画面は以下の画像のようになっているはずです:

  ![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/run_dataflow_lab1_nifi_learn_ropes.png)

3. プロセッサが何をしているのか、また表示情報を素早く確認するには、グラフを右クリックして、**refresh status**ボタン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/refresh_nifi_iot.png)をクリックします。

### ターミナルからデータを確認 (オプション 1)

4. ファイルにデータが書き込まれたか確認するには、ターミナルを開くか、NiFiのデータ来歴(Data Provenance)を利用します。
PutFileプロセッサで指定したディレクトリに移動します。
ファイルの一覧を確認し、最も新しく作成されたファイルを開き、フィルタリングされた計測データを確認しましょう。
チュートリアルでは、出力ディレクトリパスは: `/tmp/nifi/output/filtered_transitLoc_data`を使用しました。

```
cd /tmp/nifi/output/filtered_transitLoc_data
ls
vi 22169558941607
```

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/commands_enter_sandbox_shell_lab1.png)

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/filtered_vehicle_locations_data_nifi_learn_ropes.png)

> 注: viエディタを終了するには`esc`を押し、`:q`を入力します。

### NiFiデータ来歴でデータを確認する (オプション 2)

データ来歴はNiFiの特徴的な機能で、フローファイルがデータフローを移動中でも、任意のプロセッサやコンポーネントからデータを確認できます。
データ来歴はデータフロー内で起こり得る問題を解決するのに優れたツールです。
このセクションでは、PutFileプロセッサのデータ来歴を確認してみましょう。

1. PutFileプロセッサを右クリックします。`Data Provenance`を選択します。ドロップダウンメニューの4番目です。

2. NiFiはデータ来歴イベントを検索します。ウィンドウにロードされたイベントのいずれかを選択します。
イベントはプロセッサを通過したフローファイルであり、その時点のデータが確認できます。
チュートリアルでは、![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/i_symbol_nifi_lab1.png)シンボルをクリックして、はじめのイベントを選択してみましょう。

データ来歴ウィンドウが表示されます:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/provenance_event_window_lab1.png)

3. イベントを選択したら、データ来歴イベントダイアログウィンドウが表示されます。特定のイベントに関連する詳細、属性とコンテンツが表示されます。各タブを見てみましょう。
`Content`タブを選択し、フローファイルから生成されたデータを閲覧します。
NiFiではイベントのコンテンツをダウンロード、もしくは閲覧できます。
**View**ボタンをクリックしてみましょう。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/provenance_content_tab_lab1.png)

4. NiFiではデータを複数のフォーマットで閲覧できます。オリジナルのフォーマットで見てみましょう。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/event_content_view_window_lab1.png)

期待通りの結果が得られましたか?

## まとめ

おめでとうございます！チュートリアルの最後までたどり着き、NextBus.comからのライブストリームシミュレーションを取り込み、XMLの子要素を複数のフローファイルに分割し、XMLファイルからノードを抽出し、属性に応じてフィルタリングを行い、新規の加工したファイルを保存するNiFiデータフローが構築できました。
NiFiデータ来歴の機能でプロセッサを通過したフローファイルからデータを閲覧する方法も学習しました、リアルタイムに起こる問題を解決する際にとても強力な機能です。
他のチュートリアルでも自由に使ってみてください。
もっとNiFiについて詳しく知りたい場合は、以降のセクションをご覧ください。

## 付録 A: NiFiデータフローレビュー

たった今作成したデータフローについてより深く理解したい方は、以下の情報をご覧いただき、次のチュートリアルへ進んでください。

車両位置XMLシミュレーションセクション:
ローカルディスク上のファイル内コンテンツをNiFiへとストリームします、Zipファイルを展開し、各ファイルをフローファイルとして転送します、以降のフローにデータを転送するレートを制御します。

フローファイル属性の抽出セクション:
XMLメッセージを複数のフローファイルに分割し、各フローファイルのファイル名属性をユニークな名前で更新し、ユーザ定義のXPath式をXMLコンテンツに対して評価した結果を指定した属性名で保持します。

主要属性JSON変換セクション:
すべてのXPath式の結果を保持するかどうかでフローファイルをルーティングし、入力属性をJSON形式でフローファイルのコンテンツとし、フローファイルのコンテンツをマージして単一のフローファイルとし、フローファイルのコンテンツをローカルファイルシステムに直接書き出します。

## 付録 B: プロセッサグループのラベル作成

NiFiデータフローが成長すると、巨大なデータ処理パイプラインとなります。
巨大なデータフローでは、特定のデータフローセクションがデータに対して行うアクションを理解するのが難しくなります。
データフローの様々なフェーズを理解しやすくするためにラベルを利用すると良いでしょう。

データフローの第一フェーズで起こるアクションを表すラベルを作成しましょう。

1. componentsツールバーにあるラベルアイコン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/label_icon_lab1.png)をキャンバスにドラッグし、右隅をホバリングすると矢印が現れます、先端をクリックしてプロセッサのグループを囲うようにドラッグします。

2. ラベルを右クリックし、configureをクリックします。ラベル設定ウィンドウが表示されます。
Label Valueフィールドをクリックし、`Generate Vehicle Location XML Simulator`をデータフローの第一フェーズの名とします。
フォントサイズを`18px`に指定します。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/label_first_phase_dataflow_lab1.png)

本チュートリアルのデータフローと同様のラベルを作成したい場合、Step 5のデータフロー画像を参考にしてください。
データフローの各フェーズのラベルも自由に作成してみてください。

## より理解を深めるために

- [Apache NiFi](http://hortonworks.com/apache/nifi/)
- [Hortonworks DataFlow Documentation](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2/bk_UserGuide/content/index.html)
- [NiFi Expression Language Guide](https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html)
- [XPath Expression Tutorial](http://www.w3schools.com/xsl/xpath_intro.asp)
- [JSON Tutorial](http://www.w3schools.com/json/)

---

[前へ](Ropes-of-Apache-NiFi-Tutorial-0.md) | [次へ](Ropes-of-Apache-NiFi-Tutorial-2.md)
