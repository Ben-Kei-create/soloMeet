import Foundation

struct CoffeeTipsDatabase {
    static let tips: [CoffeeTipData] = [
        // 焙煎度
        CoffeeTipData(id: 1, title: "浅煎りと深煎り", content: "コーヒー豆の焙煎度は、浅煎り（ライト）から深煎り（フレンチ）まで段階があります。浅煎りは酸味が強く、深煎りは苦味が強くなります。", category: "焙煎"),
        CoffeeTipData(id: 2, title: "シティロースト", content: "シティロースト（中深煎り）は、苦味と酸味のバランスが取れており、世界で最も一般的な焙煎度です。日本でも人気があります。", category: "焙煎"),
        CoffeeTipData(id: 3, title: "フレンチロースト", content: "フレンチロースト（深煎り）は最も深く、苦味が強くスモーキーな風味が特徴です。カフェオレやエスプレッソに適しています。", category: "焙煎"),
        CoffeeTipData(id: 4, title: "ライトロースト", content: "ライトロースト（浅煎り）は酸味が強く、豆本来の風味を活かしています。スペシャルティコーヒーでよく使われます。", category: "焙煎"),
        CoffeeTipData(id: 5, title: "焙煎度による香り", content: "浅煎りは花や柑橘系の香り、深煎りは黒い焦げや木の香りが特徴です。焙煎度によって全く違う風味になります。", category: "焙煎"),

        // 産地
        CoffeeTipData(id: 6, title: "ブラジルのコーヒー", content: "ブラジルは世界で最もコーヒーを生産する国で、世界の約35%のコーヒーがブラジル産です。バランスの良い味わいが特徴。", category: "産地"),
        CoffeeTipData(id: 7, title: "エチオピアの発祥地", content: "コーヒー発祥の地はエチオピアと言われています。爽やかなフローラルな香りが特徴のエチオピアコーヒーは愛好家から高く評価されています。", category: "産地"),
        CoffeeTipData(id: 8, title: "コロンビアの品質", content: "コロンビアは高品質コーヒーの産地として知られ、バランスの取れた酸味とボディが特徴です。スペシャルティコーヒーも多く産出されます。", category: "産地"),
        CoffeeTipData(id: 9, title: "ベトナムのロブスタ豆", content: "ベトナムはアラビカ豆に次いで多くロブスタ豆を生産しています。ロブスタ豆は苦味が強く、インスタントコーヒーに使われることが多いです。", category: "産地"),
        CoffeeTipData(id: 10, title: "ケニアのSL28", content: "ケニアのSL28という品種は、複雑な酸味を持つ高級コーヒーです。ベリーやブラックカラントのような風味が特徴。", category: "産地"),

        // 豆の種類
        CoffeeTipData(id: 11, title: "アラビカ豆とロブスタ豆", content: "コーヒー豆の約60%がアラビカ豆で、品質が高く風味が豊か。残りはロブスタ豆で、カフェイン含量が多く苦味が強いです。", category: "豆の種類"),
        CoffeeTipData(id: 12, title: "ボルボン種", content: "ボルボン種はアラビカ豆の古い品種で、甘みと複雑さが特徴。育成が難しいため希少です。", category: "豆の種類"),
        CoffeeTipData(id: 13, title: "ゲイシャ種", content: "ゲイシャ種はパナマ産の高級品種で、世界で最も高価なコーヒーの一つです。華やかなフローラルな香りが特徴。", category: "豆の種類"),
        CoffeeTipData(id: 14, title: "ムンドノーボ種", content: "ムンドノーボ種はアラビカ豆の品種で、収量が多く栽培しやすいため広く栽培されています。バランスの良い味わいが特徴。", category: "豆の種類"),
        CoffeeTipData(id: 15, title: "カトゥアイ種", content: "カトゥアイ種はアラビカ豆の品種で、濃厚なボディと甘みが特徴です。ブラジルで広く栽培されています。", category: "豆の種類"),

        // 抽出方法
        CoffeeTipData(id: 16, title: "ペーパードリップ", content: "ペーパードリップはコーヒーペーパーフィルターを使用した最も一般的な抽出方法で、クリーンな味わいが特徴です。初心者向きです。", category: "抽出"),
        CoffeeTipData(id: 17, title: "フレンチプレス", content: "フレンチプレスは全水浸漬式の抽出方法で、コーヒーの油分を引き出し濃厚な味わいになります。清掃が必要です。", category: "抽出"),
        CoffeeTipData(id: 18, title: "エスプレッソ機", content: "エスプレッソ機は高圧を利用して素早く抽出し、濃厚でクリーミーなショットが得られます。スキルが必要ですが最高の香りが楽しめます。", category: "抽出"),
        CoffeeTipData(id: 19, title: "モカエキスプレス", content: "モカエキスプレスはストーブで加熱する抽出器で、イタリアでよく使われています。エスプレッソに近い濃厚さが得られます。", category: "抽出"),
        CoffeeTipData(id: 20, title: "コールドブリュー", content: "コールドブリューは8-12時間かけて冷水で抽出し、苦味が少なく甘みが強い冷たいコーヒーが得られます。", category: "抽出"),

        // カフェイン
        CoffeeTipData(id: 21, title: "カフェイン含量", content: "コーヒーカップ1杯（約150ml）には約95-200mgのカフェインが含まれています。深煎りの方がカフェインが少ないという説は誤りです。", category: "カフェイン"),
        CoffeeTipData(id: 22, title: "カフェインレスコーヒー", content: "カフェインレスコーヒーは97%以上のカフェインが除去されています。寝る前でも安心して楽しめます。", category: "カフェイン"),
        CoffeeTipData(id: 23, title: "カフェイン感受性", content: "カフェイン感受性は個人差が大きく、遺伝的要因によって決まります。少量で効く人もいれば、大量に飲んでも効かない人もいます。", category: "カフェイン"),
        CoffeeTipData(id: 24, title: "カフェイン吸収時間", content: "カフェインは飲用後15-45分で吸収され、ピークは30-60分後です。効果は4-6時間続きます。", category: "カフェイン"),
        CoffeeTipData(id: 25, title: "カフェイン離脱症状", content: "毎日コーヒーを飲む人が急に止めると、頭痛や疲労感などの離脱症状が出ることがあります。徐々に減らすことがおすすめです。", category: "カフェイン"),

        // 健康
        CoffeeTipData(id: 26, title: "コーヒーと健康", content: "適量のコーヒー（1日3-5杯）は、心臓病や糖尿病のリスク低下と関連があります。また、肝臓病のリスク低下も報告されています。", category: "健康"),
        CoffeeTipData(id: 27, title: "ポリフェノール", content: "コーヒーに含まれるポリフェノール（クロロゲン酸）は強い抗酸化作用があり、アンチエイジングに役立つとされています。", category: "健康"),
        CoffeeTipData(id: 28, title: "脳機能向上", content: "カフェインは脳内のアデノシン受容体をブロックし、集中力と反応速度を向上させます。学習や仕事に効果的です。", category: "健康"),
        CoffeeTipData(id: 29, title: "代謝向上", content: "カフェインは代謝を3-11%高めることが報告されています。ダイエット中の人にとって有効です。", category: "健康"),
        CoffeeTipData(id: 30, title: "抗炎症作用", content: "コーヒーの抗炎症物質は、関節炎やアルツハイマー病のリスク低下に関連があります。", category: "健康"),

        // 歴史
        CoffeeTipData(id: 31, title: "コーヒーの起源", content: "コーヒーはエチオピアで発見され、アラビア半島で栽培が広がり、オスマン帝国を通じてヨーロッパに伝わりました。", category: "歴史"),
        CoffeeTipData(id: 32, title: "コーヒーハウス", content: "17世紀のイスラエルやトルコでコーヒーハウスが流行し、知識人の集合場所となりました。これが現在のカフェの起源です。", category: "歴史"),
        CoffeeTipData(id: 33, title: "日本へのコーヒー伝来", content: "コーヒーは江戸時代後期に日本に伝わり、明治時代に本格的に普及しました。今では日本はコーヒー文化が深い国です。", category: "歴史"),
        CoffeeTipData(id: 34, title: "インスタントコーヒー", content: "インスタントコーヒーは1901年にアメリカで発明されました。粉末状で簡単に湯に溶けるため、忙しい人に重宝されています。", category: "歴史"),
        CoffeeTipData(id: 35, title: "スターバックス前夜", content: "1971年にシアトルに最初のスターバックスがオープンしました。現在では世界中に3万店舗以上あります。", category: "歴史"),

        // 味わい
        CoffeeTipData(id: 36, title: "コーヒーの味わい用語", content: "コーヒーの味わいは、酸味、苦味、甘み、香り、ボディなど複数の要素で表現されます。テイスティングは奥が深いです。", category: "味わい"),
        CoffeeTipData(id: 37, title: "ボディ感", content: "ボディはコーヒーの重さと口当たりを表します。軽いボディは水っぽく、重いボディは濃厚です。", category: "味わい"),
        CoffeeTipData(id: 38, title: "酸味の種類", content: "コーヒーの酸味は不快ではなく、爽やかさや複雑さを表します。ケニアやエチオピアは酸味が特徴です。", category: "味わい"),
        CoffeeTipData(id: 39, title: "香りの要素", content: "コーヒーの香りには、フローラル、フルーティ、スパイス、ナッツなど様々な香気成分が含まれています。", category: "味わい"),
        CoffeeTipData(id: 40, title: "後味", content: "コーヒーの後味はアフターテイストとも呼ばれ、長く続く後味が高品質の証です。質の低いコーヒーは後味がすぐ消えます。", category: "味わい"),

        // 保存
        CoffeeTipData(id: 41, title: "豆の保存方法", content: "コーヒー豆は空気、光、湿気を避けて保存します。常温の暗い場所が最適で、冷蔵庫や冷凍庫は避けるべきです。", category: "保存"),
        CoffeeTipData(id: 42, title: "粉の保存期間", content: "挽いたコーヒー粉は劣化が早く、1-2週間以内に使用することが推奨されます。豆の状態なら3-4週間持ちます。", category: "保存"),
        CoffeeTipData(id: 43, title: "脱気弁", content: "コーヒー豆のパッケージについている片方向弁は、焙煎後に放出されるガスを逃がし、劣化を防ぎます。", category: "保存"),
        CoffeeTipData(id: 44, title: "新鮮さの指標", content: "焙煎日から2-4週間がコーヒーの最適な飲み期間です。新しすぎるとガスが多く、古すぎると風味が落ちます。", category: "保存"),
        CoffeeTipData(id: 45, title: "冷蔵保存の誤解", content: "コーヒーを冷蔵庫に保存すると、結露により湿度が上がり劣化が早まります。常温保存が最適です。", category: "保存"),

        // グラインド
        CoffeeTipData(id: 46, title: "グラインドの重要性", content: "同じ豆でもグラインドサイズが違うと、抽出速度が変わり全く別の味になります。抽出方法に合わせて調整が重要です。", category: "グラインド"),
        CoffeeTipData(id: 47, title: "極細挽き", content: "極細挽きはエスプレッソ用で、粉が砂糖のように細かいです。パウダー状なので吸水性が高いです。", category: "グラインド"),
        CoffeeTipData(id: 48, title: "中挽き", content: "中挽きはペーパードリップやコーヒーメーカー用で、最も一般的な挽き方です。砂糖粒のようなサイズです。", category: "グラインド"),
        CoffeeTipData(id: 49, title: "粗挽き", content: "粗挽きはフレンチプレスやコールドブリュー用で、粒が大きく抽出時間が長くなります。", category: "グラインド"),
        CoffeeTipData(id: 50, title: "グラインダーの種類", content: "ブレードグラインダーは安価だが粗さが不均一。バーグラインダーは均一な粗さで本格的なコーヒーに必須です。", category: "グラインド"),

        // 温度と時間
        CoffeeTipData(id: 51, title: "抽出温度", content: "コーヒー抽出の最適温度は90-96℃です。100℃だと苦すぎ、低すぎるとはっきりしない味になります。", category: "温度時間"),
        CoffeeTipData(id: 52, title: "抽出時間", content: "ペーパードリップの最適抽出時間は3-4分です。短すぎるとっぱくなり、長すぎると苦くなります。", category: "温度時間"),
        CoffeeTipData(id: 53, title: "最適な飲用温度", content: "コーヒーの最適な飲用温度は60-70℃で、この温度が風味を最も引き出します。熱すぎると舌を火傷します。", category: "温度時間"),
        CoffeeTipData(id: 54, title: "冷めるまでの変化", content: "コーヒーが冷める過程で、異なる香りや風味が感じられます。温度による風味変化を楽しむのもコーヒーの醍醐味です。", category: "温度時間"),
        CoffeeTipData(id: 55, title: "ブルーイングタイム", content: "注湯直後のコーヒーは、炭酸ガスの放出により最初の30秒で香りが最も強くなります。この瞬間を楽しむ価値があります。", category: "温度時間"),

        // 水
        CoffeeTipData(id: 56, title: "水質とコーヒー", content: "コーヒーの約99%は水です。水質がコーヒーの味を大きく左右するため、良い水を使うことが重要です。", category: "水"),
        CoffeeTipData(id: 57, title: "硬水と軟水", content: "軟水はコーヒーの酸味を引き出し、硬水はボディを強調します。好みの水質を見つけることもコーヒーの楽しみです。", category: "水"),
        CoffeeTipData(id: 58, title: "水道水の塩素", content: "水道水の塩素はコーヒーの風味を損ないます。フィルターで塩素を除去するか、浄水器を使うことがおすすめです。", category: "水"),
        CoffeeTipData(id: 59, title: "ミネラル含量", content: "水のミネラル含量はコーヒーの抽出に影響します。適切なミネラル含量で、最適な抽出が可能になります。", category: "水"),
        CoffeeTipData(id: 60, title: "温度の重要性", content: "抽出水の温度が1℃違うだけで、味が変わることもあります。温度計を使って温度管理することで安定した味が得られます。", category: "水"),

        // スペシャルティ
        CoffeeTipData(id: 61, title: "スペシャルティコーヒー", content: "スペシャルティコーヒーは国際的な基準で80点以上のスコアを獲得したコーヒーです。品質が高く、トレーサビリティが明確です。", category: "スペシャルティ"),
        CoffeeTipData(id: 62, title: "シングルオリジン", content: "シングルオリジンは単一の産地や農場から作られたコーヒーで、その土地の個性を強く反映します。", category: "スペシャルティ"),
        CoffeeTipData(id: 63, title: "ブレンド", content: "ブレンドは複数の産地のコーヒーを混ぜたもので、バランスの取れた味わいを目指します。プロのブレンダーのスキルが重要です。", category: "スペシャルティ"),
        CoffeeTipData(id: 64, title: "ナチュラル精製", content: "ナチュラル精製はコーヒーチェリーを乾燥させて果肉を取る方法で、甘みとボディが強い特徴があります。", category: "スペシャルティ"),
        CoffeeTipData(id: 65, title: "ウォッシュド精製", content: "ウォッシュド精製はコーヒーを水で洗浄して果肉を取る方法で、クリーンで爽やかな味わいが特徴です。", category: "スペシャルティ"),

        // コラボ
        CoffeeTipData(id: 66, title: "カフェオレの起源", content: "カフェオレはフランスで生まれた飲み方で、コーヒーと温かいミルクを同量混ぜます。朝食に最適です。", category: "コラボ"),
        CoffeeTipData(id: 67, title: "カプチーノ", content: "カプチーノはイタリア発祥で、エスプレッソに蒸したミルクとミルクフォームを同量ずつ混ぜます。朝のドリンクとして人気です。", category: "コラボ"),
        CoffeeTipData(id: 68, title: "ラテ", content: "ラテはアメリカで人気化した飲み方で、エスプレッソに大量の蒸したミルクを混ぜます。マイルドな味わいが特徴。", category: "コラボ"),
        CoffeeTipData(id: 69, title: "アイスコーヒー", content: "アイスコーヒーは冷たい水で抽出するか、ホットコーヒーに氷を入れて冷やします。夏の定番飲み方です。", category: "コラボ"),
        CoffeeTipData(id: 70, title: "モカ", content: "モカはエスプレッソにチョコレートシロップを加え、ミルクとホイップクリームをトッピングした甘いコーヒーです。", category: "コラボ"),

        // 器具
        CoffeeTipData(id: 71, title: "ドリッパー選び", content: "ドリッパーの形（台形や円錐形）で抽出速度が変わります。自分の好みに合わせて選ぶことが大切です。", category: "器具"),
        CoffeeTipData(id: 72, title: "コーヒースケール", content: "コーヒースケールは正確な計量を可能にし、安定した味わいを実現します。コーヒーを本気で学ぶなら必須アイテムです。", category: "器具"),
        CoffeeTipData(id: 73, title: "温度計", content: "温度計を使うことで、抽出温度を管理し、常に最適な温度でコーヒーを淹れることができます。", category: "器具"),
        CoffeeTipData(id: 74, title: "コーヒーミル", content: "コーヒーミル（グラインダー）は毎日のコーヒーに最も重要な器具です。良いミルはコーヒー人生を変えます。", category: "器具"),
        CoffeeTipData(id: 75, title: "サーモス", content: "サーモス（魔法瓶）はコーヒーを長時間保温できます。保温性が高いほど、長時間美味しさを保てます。", category: "器具"),

        // トレンド
        CoffeeTipData(id: 76, title: "第三波コーヒー", content: "第三波コーヒーはスペシャルティコーヒーの品質を重視し、個性を活かした飲み方を提唱しています。現在の主流です。", category: "トレンド"),
        CoffeeTipData(id: 77, title: "サステイナビリティ", content: "コーヒー業界では、環境と生産者への配慮が重視されています。フェアトレードやオーガニック認証が広がっています。", category: "トレンド"),
        CoffeeTipData(id: 78, title: "ミドルグラウンド", content: "ミドルグラウンドは高級とコンビニの中間価格帯で、品質が良いコーヒーをリーズナブルに楽しむトレンドです。", category: "トレンド"),
        CoffeeTipData(id: 79, title: "ホームカフェ", content: "在宅勤務の普及により、自宅でカフェのような環境を作る「ホームカフェ」が流行しています。", category: "トレンド"),
        CoffeeTipData(id: 80, title: "サブスク", content: "コーヒー豆の定期配送サービスが増えています。新しい豆を試す良い機会になります。", category: "トレンド"),

        // マニアック
        CoffeeTipData(id: 81, title: "コーヒーの色素", content: "コーヒーの茶色はメラノイジンという色素で、焙煎が深いほど色が濃くなります。色で焙煎度がわかります。", category: "マニアック"),
        CoffeeTipData(id: 82, title: "カテゴリークラス", content: "コーヒーのグレードは豆のサイズで決まります。スクリーン18以上が最高等級とされています。", category: "マニアック"),
        CoffeeTipData(id: 83, title: "赤ワイン処理", content: "赤ワイン処理はコーヒーチェリーをワインのように発酵させる精製方法で、複雑な風味が生まれます。", category: "マニアック"),
        CoffeeTipData(id: 84, title: "オーバーファーメンテーション", content: "発酵期間を意図的に長くすると、バナナやパイナップルのような風味が生まれます。実験的なコーヒーです。", category: "マニアック"),
        CoffeeTipData(id: 85, title: "テラロッサ土壌", content: "コーヒー栽培に最適な土壌は赤い火山灰土（テラロッサ）で、ミネラルと排水性に優れています。", category: "マニアック"),

        // 個性
        CoffeeTipData(id: 86, title: "コーヒーの個性を見つける", content: "自分の好みのコーヒーを見つけるには、様々な種類を試すことが大切です。好みは時間で変わることもあります。", category: "個性"),
        CoffeeTipData(id: 87, title: "テイスティングノート", content: "コーヒーを飲むときに風味をメモすることで、自分の好みや違いに気づくことができます。習慣化おすすめです。", category: "個性"),
        CoffeeTipData(id: 88, title: "挽き分け", content: "同じ豆でも異なるグラインドで挽き分けることで、様々な風味を引き出すことができます。", category: "個性"),
        CoffeeTipData(id: 89, title: "ブレンド実験", content: "自分でコーヒー豆をブレンドすることで、オリジナルの味を作り出すことができます。コーヒーの楽しみが広がります。", category: "個性"),
        CoffeeTipData(id: 90, title: "季節の変化", content: "同じコーヒーでも季節によって風味が変わることがあります。季節ごとに異なる表情を楽しむのも醍醐味です。", category: "個性"),

        // 豆知識+
        CoffeeTipData(id: 91, title: "コーヒーと音楽", content: "ある研究では、バロック音楽を聴かせた環境でコーヒーを淹れるとより美味しくなるという結果が出ています。", category: "豆知識"),
        CoffeeTipData(id: 92, title: "コーヒーと読書", content: "コーヒーとの組み合わせで、読書の集中力と記憶定着が向上するとされています。相性の良い組み合わせです。", category: "豆知識"),
        CoffeeTipData(id: 93, title: "コーヒーと創造性", content: "適量のカフェインは創造性を向上させ、新しいアイデアが浮かびやすくなるとされています。クリエイター向きです。", category: "豆知識"),
        CoffeeTipData(id: 94, title: "コーヒーと瞑想", content: "コーヒーの香りを楽しみながら瞑想すると、より深い集中状態に入ることができるとされています。", category: "豆知識"),
        CoffeeTipData(id: 95, title: "コーヒーと睡眠", content: "午後3時以降のカフェイン摂取は睡眠の質を低下させます。朝のコーヒーが最適です。", category: "豆知識"),
        CoffeeTipData(id: 96, title: "コーヒーの香りセラピー", content: "コーヒーの香りを嗅ぐだけで、ストレスが軽減され、リラックス効果が得られるという研究があります。", category: "豆知識"),
        CoffeeTipData(id: 97, title: "世界のコーヒーベルト", content: "赤道の南北23.5度の間（コーヒーベルト）に、世界の約70%のコーヒー生産地があります。気候が最適だからです。", category: "豆知識"),
        CoffeeTipData(id: 98, title: "コーヒーロボスタ", content: "ロボスタ豆は気候変動への耐性が強く、将来のコーヒー産業で重要な役割を果たすと期待されています。", category: "豆知識"),
        CoffeeTipData(id: 99, title: "コーヒーとチョコレート", content: "コーヒーとチョコレートは味わいの相性が良く、コーヒーの苦味がチョコレートの甘みを引き立てます。", category: "豆知識"),
        CoffeeTipData(id: 100, title: "コーヒーの未来", content: "気候変動により、伝統的なコーヒー産地が失われる可能性があります。持続可能な生産方法の開発が急務です。", category: "豆知識")
    ]
}

struct CoffeeTipData {
    let id: Int
    let title: String
    let content: String
    let category: String
}
