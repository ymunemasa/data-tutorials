# Hadoopチュートリアル - HDP入門
## はじめに

このチュートリアルでは，あなたがHadoopとHDPに入門し，その構想を理解することを目指しています．最初のHDPアプリケーションを構築するために，IoT （Internet of Things）ユースケースを利用します．

このチュートリアルでは，Hortonworks Data Platformを利用して，Tracking IoT [Data Discovery](https://hortonworks.com/solutions/advanced-analytic-apps/#data-discovery)（別名 IoT Discovery）ユースケースのデータを修正する方法について解説します．
IoT Discoveryのユースケースには，車両や端末，人々の移動が含まれます．分析は，分析データと位置情報を結びつけさせることを対象としています．

私たちのチュートリアルでは，トラック車両隊をユースケースとして扱います．各トラックには，位置情報とイベントのデータを記録する機能が備わっています．これらのイベントはデータを処理するデータセンタにストリーミングされます．会社はリスクを理解するためにこのデータを利用したいと考えています．

ここでは，このチュートリアルで行う[ジオロケーションデータの分析](http://youtu.be/n8fdYHoEEAM)の動画を紹介します．


## 前提条件
- [Hortonworks Sandbox](https://hortonworks.com/downloads/#sandbox)をダウンロードおよびインストールしてください
- HDPに入門する前に，Hortonworks Sandboxの使い方を学び，VMのSandboxとAmbariのインターフェースに慣れることを**強く**おすすめします．
- データセットは[Geolocation.zip](https://app.box.com/HadoopCrashCourseData)を利用します．
- （任意）[Hortonworks ODBC Driver](http://hortonworks.com/downloads/#addons)をインストールしてください．
- このチュートリアルでは，Hortonworks SandboxがOracle VirtualBox仮想マシン（VM）にインストールされています．実際の画面の表示とは異なる場合があります．


## 目次
1. **Concepts**：Hortonworks Data Platform（HDP）の基礎を固める構想について
2. **Lab 1**：センサデータをHDFSに読み込ませよう
3. **Lab 2**：Hiveによるデータ操作をしよう
4. **Lab 3**：Pigを利用して，ドライバのリスクファクタを算出しよう
5. **Lab 4**：Apache Sparkを利用して，ドライバのリスクファクタを算出しよう
6. **Lab 5**：Zeppelinによる視覚化とデータレポーティングをしよう


### [次へ](tutorial-1.md)
