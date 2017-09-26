Welcome to HDF Setup tutorials

[Hortonworks](http://jp.hortonworks.com)は、エンタープライズ企業向けの完全にオープンなデータプラットフォームの開発・提供・サポートを行う会社です。あらゆるデータを管理することをミッションとし、 Apache Hadoop、NiFi そして Spark などのオープンソースのコミュニティにおいてイノベーシ ョンをドライブすることにフォーカスしています。Hortonworksが提唱するConnected Data Platforms はdata-in-motion（流れているデータ）および、data-at-rest（蓄積されたデータ）など全てのデータから、新たな価値創生を支える次世代データアプリケーションを実現します。Hortonworksは 1,600を超えるパートナーと共に、専門知識、トレーニング、サービスなどをあらゆる分野のビジネスにおいて提供します。
<img width="831" alt=" 2016-09-30 23.45.01.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/0720bf0f-dc03-93d7-5d8f-28c41b2b714f.png">

[Hortonworks Data Platform](http://jp.hortonworks.com/products/data-center/hdp/)は、Apache Hadoop / Sparkを中核においた、100%オープンなエンタープライズ向けのデータ蓄積、分析プラットフォームです。
![3 HDP.png](https://qiita-image-store.s3.amazonaws.com/0/42406/4ccf3679-4dc1-c285-e24c-23fa61ee5c5b.png)

[Hortonworks DataFlow](http://jp.hortonworks.com/products/data-center/hdf/)は、Apache NiFi / Apache Kafka / Apache Stormを中核においた、100%オープンなエンタープライズ向けのデータフローオーケストレーションです。
![8 HDF.png](https://qiita-image-store.s3.amazonaws.com/0/42406/ec29b6e9-b0dc-d99c-9a86-95dab29840ea.png)

---

## Sandboxデプロイ手順

開発者プログラム特典のサブスクリプションを利用すれば、毎月3000円の無料枠を利用できるので、下記ブログを参照しながら、登録しておくといいでしょう。通常は、30円程度/時の課金となります。
https://satonaoki.wordpress.com/2016/02/05/vs-dev-essentials-azure/

1. Azureにサインアップ
https://azure.microsoft.com/

2. Azureの管理ポータルにログイン
https://portal.azure.com

3. Network Security Groupの作成
ダッシュボードより、[その他のサービス] - [Network Security Group]をクリックし、追加をクリックし、任意の名前で、Network Security Groupを作成
![image](https://qiita-image-store.s3.amazonaws.com/0/42406/ba1734a9-892d-068f-804b-51234145bb46.png)

4. 必要なポートのオープン
下記の必要なポートをオープンする。
    - 22 ssh
    - 6080 Ranger
    - 8080 Ambari
    - 8888 Dashboard
    - 9995 Zeppelin
![image](https://qiita-image-store.s3.amazonaws.com/0/42406/2a68f252-393a-2f4a-208b-d2e6c470f799.png)

5. Marketplaceを検索してアクセス
<img width="1073" alt=" 2016-09-29 19.00.21.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/e3debc46-0eed-6783-ce31-6fe812787aa6.png">

6. Hortonworksで検索して、「Hortonworks Sandbox with HDP ~~2.4~~ 2.5」を選択
<img width="1055" alt=" 2016-09-29 19.00.38.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/f8676ac3-7484-107c-c5d1-9a6b388b2dc9.png">

7. 作成ボタンをクリック
<img width="1097" alt=" 2016-09-29 19.00.54.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/01864473-b55e-fb34-3758-ed64d41b3b84.png">

8. 仮想マシンの設定行い、スクロールダウン
<img width="844" alt=" 2016-09-29 19.03.41.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/41543057-c58f-fa13-2680-9df0c726995c.png">

9. 仮想マシンの設定を行い、OKボタンをクリック
<img width="687" alt=" 2016-09-29 19.03.45.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/83625c4e-55e7-4b32-a032-d7162e3e40fd.png">

10. DS11_V2 Standard （15円/時程度）を選択
他のマシンタイプを選択してもいいが、あまりスペックの低いものだと動作しないので注意
![image.png](https://qiita-image-store.s3.amazonaws.com/0/42406/98e52fcd-3226-7fed-0611-24bcd5809406.png)


11. オプションの構成
※注意: ネットワークセキュリティグループで、先ほど作成した`Network Security Group`を選択
<img width="870" alt=" 2016-09-29 19.04.31.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/7c79f79b-0b5a-b809-f2e5-6053cf317d9f.png">

12. 設定の検証
<img width="968" alt=" 2016-09-29 19.04.41.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/5c3aa43b-f2da-289d-ca04-9dd95448e368.png">

13. 設定を確認し購入ボタンをクリック
<img width="951" alt=" 2016-09-29 19.04.50.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/86c8c289-4a2f-1007-d033-c2ef9a636abf.png">

14. ダッシュボードに戻ってデプロイを待つ
<img width="1081" alt=" 2016-09-29 18.59.55.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/2728c491-da01-a652-20b2-a6eda7534525.png">

15. 作成されたことを確認（実行中というステータスになる）
<img width="1080" alt=" 2016-09-29 19.05.16.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/148fd47c-41b5-458b-f6aa-36ead302b441.png">

16. http://SandboxのIPアドレス:8888 にアクセスして、必要な情報を入力して、Submitをクリック
<img width="1207" alt=" 2016-09-29 19.06.59.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/42eaa66a-c714-c57e-0cb8-3d734a271a17.png">

17. http://SandboxのIPアドレス:8080 にアクセス 
user / password: raj_ops / raj_ops でログイン (maria_devではない）
<img width="1148" alt=" 2016-09-29 19.14.34.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/fa36f655-0c4a-7d47-ebd4-7de485f528aa.png">

18. Ambari（クラスタ管理）のダッシュボードが表示
<img width="1280" alt=" 2016-09-30 23.26.29.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/da706085-4cdd-63d5-28b7-49b78ad77a96.png">

19. Hive ビューで簡単なビジュアライズ
<img width="1280" alt=" 2016-09-30 23.27.29.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/812df3ef-d26c-4dcb-36ba-c5ce06c08bb8.png">

20. HDFS Filesビューでファイル管理
<img width="1280" alt=" 2016-09-30 23.28.15.png" src="https://qiita-image-store.s3.amazonaws.com/0/42406/108d3fde-72b5-33ee-9d55-3b87da8d5e39.png">

それでは、[チュートリアル](http://hortonworks.com/tutorials/)に沿って、データ活用の旅に出ましょう。

---
## 補足情報
- hdfsなどのコマンドを使用する場合は、AzureのSandboxは、Azure VM上のDocker環境に作成されていますので、Azure VMにSSHでログインし、さらにSSHでDockerコンテナにログインします。

```
[horton@sandbox ~]$ ssh root@127.0.0.1 -p 2222
root@127.0.0.1's password: hadoop
You are required to change your password immediately (root enforced)
Last login: Fri Apr 14 09:28:07 2017 from 172.17.0.1
Changing password for root.
(current) UNIX password: hadoop
New password: 新しいパスワード
Retype new password: 新しいパスワード
```
- HDF (NiFI)をAmbariから追加して、Webアプリケーションなどを簡易的に立ち上げる場合、Portを9095など自由に設定すると、connection refusedで拒否される場合があります。色々な理由が考えられますが、そのうちの一つに、Dockerのポートフォワーディングが設定されていない事が考えられます。Sandboxを起動する際のスクリプトを確認して、ポートフォワーディングの設定を確認して、必要なポートを追加し、再起動します。(参考: [OPENING SANDBOX PORTS ON AZURE](https://jp.hortonworks.com/hadoop-tutorial/opening-sandbox-ports-azure/))

```
vi /root/start_scripts/start_sandbox.sh
```

- Ambariにadminで接続したい場合。
 1. sshでsandboxに接続
 2. 下記コマンドでパスワードを設定

```
 # ambari-admin-password-reset
 # ambari-agent restart
```

- 会社のPCでAmbariに接続できない場合。
 1. AzureでWindows serverをデプロイして、Ambariに接続してみましょう。
[Microsoft AzureでWindows Server 2012 R2を起動してみる](http://qiita.com/enokawa/items/8b8c9841a7a88f4c0dd1)を参考にしてください。

- データフローオーケストレーションを行うHortonworks DataFlowを試してみたい場合、[Hortonworks Sandbox にNifiをインストール（Windows上のVirtualBox、Microsoft Azure）](http://qiita.com/cyberblack28/items/9b4df7bdc6c23836a4f8#microsoft-azureのhortonworks-sandboxにnifiをインストール)を参考にしてみましょう。[AmbariからNiFiを追加する方法](https://community.hortonworks.com/articles/25806/azure-sandbox-prep-for-twitterhdphdf-demo.html)もあります。

- NiFiでTwitterのデータをSolrで可視化するデモを試したい場合、[TwitterからNiFiでデータを収集し、データフローをコントロールし、Solr + Bananaで可視化させてみよう](http://qiita.com/kkitase/items/eedb273d6bfe2b8b6737#_reference-cd9544a1d081ffcc6fc4)を参考にしてみましょう。

- このインスタンスを継続して利用する場合、自動シャットダウンをONにしておくといいでしょう。
![ss 2016-12-05 7.52.53.png](https://qiita-image-store.s3.amazonaws.com/0/42406/bdd4f5fa-9809-fbe8-c671-2565b411b3e7.png)

- Ambari Viewが表示されない場合、ブラウザを変更してみましょう。Chromeではほぼ動作しますが、他のブラウザでは表示されない事があるようです。
