# チュートリアル 0: NiFi実行環境の設定

## はじめに

このチュートリアルでは、Hortonworks SandboxもしくはローカルマシンへのNiFiインストール方法、そしてNiFi起動方法など、NiFi実行環境について学習します。

## 事前準備

- [Apache NiFiの慣例を学ぶ](Learning-the-Ropes-of-Apache-NiFi)を完了していること
- [Hortonworks Sandbox](http://hortonworks.com/products/sandbox/)をダウンロードしインストール(Option 1のStep 2で必要)。
- Windowsユーザは、チュートリアル中のLinuxターミナルコマンド実行用に[Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash)が必要。
- MacまたはLinuxの場合、`sandbox.hortonworks.com`を`/private/etc/hosts`ファイルに追記する
- Windows 7の場合、`sandbox.hortonworks.com`を`/c/Windows/System32/Drivers/etc/hosts`ファイルに追記する

チュートリアルの手順に出てくる以降のターミナルコマンドはVirtualBox SandboxとMacマシンで実行します。Windowsユーザの方は、以下のターミナルコマンドを実行するためには[Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash)が必要です。

MacまたはLinuxで、`sandbox.hortonworks.com`をホストのリストに追加するには、ターミナルを開き、以下のコマンドを入力します、`{Host-Name}`は適切にsandboxのホストで置換してください:

```
echo '{Host-Name} sandbox.hortonworks.com' | sudo tee -a /private/etc/hosts
```

Windows 7で`sandbox.hortonworks.com`をホストリストに追加するには、git bashを開き、以下のコマンドを入力します、`{Host-Name}`は適切にsandboxのホストで置換してください:

```
echo '{Host-Name} sandbox.hortonworks.com' | tee -a /c/Windows/System32/Drivers/etc/hosts
```

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/realtime-event-processing-with-hdf/lab0-nifi/changing-hosts-file.png)

## 概要

- Step 1: NiFiのインストール前にNiFi実行環境を確認する
  - 1.1 Sandbox上にHDF 2.0のインストールを計画する
  - 1.2 ローカルマシン上にHDF 2.0のインストールを計画する
- Step 2: NiFiをダウンロードし、Sandbox上にインストールする (Option 1)
- Step 3: NiFiをダウンロードし、ローカルマシン上にインストールする (Option 2)
- Step 4: Sandbox上でNiFiを起動する
  - 4.1 VirtualBox GUIからポートをフォワードする
  - 4.2 Azure GUIからポートをフォワードする
- Step 5: ローカルマシン上でNiFiを起動する
- まとめ



### Step 1: NiFiのインストール前にNiFi実行環境を確認する

単一の仮想マシン、あるいはローカルコンピュータ上でNiFiを起動できます。本バージョンのチュートリアルは[Hortonworks DataFlow 2.0 GZipped](http://hortonworks.com/downloads/)の利用をベースとしています。
HDF 2.0をダウンロードしインストールする方法は２つあります:
Option 1 - Hortonworks Sandbox 2.4 Virtual Image上にインストール、あるいは
Option 2 - ローカルマシン上にインストール。
HDFはNiFiのみと、NiFi、Kafka、Storm、Zookeeperをセットにした2つのバージョンがあります。
本チュートリアルでは、NiFiのみのHDFをダウンロードしてください。
必要なコンポーネント:

- HDF 2.0 (NiFi only)
- Internet Access

### 1.1 Sandbox上にHDF 2.0のインストールを計画する

Hortonworks Sandbox上にHDFをインストールする場合、次の表を確認し、Step 2へと進みましょう。

**Table 1: Hortonworks Sandbox VM Information **

|パラメータ|値(VirtualBox)|値(VMware)|値(MS Azure)|
|---------|--------------|----------|------------|
|Host Name|127.0.0.1|172.16.110.129|23.99.9.233|
|Port|2222|2222|22|
|Terminal Username|root|root|{username-of-azure}|
|Terminal Password|hadoop|hadoop|{password-of-azure}|

> 注: **Host Name**の値はVMware、Azure Sandboxではユニークになります。VMwareとVirtualBoxの場合、**Host Name**はWelcome screenに表示されます。Azureでは、**Host Name**はSandbox Dashboardの**Public IP Address**に表示されます。Azureユーザは、Azure上にSandboxをデプロイする際に、ターミナル**username**と**password**を作成しているはずです。VMwareとVirtualBoxユーザは、初回ログイン時にターミナルパスワードを変更します。

Sandbox VMを初めて利用する場合、デフォルトの'hadoop'パスワードの変更を求められるでしょう。以下のコマンドを実行し、より安全なパスワードを設定しましょう:

```
ssh -p 2222 root@localhost
root@localhost's password:
You are required to change your password immediately (root enforced)
Last login: Wed Jun 15 19:47:44 2016 from 10.0.2.2
Changing password for root.
(current) UNIX password:
New password:
Retype new password:
[root@sandbox ~]#
```

### 1.2 ローカルマシン上にHDF 2.0のインストールを計画する

ローカルマシン上にNiFiのインストールを行う場合、このセクションを参照してください。
マシンがシステム要件に適合していることを確認したら、Step 3に進みましょう。

お使いのシステムはHDFのインストール要件に適合していますか?

HDFのサポート対象のOS:

- Linux Red Hat/Cent OS 6 or 7) 64-bit
- Ubuntu 12.04 or 14.04 64-bit
- Debian 6 or 7
- SUSE Enterprise 11-SP3
- MAC OS X
- Windows OS

サポート対象のブラウザ:

- Mozilla Firefox latest
- Google Chrome latest
- MS Edge
- Safari 8

サポート対象のJDKS:

- Open JDK7 or JDK8
- Oracle JDK 7 or JDK 8

HDFと互換性のあるサポート対象のHDPバージョン:

HDP 2.3.x
HDP 2.4.x
HDP 2.5.x

HDFには2つのバージョンがあります。

バージョン1はNiFiのみ。

 - Hortonworks HDFダウンロードページで、バージョン1が利用可能です。

バージョン2はNiFi、Kafka、Storm、Zookeeperを含む。

- このバージョンはHortonworks Documentationから利用可能です。

### Step 2: NiFiをダウンロードし、Sandbox上にインストールする (Option 1)

このチュートリアルではHortonworks Sandbox 2.4を利用します。

SandobxにはHDFがプリインストールされていないので、HDFをHortonworks Sandbox VirtualBox image上にインストールします。

以下の手順でNiFiをインストールしましょう:

- 1. **ローカルマシン**でターミナルウィンドウ(Mac、Linux)またはgit bash(Windows)を開きます。**install-nifi.sh**をGithubリポジトリからダウンロードします。以下のコマンドをコピー&ペーストしましょう:

```
cd
curl -o install-nifi.sh https://raw.githubusercontent.com/hortonworks/tutorials/hdp/assets/realtime-event-processing/install-nifi.sh
chmod +x ./install-nifi.sh
```

- 2. ブラウザを開きます。[HDF Downloads Page](http://hortonworks.com/downloads/)からNiFiをダウンロードします。２つのパッケージが選択できます: ひとつはLinux向けのHDF TAR.GZファイルで、もうひとつはよりWindows向けのZIPファイルです。Macはどちらでも構いません。チュートリアルでは、最新のHDF TAR.GZをダウンロードします:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/download-hdf-learn-ropes-nifi.png)

- 3. install-nifi.shスクリプトを実行します。以下はinstall-nifi.shコマンドの実行方法です:

install-nifi.sh {location-of-HDF-download} {sandbox-host} {ssh-port} {hdf-version}

> 注: VMwareとAzureでは、sandbox-hostがSandbox起動後のWelcome screenで表示されます。Table 1に記載のssh-portを利用します。hdf-versionはダウンロードしたtar.gzファイル名内の数値です、例えば、太字で示される数値ですHDF-*1.2.0.1-1*.tar.gz。

HDF TAR.GZファイルのパス、Sandboxホスト名、sshポート番号、HDFバージョンを指定すると、コマンドは以下のようになります:

```
./install-nifi.sh ~/Downloads/HDF-1.2.0.1-1.tar.gz localhost 2222 1.2.0.1-1
```

このスクリプトは自動でNiFiを仮想マシンにインストールします。正常に完了すると、NiFiはHortonworks Sandboxに転送され、`~`フォルダに配置されます。

### Step 3: NiFiをダウンロードし、ローカルマシン上にインストールする (Option 2)

- 1. ブラウザを開きます。[HDF Downloads Page](http://hortonworks.com/downloads/)からNiFiをダウンロードします。２つのパッケージが選択できます: ひとつはLinux向けのHDF TAR.GZファイルで、もうひとつはよりWindows向けのZIPファイルです。Macはどちらでも構いません。チュートリアルでは、Macにzipファイルをダウンロードします:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/download-hdf-learn-ropes-nifi.png)

- 2. ダウンロードしたNiFiは、圧縮形式です。NiFiをインストールするには、圧縮されたファイルから、アプリケーションを起動したい場所へと、ファイルを展開します。チュートリアルでは、解凍したHDFフォルダを`Applications`フォルダへ移動します。

以下の画像はダウンロードしたNiFiと、Applicationsフォルダへインストールしたものを示しています:

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/download_install_nifi.png)

### Step 4: Sandbox上でNiFiを起動する

Hortonworks SandboxにNiFiをダウンロードしてインストールした場合、次の手順でNiFiを起動します。ローカルマシン上でNiFiを起動する場合の手順はStep 5を参照してください。

このチュートリアルでは、NiFiをバックグラウンドで起動します。

- 1. ターミナル(Mac, Linux)、またはgit bash(Windows)を開きます。Hortonworks SandboxへSSH接続します:

```
ssh root@127.0.0.1 -p 2222
```

- 2. `bin`ディレクトリに下記コマンドで移動します:

```
cd hdf/HDF-1.2.0.1-1/nifi/bin
```

- 3. `nifi.sh`スクリプトでNiFiを起動します:

```
./nifi.sh start
```

> 注: NiFiを停止するには`./nifi.sh stop`を実行します。

NiFiデータフローを`http://sandbox.hortonworks.com:9090/nifi/`で開き、NiFiの起動を確認します。NiFiのロード完了まで1分ほど待ちます。NiFiのHTMLインタフェースがロードされない場合、nifi.propertiesファイルの次の値を確認しましょう、**nifi.web.http.port=9090**。

- 4. **conf**フォルダに移動し、nifi.propertiesをviエディタで開きます。

```
cd ../conf
vi nifi.properties
```

- 5. `/nifi.web.http.port`と入力し、エンターを押します。nifi.web.http.portの値が下記のように、`6434`であることを確認しましょう、違う場合は値を変更します:

> TODO: Documentation Error??

```
nifi.web.http.port=9090

```

viエディタを終了するには、`esc`を押し、`:wq`と入力し、ファイルを保存します。
これで、nifi.properties設定ファイルが更新されました、VMはポート**9090**をリスンしていないので、NiFiをブラウザでロードできません。新しいNiFiポートをポートフォワードします。VirtualBox Sandboxを利用している方は、セクション 4.1を、Azure Sandboxを利用している方は、セクション4.2を参照してください。

### 4.1 VirtualBox GUIからポートをフォワードする

1. VirtualBox Managerを開きます

2. 起動中のHortonworks Sandboxを右クリックし、**settings**を選択します

3. **Network**タブを表示します

**Port Forwarding**と記載のボタンをクリックします。NiFiのエントリを以下の値で上書きします:


|Name|Protocol|Host IP|Host Port|Guest IP|Guest Port|
|----|--------|-------|---------|--------|----------|
|NiFi|TCP|127.0.0.1|9090|  |9090|

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/port_forward_nifi_iot.png)

4. NiFiを`http://sandbox.hortonworks.com:9090/nifi/`で開きます。1, 2分NiFiのロードを待ちます。

> 注: `sandbox.hortonworks.com`エイリアスを`/etc/hosts`に設定していない場合、`http://localhost:9090/nifi`のURLも試してください。

### 4.2 Azure GUIからポートをフォワードする

1. Azure Sandboxを開きます

2. **シールド**アイコンのSandboxをクリックします。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/shield-icon-security-inbound.png)

3. **Settings**にある、**General**セクションの、**Inbound Security Rules**をクリックします。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/inbound-security-rule.png)

4. **NiFi**へスクロールし、行をクリックします。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/list-nifi-port.png)

5. **Destination Port Range**が9090であることを確認します、違う場合は変更します。

![](https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/change-nifi-port.png)

6. `http://sandbox.hortonworks.com:9090/nifi/`でNiFiを開きます。1、2分NiFiのロードを待ちます。

### Step 5: ローカルマシン上でNiFiを起動する

ローカルマシン上にNiFiをダウンロード、インストールした場合、次の手順でNiFiを起動します。

NiFiの起動方法は3つあります: NiFiをフォアグラウンド、またはバックグラウンドで起動、あるいはサービスとして起動します。詳細は[HDF Install and Setup Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_HDF_InstallSetup/content/starting-nifi.html)をご覧ください。

1. バックグランドでNiFiを起動するには、ターミナルウィンドウかgit bashを開き、NiFiインストールディレクトリへ移動し、次のコマンドを実行します:

```
./HDF-1.2.0.1-1/nifi/bin/nifi.sh start
```

2. NiFiを`http://sandbox.hortonworks.com:8080/nifi/`で開きます。NiFiのロード完了まで1、2分待ちます。

### まとめ

おめでとうございます！NiFiがVM、またはお使いのコンピュータに直接インストールできるようになりました。
NiFiのダウンロード、インストール、起動方法も学びましたね。
NiFiが起動したので、データフロー作成の準備が整いました。

### さらに理解を深めるために

NiFiの設定に関する詳細情報は、[System Administrator's Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_AdminGuide/content/index.html)をご参照ください。

---

[前へ](Apache-NiFi-Dataflow-Automation-Concepts.md) | [次へ](Ropes-of-Apache-NiFi%3A-Tutorial-1.md)