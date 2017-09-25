原文: [Apache NiFi Dataflow Automation Concepts](http://hortonworks.com/hadoop-tutorial/learning-ropes-apache-nifi/#section_2)

## Apache NiFi データフローの自動化コンセプト

## はじめに

コンセプトの章は本チュートリアルのハンズオン体験をより充実させるためのものです。
本章を読み終える頃には、NiFiが何であるかを定義でき、特定のユースケースに応じたデータフローの作成方法や、NiFiの主要なコンセプトを理解いただけているでしょう。本章のゴールはNiFiの利用を開始する皆さまの、NiFiドキュメンテーション活用方法の理解を助けることです。

## 概要

- 1. Apache NiFiとは?
- 2. NiFiは誰が、何のために使うもの?
- 3. NiFiデータフロー作成手順を理解する
- 4. NiFiの主要コンセプト
- 5. NiFiの歴史
- さらに理解を深めるために

## 1. Apache NiFiとは?

[Apache NiFi](https://nifi.apache.org/docs/nifi-docs/html/overview.html#what-is-apache-nifi)はシステム間のデータフローを自動化し管理するためのオープンソースのツールです。本チュートリアルでは、センサー、Webサービス間(NextBusとGoogle Places API)、様々なロケーションやローカルファイルシステムを流れるデータをNiFiで処理します。NiFiはデータフローに関する課題に対応し、それらを解決できます。遭遇する課題としては、処理側の性能を超えるデータの扱い、異なる速度でのシステムの進化、コンプライアンスやセキュリティなどがあります。

## 2. NiFiは誰が、何のために使うもの?

NiFiは数多くの様々なデータ・ソースからNiFiへとデータを取り込み、フローファイルを作成することで、**データ統合**に利用できます。チュートリアルでは、GetFile、GetHTTP、InvokeHTTPなどのプロセッサを利用して、ローカルファイルシステムや、インターネットからダウンロードしてNiFiへとデータをストリームします。
データが取り込まれると、データフローマネージャ(DataFlow Manager, DFM)にあたるユーザが、現在のNiFiデータフローの状態をモニタリングし、**データマネージメント**を実行します。
DFMはデータフロー内のコンポーネントを追加、削除、変更します。プロセッサや管理ツールバーに表示される掲示板(bulletin)により、アラートの発生時刻、深刻度、メッセージをツールチップで閲覧でき、データフロー内の問題特定に利用します。
データの運用管理中に、**データのエンリッチメント**を行い、データの質を拡張、洗練、向上し意味付けを行い、ユーザに対する価値を高めます。
NiFiはユーザに対して不必要な情報をデータから除去し、より簡単に理解させることができます。リアルタイムデータを地理情報でエンリッチして、ロケーションの移動に応じて、付近の情報を示すことにもNiFiを利用できます。

## 3. NiFiデータフロー作成手順を理解する

### 3.1 NiFi HTMLインタフェースの紹介

Hortonworks SandobxからNiFiを起動している場合は`localhost:6434/nifi`、ローカルマシンでNiFiを起動している場合は`localhost:8080/nifi`からNiFiにアクセスすると、[NiFi's User Interface (UI)](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_UserGuide/content/User_Interface.html)が画面に表示されます。
このUIを使用してデータフローを構築します。
UIには、チュートリアルのデータフローを構築、可視化、監視、変更そして管理するためのキャンバスと仕組みが備わっています。
**components**ツールバーにはすべてのデータフロー作成用ツールがあります。
**actions**ツールバーにはDFMがフローを管理し、NiFiの管理者がユーザのおアクセス権限やシステムプロパティを管理するためのボタンがあります。
**search**ツールバーでは、データフロー内の任意のコンポーネントを検索できます。
以下の画像は、各ツールバーの場所を示しています。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/nifi_dataflow_html_interface.png)

### 3.2 プロセッサ追加ダイアログの概要

すべてのデータフローにはプロセッサが必要です。プロセッサアイコン![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/processor_nifi_iot.png)を使用し、プロセッサをデータフローに追加します。
Add Processorsウィンドウを見てみましょう。目的のプロセッサを探す手段は3つあります。**processor list**にはおよそ180の項目が各プロセッサの説明と共に表示されています。**tag cloud**にはカテゴリが表示され、特定のユースケースに関連するプロセッサを探す際には、そのタグを選択し、適切なプロセッサを簡単に見つけることができます。
**filter bar**は入力されたキーワードによってプロセッサを検索します。
以下の画像はAdd Processorウィンドウ内でこれらが表示される位置を示しています。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/add_processor_window.png)

### 3.3 Configure Processorダイアログ概要

データフローに各プロセッサを追加した後は、それらを適切に設定する必要があります。
データフローマネージャは4つの設定タブを利用して、プロセッサごとの振る舞いを制御し、どのようにデータを処理すべきか指示します。
これらのタブを少し見てみましょう。
**Settings**タブはユーザがプロセッサの名前を変更したり、リレーションシップや、その他のパラメータを設定できます。
**Scheduling**タブはプロセッサの実行スケジュール方法に関連します。
**Properties**タブはプロセッサ固有の振る舞いに関連します。
**Comments**タブでは、DFMがプロセッサの利用用途に関する有益な情報を記述できます。
チュートリアルの実行中、プロパティや関連する値の変更に多くの時間を費やすことになります。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/putfile_logs_nifi_iot.png)

## 3.4 Configure Processor Propertiesタブ

これからチュートリアルでよく使うことになるPropertiesタブを詳しく見てみましょう。
特定のプロパティが何をするのかをより詳しく知るには、プロパティ名の隣にある**ヘルプシンボル**![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/question_mark_symbol_properties_config_iot.png)上にマウスをホバリングすると、プロパティの詳細情報、設定値と履歴が確認できます。
いくつかのプロセッサでは、DFMが新規のプロパティを追加することができます。
チュートリアルでは、**UpdateAttribute**で、ユーザ定義プロパティをプロセッサに追加します。
カスタムのユーザ定義プロパティを作成して、このプロセッサを通過する各フローファイルにユニークなファイル名を付与します。
以下の画像にプロセッサプロパティタブを示します:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/updateAttribute_config_property_tab_window.png)

3.5 コネクション & リレーションシップ

各プロセッサを設定した後は、それらを他のコンポーネントと[結合](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_UserGuide/content/Connecting_Components.html)する必要があります。
コネクションはプロセッサ(またはコンポーネント)間のつながりであり、少なくとも１つのリレーションシップを保持します。
ユーザがリレーションシップを選択し、実行結果にもとづき、データのルーティング先が決まります。
プロセッサは0以上の自動終了リレーションシップを持つこともできます。
フローファイルの処理結果が自動終了リレーションシップと一致する場合、そのフローファイルはフローから削除されます。
例えば、もし**EvaluateXPath**のunmatchedリレーションシップがAuto Terminateとなっていて、XPathの実行結果が不一致であった場合、フローファイルはフローから削除されます。そうでない場合、フローファイルは次のプロセッサへとmatchedを経由して送られます。
以下の画像はコネクションとリレーションシップを定義しています。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/completed-data-flow-lab1-connection_relationship_concepts.png)

## 3.6 NiFiデータフローの実行

データフロー内のコンポーネントを設定し、結合し終えたら、データフローが正常に動作するか確認すべき点が少なくとも3つあります。
すべてのリレーションシップが設定されていること、コンポーネントが正しく設定され、停止中であり、有効であり、アクティブなタスクが無いことを確認しましょう。
確認が済んだら、プロセッサを選択して、actionsツールバーにある再生シンボル![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/start_button_nifi_iot.png)をクリックし、データフローを実行します。
以下の画像は実行中のデータフローを示しています。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/run_dataflow_lab1_nifi_learn_ropes_concepts_section.png)


## 4. NiFiの主要コンセプト

データフローの構築手順を学習する際、多くのNiFiの主要コンセプトに触れました。フローファイル、プロセッサ、コネクションといった用語の意味は何だろうかと思ったかもしれません。
これらの用語を簡単に確認しておきましょう、チュートリアルの中でも度々目にすることになります。
チュートリアルを最大限に活かすためです。**Table 1**は各用語の概要を示します:

**Table 1**: NiFiコアコンセプト

| NiFi用語 | 説明 |
|----------|-----|
|フローファイル、FlowFile|システム内を移動するデータ、NiFiに取り込まれたデータ。このデータは属性(Attributes)とコンテンツを保持する。|
|プロセッサ、Processor|外部ソースからデータを取得するツール、フローファイルの属性やコンテンツに対しアクションを実行し、外部ソースへとデータを発信する。|
|コネクション、Connection|プロセッサ間のリンク、データの行き先を決めるキューとリレーションシップを保持する。|
|フローコントローラ、Flow Controller|プロセッサ間のフローファイル転送を実現するブローカとして振る舞う。|
|プロセスグループ、Process Group|プロセッサ、ファンネルなどを組み合わせ、新規コンポーネントの作成を可能とする|


## 5. NiFiの歴史

Apache NiFiは2014年秋のNSA Technology Transfer Programが起源となっています。
NiFiは2015年7月にApache公式プロジェクトの一つとなりました。
NiFiはそれ以前の8年間、開発されてきました。
NiFiは人々がより簡単に、何行ものコードを記述することなく、データ・イン・モーションを自動化し、管理するためのアイデアをもとに開発されています。
そのため、ユーザインタフェースは多くのツールのような形で構成されていて、グラフ上にドロップして、つなげることができます。
NiFiは複数経路のデータフロー、あらゆるデータソースからのデータ取込、データの分散、セキュリティやガバナンスといった、データ・イン・モーション固有の多くの課題を解決するために作成されています。
NiFiは様々なバックグラウンド(開発、ビジネス)を持つユーザの皆さまがこれらの課題に取り組む際に有効なツールです。

## さらに理解を深めるために

コンセプト章で取り上げたトピックはチュートリアル向けに簡潔に説明しています。

- これらのコンセプトについてより深く学びたい方は、[Getting Started with NiFi](https://nifi.apache.org/docs/nifi-docs/html/getting-started.html)をご覧ください。
- 特定の機能についてさらに学習するには、[Hortonworks NiFi User Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_UserGuide/content/index.html)をご覧ください。

NiFiを利用した興味深いユースケースの記事:
- [CREDIT CARD FRAUD PREVENTION ON A CONNECTED DATA PLATFORM](http://hortonworks.com/blog/credit-card-fraud-prevention-on-a-connected-data-platform/)
- [QUALCOMM, HORTONWORKS SHOWCASE CONNECTED CAR PLATFORM AT TU-AUTOMOTIVE DETROIT](http://hortonworks.com/blog/qualcomm-hortonworks-showcase-connected-car-platform-tu-automotive-detroit/)
- [CYBERSECURITY: CONCEPTUAL ARCHITECTURE FOR ANALYTIC RESPONSE](http://hortonworks.com/blog/cybersecurity-conceptual-architecture-for-analytic-response/)

---

[前へ](Learning-the-Ropes-of-Apache-NiFi) | [次へ](Ropes-of-Apache-NiFi%3A-Tutorial-0)
