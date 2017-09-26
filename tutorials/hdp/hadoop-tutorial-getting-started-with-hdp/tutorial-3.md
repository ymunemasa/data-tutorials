# Lab 2：Hiveでデータ操作をしよう
## はじめに

このチュートリアルでは，Apache（TM）Hiveについて紹介します．前のセクションでは，HDFSにデータを読み込ませる方法について説明しました．これで，GeolocationとTrucksがcsvファイルとしてHDFSに保存されました．このデータをHiveで利用するために，テーブルを作成する方法とデータの照会可能な場所からHiveウェアハウスに移動する方法を解説します．Hive User ViewsでSQLクエリを利用してこのデータを分析し，それをORCとして保存します．また実行エンジンにTezを指定した場合の，Apache TezとDAGの作成方法についても解説します．それでは始めましょう！

## Hive - Data ETL

## 前提条件

このチュートリアルは，Hortonworks Sandboxを利用して，HDPに入門するための一連のチュートリアルの一部です．このチュートリアルを進める前に，以下の条件を満たしていることを確認してください．

- [Hortonworks Sandboxの使い方を学習している](https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
- Hortonworks Sandbox
- Lab 1：センサデータをHDFSに読み込ませよう
- このチュートリアルを完了するのに1時間ほど掛かります．

## 概要
- [Apache Hiveの基礎](#hive-basics)
- [Step 2.1：Ambari Hive Viewに慣れる](#step2.1)
- [Step 2.2：Hiveテーブルを定義する](step2.2)
- [Step 2.3：AmbariダッシュボードでHiveの設定を探索する](#step2.3)
- [Step 2.4：トラックのデータを分析する](#step2.1)
- [まとめ](#summary)
- [参考文献](#further-reading)

## Apache Hiveの基礎 <a id="hive-basics"></a>

Apache Hiveは，Hadoopと統合された様々なデータベースやファイルシステムに格納されたデータを照会するためのSQLインターフェースを提供します．Hiveを利用すると，SQLに慣れている方は，大量のデータに対してクエリを実行できます．Hiveには主に，データの要約，クエリ，分析の3つの機能があります．またHiveは，簡単なデータ抽出（Extraction）や変換（Transformation），ローディング（Loading）を可能にする（ETL）ツールを提供します．


## Step 2.1：Ambari Hive Viewに慣れる <a id="step2.1"></a>

Apache Hiveは，HDFS内のデータのリレーショナル・ビューを提供します．Hiveは，データが格納されているファイル形式にかかわらず，Hiveで管理されている表形式，またはHDFSに格納されている表形式でデータを表示することができます．Hiveは，RCFileフォーマットやテキストファイル，ORC，JSON，Parquet，シーケンスファイルなど多くのフォーマットを表形式で照会することができます．SQLを利用することで，データをテーブルとして表示させ，RDBMSのようにクエリを作成することができます．

Hiveとのやり取りを簡単にするために，Hortonworks SandboxのAmbari Hive Viewというツールを利用しています．[Ambari Hive View 2.0](https://docs.hortonworks.com/HDPDocuments/Ambari-2.5.0.3/bk_ambari-views/content/ch_using_hive_view.html)は，Hiveへのインタラクティブなインターフェースを提供します．クエリの作成や編集，保存，実行をすることができ，MapReduceジョブまたはTezジョブを利用して，Hiveに評価させることができます．

それではAmbari Hive View 2.0を開いて，その環境を体験してみましょう．Ambari User Viewアイコンのメニューから，Hive View 2.0を選択します．


![](assets/lab2/lab2-1.png)


Ambari Hive Viewは以下のようになります．


![](assets/lab2/lab2-2.png)


次に，Hive ViewのSQL編集機能を詳しく見ていきましょう．

- SQLを利用するための6つのタブがあります．
  - QUERY：これは先程の画像で示したメインのインターフェースであり，新しいSQL文の記述や編集，実行をすることができます．
  - JOBS：過去のクエリや現在実行中のクエリを確認することができます．また，表示可能な全てのSQLクエリを表示させることもできます．例えば，管理者や分析者がクエリのヘルプを必要とするとき，Hadoop管理者は履歴機能を利用してレポートツールから送信されたクエリを表示させることができます．
  - TABLES：選択したデータベースのテーブルを表示や作成，削除および管理するための中心地を提供します．
  - SAVED QUERIES：現在のユーザによって保存された全てのクエリを表示します．クエリの履歴を表示または削除するには，クエリのリストの右側にある歯車アイコンをクリックします．
  - UDFs：HDFS上のJARファイルとUDF定義を含むJavaのClassPathを示すことで，ユーザ定義関数（UDFs：User-defined functions）をクエリに追加できます．ここにUDFを追加すると，UDF挿入ボタンがクエリエディタに表示され，UDFをクエリに追加できます．
  - SETTINGS：Hive Viewで実行するクエリに設定を追加できます．

様々なHive Viewの機能を調べるためには数分掛かることでしょう．

**Step 2.1.1：hive.execution.engineをTezに設定する**

Hiveのクエリを実行する前に，実行エンジンをTezとして設定します．MapReduceを利用することもできますが，このチュートリアルではTezを利用します．

1. 上記の6番目のタブである歯車アイコンのSETTINGタブをクリックします．
2. **+Add New**をクリックし，ドロップダウンメニューからキーを`hive.execution.engine`に，値を`tez`に設定します．


![](assets/lab2/lab2-3.png)


## Step 2.2：Hiveテーブルを定義する <a id="step2.2"></a>

Hive Viewに慣れてきたので，GeolocationとTrucksのテーブルを作成して，それらのデータを読み込んでみましょう．このセクションでは，Ambari Hive Viewを利用して，2つのテーブルを作成する方法を学習します．Upload Tableタブには入力ファイルの種類，ストレージのオプション（Apache ORCなど），最初の行をヘッダーとして設定するなどのオプションがあります．以下の図は，テーブルといくつかのステップを通して行われる読み込みの過程を視覚的に示しています．


![](assets/lab2/lab2-4.png)

**Step 2.2.1：初期ロード段階用のトラックデータの作成と読み込み**

まずはHive View 2.0の画面から，

1. **NEW TABLE**を選択し，
2. さらに**UPLOAD TABLE**を選択します．


![](assets/lab2/lab2-5.png)

HDFSのPathに`/user/maria_dev/data/trucks.csv`を，テーブル名に`trucks`を入力して，**Preview**をクリックします．


![](assets/lab2/lab2-6.png)


同様の画面を確認できるはずです．画像の通りにチェックを選択し，進めてください．

注：最初の行には列の名前が含まれています


![](assets/lab2/lab2-7.png)


**Create**ボタンをクリックして，テーブルの作成を完了します．
アップロードの進捗状況で何が起こっているのか確認する前に，Hiveのファイル形式について学習しましょう．

**Step 2.2.2：Apache ORCファイル形式を利用して，Hive CreateテーブルにORCテーブルを定義する**

[Apache ORC](https://orc.apache.org/)は，Hadoopワークロードのための高速なカラムナストレージファイル形式です．

The Optimized Row Columnar（new Apache ORC project）ファイル形式は，Hiveデータを効率的に格納する方法を提供します．他のHiveファイル形式の制約を改善するように設計されています．ORACファイルを利用すると，Hiveのデータの読み込みや書き込み，および処理のパフォーマンスが向上します．

ORC形式を利用するには，表を作成するときにファイル形式としてORCを指定します．以下に例を示します．

```sql
CREATE TABLE … **STORED AS ORC**
CREATE TABLE trucks STORED AS ORC AS SELECT * FROM trucks_temp_table;
```

同様の形式のcreate文は，`UPLOAD TABLE`プロセスで利用される一時的なテーブルとしても利用されます．

**Step 2.2.3：アップロードテーブルの進捗状況の確認**

最初に`trucks`のテーブルが作成され，一時テーブルに`trucks.csv`が読み込まれます．一時テーブルは，前の手順で説明した構文を利用して，ORC形式でデータを作成および読み込むために利用されます．データが最終テーブルに読み込まれると一時テーブルは削除されます．


![](assets/lab2/lab2-4.png)


注：一時テーブル名はランダムな文字セットであり，上記の図のような名前ではありません．

**JOBS**タブを選択して，`Upload Table`の結果として実行された4つの内部ジョブをクリックすると，発行されたSQL文を確認できます．


![](assets/lab2/lab2-8.png)


**Step 2.2.4：Geolocationテーブルの作成と読み込み**

上記の手順を`geolocation.csv`で繰り返して，ORCファイル形式のgeolocationテーブルを作成して読み込みます．

**Step 2.2.5：Hive CREATE TABLE 文**

上記で生成，発行されたCREATE TABLE文を確認してみましょう．SQLのバックグラウンドを知っているなら，この構文はカラム定義の後の3行を除いて非常によく似ていることがわかるはずです．

- ROW FORMAT句は，各行が改行文字で終わることを指定します．
- FIELDS TERMINATED BY句は、テーブルに関連付けられたフィールド（ここでは2つのcsvファイル）をコンマで区切ることを指定します。
- STORED AS節は、表がTEXTFILE形式で保管されることを指定します。

注：これらの詳細については、[Apache Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL)を参照してください。

**Step 2.2.6：新しいテーブルが存在することを確認する**

テーブルが正常に定義されたことを確認するには，

1. **TABLES**タブをクリックします．
2. **TABLES**エクスプローラの更新アイコンをクリックします．
3. 確認したいテーブルを選択すると，列の定義が表示されます．


![](assets/lab2/lab2-9.png)


**Step 2.2.7：trucksテーブルのサンプルデータ**

**QUERY**タブをクリックし，クエリエディタに以下のクエリを入力して**Execute**をクリックします．

```sql
select * from trucks limit 100;
```

結果は以下のようになります．


![](assets/lab2/lab2-10.png)

テーブルを検索するためのいくつかの追加コマンド：

- `show tables;` - HCatalogdescribeに格納されているメタデータからテーブルの一覧を参照して，データベースに作成されたテーブルを一覧表示します．
- `describe {table_name};` - 特定のテーブルの列の一覧を表示します

```sql
describe geolocation;
```

- `show create table {table_name};` - テーブルを作成するためのDDLを表示します．

```sql
show create table geolocation;
```

- `descriebe formatted {table_name};` - テーブルに関する追加のメタデータを表示します．例えば，GeolocationがORCテーブルであることを確認するには，以下のクエリを実行します．

```sql
describe formatted geolocation;
```

デフォルトでは，Hiveでテーブルを作成すると，同じ名前のディレクトリがHDFSの`/apps/hive/warehouse`に作成されます．Ambari File Viewを利用して，`/apps/hive/warehouse`ディレクトリに移動します．`geolocation`と`trucks`ディレクトリの両方が表示されます．

注：Hiveテーブルとその関連メタデータ（すなわち、データが格納されているディレクトリ、ファイル形式、Hiveプロパティが設定されているものなど）の定義は、Sandbox上のMySQLデータベースであるHiveメタストアに格納されます。

**Step 2.2.8 クエリエディタのワークシートの名前を変更する**

ワークシートのタブをダブルクリックして，ラベルの名前を`sample truck data`に変更します．**Save**ボタンをクリックして，このワークシート名を保存します．

![](assets/lab2/lab2-11.png)


**Step 2.2.9：Beeline - コマンドシェル**

これらのコマンドの一部をコマンドラインから実行したい場合は，Beeline Shellを利用できます．BeelineはJDBC接続を利用してHiveServer2に接続します．以下の手順をShell（Windowsの場合はputtyなど）から実行します．


1. Sandbox VMにsshで接続する

    ```bash
    ssh maria_dev@127.0.0.1 -p 2222
    ```
    
	- パスワードは`maria_dev`です
  
2. Beeelineを開始する

    ```
    beeline -u jdbc:hive2://localhost:10000 -n maria_dev
    ```

3. 以下のようなBeelineコマンドを入力する

	```
	!help
	!tables
	!describe trucks
	select count(*) from trucks;
	```

4. Beeline Shellを終了する
    
    ```
    !quit
    ```

ShellからHiveクエリを実行した後のパフォーマンスはどうでしたか？

- Shellからクエリは，Ambari Hive Viewより高速に実行することができます．Shellでの実行はHiveがHadoopに対して直接クエリを実行するのに対して，Ambari Hive ViewではクエリをHadoopに送信する前にRESTサーバを経由する必要があるためです．
- [Beeline from the Hive Wiki](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-Beeline%E2%80%93CommandLineShell)からBeelineに関する情報を得ることができます．
- Beelineは[SQLLine](http://sqlline.sourceforge.net/)をベースにしています．


## Step 2.3：AmbariダッシュボードでHiveの設定を探索する <a id="step2.3"></a>

**Step 2.3.1：新しいタブでAmbarid Dashboardを開く**

Dashboardタブをクリックして，Ambari Dashboardを探検しましょう．

![](assets/lab2/lab2-12.png)


**Step 2.3.2 Hiveの設定に慣れよう**

Hiveページに移動，**Configs**タブを選択し，**Settings**タブをクリックします．

![](assets/lab2/lab2-13.png)

Hiveページをクリックすると，上記と同様のページが表示されます．

1. Hive ページ
2. Hive Config タブ
3. Hive Settings タブ
4. 設定バージョン履歴

下にスクロールして，最適化設定をします．

![](assets/lab2/lab2-14.png)


上記のスクリーンショットでは，

1. **Tez**が最適化エンジンとして設定されている
2. **コストベースオプティマイザ**（CBO）が有効になっている

これは設定を簡単ににする**HDP Ambari Smart Configurations**を表しています．

- Hadoopは複数のXMLファイルによって構成されています．
- 初期のバージョンでは，管理者は設定を変更するためにXMLを編集する必要がありました．デフォルトのバージョン管理はありませんでした．
- 初期のAmbariインターフェースでは様々なダイアログボックスを使用して設定ページを表示し，それを編集できるようにすることで値を変更していました．しかし，その値を変更するためには値の範囲を理解して知っている必要がありました．
- Smart Configurationsを利用すると，トグルスイッチで機能を切り替えたり，範囲を指定する設定はスライダバーを利用することができます．

デフォルトでは，主要な設定が最初のページに表示されます．目的の設定がこのページに存在しない場合，**Advanced**タブで追加の設定を探すことができます．


![](assets/lab2/lab2-15.png)


例えば，SQLのパフォーマンスを向上させたい場合は，新しいHive Vectorizetion機能を利用できます．これらの設定は次の手順で見つけて有効にすることができます．

1. Advancedタブをクリックし，スクロールしてプロパティを見つけます．
2. またはプロパティの検索フィールドからプロパティの入力をすると，フィルタされて見つけやすくなります．

上記のスクリーンショットの緑色の円から分かるように，`Enable Vectorizetion and Map Vectorization`は既に有効になっています．

Vectorizetionとその他Hiveのチューニング設定について，詳細は下記を御覧ください．

- Apache Hive docs on [Vectorized Query Execution](https://cwiki.apache.org/confluence/display/Hive/Vectorized+Query+Execution)
- [HDP Docs Vectorization docs](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.0.9.0/bk_dataintegration/content/ch_using-hive-1a.html)
- [Hive Blogs](https://hortonworks.com/blog/category/hive/)
- [5 Ways to Make Your Hive Queries Run Faster](https://hortonworks.com/blog/5-ways-make-hive-queries-run-faster/)
- [Interactive Query for Hadoop with Apache Hive on Apache Tez](https://hortonworks.com/hadoop-tutorial/supercharging-interactive-queries-hive-tez/)
- [Evaluating Hive with Tez as a Fast Query Engine](https://hortonworks.com/blog/evaluating-hive-with-tez-as-a-fast-query-engine/)

## Step 2.4：トラックのデータを分析する <a id="step2.4"></a>

次にHiveやPigおよびZeppelinを利用して，GeolocationテーブルとTrucksテーブルから派生データを分析します．ビジネスの目的は，運転者の疲労，過剰利用のトラック，およびリスクを抱える様々な運送のイベントの影響から，会社が負うリスクをより理解を深めることです．そのために，SQLを利用してソースデータを変換し，PigまたはSparkを利用してリスクを計算します．データ視覚化に関する最期の学習では，Zeppelinを利用して一連のチャートを生成し，リスクをより深く理解します．

![](assets/lab2/lab2-16.png)

最初の変換を始めましょう．各トラックの1ガロンあたりのマイル数を計算します．trucksテーブルから始めます．私たちはトラック毎にmileカラムとgasカラムを合計する必要があります．Hiveには，テーブルを再フォーマットできる関数があります，[LATERAL_VIEW](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+LateralView)というキーワードで呼び出すことができます．スタック関数は最大54行をのrdate，gas，mileという3つの列（例：’june13’，june13_miles，june13_gas）にデータを再構築することができます．元のテーブルからtruckid，driveid，rdate，mile，gasを選択し，mpg（マイル/ガス）の計算式を追加します．そして，平均マイル数を計算します．

**Step 2.4.1 既にあるトラッキングデータからtruck_mileageテーブルを作成する**

Ambari Hive User Viewを使って，以下のクエリを実行します．

```sql
CREATE TABLE truck_mileage STORED AS ORC AS SELECT truckid, driverid, rdate, miles, gas, miles / gas mpg FROM trucks LATERAL VIEW stack(54, 'jun13',jun13_miles,jun13_gas,'may13',may13_miles,may13_gas,'apr13',apr13_miles,apr13_gas,'mar13',mar13_miles,mar13_gas,'feb13',feb13_miles,feb13_gas,'jan13',jan13_miles,jan13_gas,'dec12',dec12_miles,dec12_gas,'nov12',nov12_miles,nov12_gas,'oct12',oct12_miles,oct12_gas,'sep12',sep12_miles,sep12_gas,'aug12',aug12_miles,aug12_gas,'jul12',jul12_miles,jul12_gas,'jun12',jun12_miles,jun12_gas,'may12',may12_miles,may12_gas,'apr12',apr12_miles,apr12_gas,'mar12',mar12_miles,mar12_gas,'feb12',feb12_miles,feb12_gas,'jan12',jan12_miles,jan12_gas,'dec11',dec11_miles,dec11_gas,'nov11',nov11_miles,nov11_gas,'oct11',oct11_miles,oct11_gas,'sep11',sep11_miles,sep11_gas,'aug11',aug11_miles,aug11_gas,'jul11',jul11_miles,jul11_gas,'jun11',jun11_miles,jun11_gas,'may11',may11_miles,may11_gas,'apr11',apr11_miles,apr11_gas,'mar11',mar11_miles,mar11_gas,'feb11',feb11_miles,feb11_gas,'jan11',jan11_miles,jan11_gas,'dec10',dec10_miles,dec10_gas,'nov10',nov10_miles,nov10_gas,'oct10',oct10_miles,oct10_gas,'sep10',sep10_miles,sep10_gas,'aug10',aug10_miles,aug10_gas,'jul10',jul10_miles,jul10_gas,'jun10',jun10_miles,jun10_gas,'may10',may10_miles,may10_gas,'apr10',apr10_miles,apr10_gas,'mar10',mar10_miles,mar10_gas,'feb10',feb10_miles,feb10_gas,'jan10',jan10_miles,jan10_gas,'dec09',dec09_miles,dec09_gas,'nov09',nov09_miles,nov09_gas,'oct09',oct09_miles,oct09_gas,'sep09',sep09_miles,sep09_gas,'aug09',aug09_miles,aug09_gas,'jul09',jul09_miles,jul09_gas,'jun09',jun09_miles,jun09_gas,'may09',may09_miles,may09_gas,'apr09',apr09_miles,apr09_gas,'mar09',mar09_miles,mar09_gas,'feb09',feb09_miles,feb09_gas,'jan09',jan09_miles,jan09_gas ) dummyalias AS rdate, miles, gas;
```

![](assets/lab2/lab2-17.png)


**Step 2.4.2：truck_mileageテーブルのデータのサンプリングを調べる**

スクリプトによって生成されたデータを表示するには，クエリエディタで以下のクエリを実行します．

```sql
select * from truck_mileage limit 100;
```

トラックとドライバによって行われた各走行記録の一覧が表示されます．

![](assets/lab2/lab2-18.png)

**Step 2.4.3 Content Assistを使ってクエリを作成する**

1. 新しいSQLワークシートを作成します
2. `SELECT SQL`コマンドで入力を開始します．このとき最初の2文字だけ入力してみましょう．

	```  
	SE
	```

3. Ctrl + Spaceを押すと，コンテンツアシストのポップアップダイアログウィンドウが表示されます．
  
	![](assets/lab2/lab2-19.png)

  注：コンテンツアシストでは，「SE」で始めるオプションが表示されます．これらのショートカットでは，様々なカスタムクエリコードを記述する際に便利です．
  
4. 次のクエリを入力している最中にCtrl+Spaceを利用して，どのような補完ができるか，どのような動作をするか確認することができます．
  
	```
	SELECT truckid, avg(mpg) avgmpg FROM truck_mileage GROUP BY truckid;
	```
	    
	![](assets/lab2/lab2-20.png)
	
	![](assets/lab2/lab2-21.png)

5. **Save**ボタンをクリックして，名前を`average mpg`として保存します．
6. Hive User Viewの上部のタブの`Saved Queries`のリストにクエリが表示されていることを確認します．
7. `average mpg`クエリを実行し，その結果を表示します．

**Step 2.4.4：Hive Query Editorの機能を確かめる**

Visual Explain，Text Explain，Tez Explainの各クエリの実行をよりよく理解するための様々な機能を紹介します．**Visual Explain**ボタンをクリックしましょう．

![](assets/lab2/lab2-22.png)


このvisual explaionは，実行予定のクエリの視覚的な概要を提供します．


![](assets/lab2/lab2-23.png)


文字で説明結果を表示したい場合は**RESULTS**ボタンを選択します．以下のようなものが表示されるはずです．


![](assets/lab2/lab2-24.png)


**Step 2.4.5 TEZを確認する**

Ambari ViewsからTEZ Viewをクリックします．これまでのHiveとPigのジョブに関連する詳細を確認することができます．

![](assets/lab2/lab2-25.png)


実行された最後のジョブを表す，最初の行のDAG IDを選択します．


![](assets/lab2/lab2-26.png)


上部に7つのタブが存在します．**Graphcal View**タブをクリックして，ノードの1つをカーソルでホバーし，そのノードでの処理の詳細を確認します．


![](assets/lab2/lab2-27.png)


**Vertex Swimlane**をクリックします．この機能はTEZジョブのトラブルシューティングに役立ちます．画像にはMap 1とReducer 2のグラフがあります．これらのグラフはイベント発生時のタイムラインです．イベントのツールチップを表示するには，赤または青の線にカーソルを合わせます．

基本的な用語：

- **Bubble**はイベントを表します
- **Vertex**はイベントのタイムライン，実線を表します

map 1では，イベントの頂点の開始と初期化が同時に行われていることをツールチップに表示しています．


![](assets/lab2/lab2-28.png)


Reducer 2では，イベントの頂点の開始と初期化の実行時間にミリ秒の違いがあることをツールチップに表示しています．

初期化

![](assets/lab2/lab2-29.png)


開始

![](assets/lab2/lab2-30.png)


グラフのタスク開始と終了のMap1とReducer1を比較して，何かに気づきましたか？

- Reducer2の前にMap1が始まり，終了します．

**Step 2.4.6：既存のtrucks_mileageデータからテーブルavg_mileageテーブルを作成する**

クエリの結果をテーブルの保存することができます．[Create Table As Select](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableAsSelect)（CTAS）と呼ばれる機能です．以下のDDLをクエリエディタにコピーし，**Execute**をクリックします．

```sql
CREATE TABLE avg_mileage
STORED AS ORC
AS
SELECT truckid, avg(mpg) avgmpg
FROM truck_mileage
GROUP BY truckid;
```

![](assets/lab2/lab2-31.png)


**Step 2.4.7：avg_mileageのサンプルデータを確認する**

上記のCTASによって生成されたデータを表示するには，以下のクエリを実行します．

```sql
SELECT * FROM avg_mileage LIMIT 100;
```

`avg_mileage`テーブルには，各トラックの1ガロンあたりの平均マイルの一覧が表示されます．


![](assets/lab2/lab2-32.png)


**Step 2.4.8：既存のtruck_mileageデータからDriverMileageテーブルを作成する**

次のCTASは，driveidとマイルの合計をレコードでグループ化します．以下のDDLをクエリエディタにコピーし，**Execute**をクリックします．

```sql
CREATE TABLE DriverMileage
STORED AS ORC
AS
SELECT driverid, sum(miles) totmiles
FROM truck_mileage
GROUP BY driverid;
```

![](assets/lab2/lab2-33.png)


**Step 2.4.9：DriveMileageのデータを確認する**

上記のCTASによって生成されたデータを確認するには，以下のクエリを実行します．

```sql
SELECT * FROM drivermileage LIMIT 100;
```

![](assets/lab2/lab2-34.png)

## まとめ <a id="summary"></a>

おめでとうございます！GeolocationデータとTruckデータを処理やフィルタリングの操作をするために学んだHiveコマンドをまとめましょう．`CREATE TABLE`と`UPLOAD TABLE`を利用してテーブルを作成できるようになりました．さらにテーブルのファイル形式をORCに変更する方法を学びました．ORCによって，データを読み取り，書き込み，および処理の効率が向上します．`SELECT`文を利用してデータを取得し，新しいフィルタテーブル（CTAS）を作成する方法を学習しました．


## 参考文献 <a id="further-reading"></a>
- [Apache Hive](https://hortonworks.com/hadoop/hive/)
- [Hive LLAP enables sub second SQL on Hadoop](https://hortonworks.com/blog/llap-enables-sub-second-sql-hadoop/)
- [Programming Hive](http://www.amazon.com/Programming-Hive-Edward-Capriolo/dp/1449319335/ref=sr_1_3?ie=UTF8&qid=1456009871&sr=8-3&keywords=apache+hive)
- [Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL)
- [HDP DEVELOPER: APACHE PIG AND HIVE](https://hortonworks.com/training/class/hadoop-2-data-analysis-pig-hive/)


### [前へ](tutorial-2.md) | [次へ](tutorial-4.md)