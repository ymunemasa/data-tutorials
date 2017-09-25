# Apache NiFiの慣例を学ぶ

原文: [Learning the Ropes of Apache NiFi](http://hortonworks.com/hadoop-tutorial/learning-ropes-apache-nifi/)

## はじめに

Version 1.1 for HDF 2.0 updated Sept 14, 2016

Apache NiFiは、データを多数の発生元から収集、転送し、実行中のフローに対するインタラクティブなコマンド&コントロール、完全で自動化されたデータ来歴といった、リアルタイムの課題を解決する、はじめての統合されたプラットフォームです。
NiFiはデータの取得、シンプルなイベントプロセッシング、ネットワークにつながる人々、システム、そしてモノといった多種多様のデータフローを許容するために設計された転送、伝達の仕組みを提供します。

このチュートリアルでは、ある都市計画委員会が新規の高速道路を評価していると仮定します。この決定は現在の交通事情、特に他の道路工事も進行中である点に依存します。生きたデータの活用にはある問題が生じます、交通の分析は伝統的に過去の集約した交通量を利用していたためです。交通情報の分析を向上するために、都市計画委員ではリアルタイムデータを活用し、交通パターンのより深い理解を得たいと考えています。NiFiがこのリアルタイムデータ統合に採用されました。

## ゴールと目的

このチュートリアルの目的は、データフローの構築を通じてApache NiFiの機能に触れることです。このチュートリアルを完了するために、プログラミングの経験、フローベースのプログラミングシンタックスや機能の知識は必要ありません。

本チュートリアルの学習目的は:

- Apache NiFiの基本を理解する
- NiFiのHTMLユーザインタフェースに触れる
- NiFi プロセッサの設定、リレーションシップ、データ来歴、ドキュメント
- データフローの作成
- NiFiデータフローへAPIを追加
- NiFiテンプレートを学ぶ
- プロセスグループの作成

## 事前準備

- [Hortonworks Sandbox](http://hortonworks.com/products/sandbox/)をダウンロードしインストール(Option 1のStep 2で必要)。
- Windowsユーザは、チュートリアル中のLinuxターミナルコマンド実行用に[Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash)が必要。

## チュートリアル概要

本チュートリアルでは、NextBus XML Live Feedから収集した、San Francisco MUNI Transit agencyデータを利用します。車両位置情報、速度などの値を扱います。

本チュートリアルは四部構成となっています:

**[チュートリアル 0](Ropes-of-Apache-NiFi%3A-Tutorial-0)** - NiFi実行環境について学習します。Hortonworks Sandbox、もしくはお使いのローカルマシン上でNiFiを起動します。

**[チュートリアル 1](Ropes-of-Apache-NiFi%3A-Tutorial-1)** - NiFi UIを開き、機能を確認します。11のプロセッサを追加、設定し、データフローを作成します。位置情報XMLシミュレータからデータを取込、位置詳細属性をフローファイルから抽出し、属性をJSONファイルへと変換します。データフローを実行し、ターミナルから結果を確認します。

**[チュートリアル 2](Ropes-of-Apache-NiFi%3A-Tutorial-2)** - データフローに地理位置情報を付与します; Google Places Nearby APIをデータフローに追加し、車両位置付近の情報を取得します。

**[チュートリアル 3](Ropes-of-Apache-NiFi%3A-Tutorial-3)** - San Francisco MUNI agencyのNextBussライブストリームデータを取り込みます。

各チュートリアルには手順ごとの説明があり、関連する作業をしていくことで、ゴールまで到達できます。各チュートリアル用のデータフローテンプレートを確認に利用することもできます。各チュートリアルは前工程をベースとしています。

---

チュートリアル Q&A と 問題の報告

手助けが必要な際や、チュートリアルに関する質問は、まずFind Answeresボタンをクリックし、質問に対するHCCでの既存の回答を確認してください。回答が見つからない場合は新規のHCC問い合わせをAsk Questionsをクリックして作成してください。

[次へ](Apache-NiFi-Dataflow-Automation-Concepts)