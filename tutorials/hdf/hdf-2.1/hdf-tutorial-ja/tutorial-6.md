ZeppelinはHDFスタックに含まれる製品ではありませんが、本ハンズオンを実行するうえでデータが可視化できるとより理解が深まるので利用してみましょう。

すでにZeppelinはインストール、起動済で、次のアドレスにWebブラウザからアクセスできます:

`http://<host>:8090/`

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/zeppelin/welcome-page.png)

`Create new note`をクリックし、新しいノートブックを作成しましょう。名前は何でもOKです。

パラグラフに以下のscalaコードを入力します。SparkでNiFiから出力したStorm処理結果のJSONを読み込み、DataFrameに変換します。
DataFrameはSQLで分析することができます:

```scala
import org.apache.commons.io.IOUtils
import java.net.URL
import java.nio.charset.Charset

var df = sqlContext.read.json("/opt/hdf-handson/report/latest.json")
df.show
df.registerTempTable("average_age")
```

別のパラグラフで以下のSQLを実行してみましょう:

```sql
%sql
select * from average_age
```

次のような結果が得られます。しかし、これだと、棒グラフや円グラフで表示した際に意味のあるグラフにはなりません。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/zeppelin/sql-result.png)


行列を入れ替えたほうがよさそうですね。

これもNiFiで変換してみましょう。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/zeppelin/add-jolt-transform.png)

JoltTransformationJSON

| Property | Value |
|----------|-------|
| Jolt Transformation DSL | Shift |

Jolt Specificationには以下のJSONを設定します:

```json
{
  "*": {
    "$": "[#2].k",
    "@": "[#2].v"
  }
}
```

すると、元のJSONを次のように配列形式へと変換できます:
```json
{"A":18.33,"B":12.0,"C":19.0,"D":25.0}
```

```json
[{"k":"A","v":18.33},{"k":"B","v":12.0},{"k":"C","v":19.0},{"k":"D","v":25.0}]
```

Zeppelinで棒グラフ表示すると、次のように各keyの値をY軸の値として表示できます:

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/zeppelin/after-jolt-bar-chart.png)

### [前へ](tutorial-5.md) 