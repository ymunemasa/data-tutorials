実は、Stormトポロジはすでにデプロイされ、動いています。
今後のハンズオンではこの部分も深掘りしていきたいと思います。今回は何もする必要はありません。

詳細は[hdf-tutorial-ja/storm](https://github.com/ijokarumawak/hdf-tutorials-ja/tree/master/storm)をご参照ください。

## 4-1: Sliding Windowでキー毎の平均値を計算

本チュートリアルでは、Sliding Windowを利用して各キー毎の平均値を求めています。

- window size = count(10): 直近10個の要素を利用して平均値を求める
- sliding interval = count(3): 最新の3つが到着する度に、直近の10個で平均値を求める

よって、3つNiFiへとデータを登録する度に、平均値が更新されるような仕組みです。

![](https://github.com/ijokarumawak/hdf-tutorials-ja/blob/master/images/storm/topology-visualization.png)

### [前へ](tutorials-3.md)| [次へ](tutorials-5.md)
