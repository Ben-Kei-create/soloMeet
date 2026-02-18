# Rich Notification Setup Guide

このドキュメントは、Notification Service Extension を追加して、通知に画像を埋め込む手順を説明します。

## 📋 必要な準備

- Xcode 14.0 以上
- iOS 14.0 以上をターゲット
- Apple Developer Account（App ID の設定が必要）

---

## 🔧 ステップ1: Notification Service Extension ターゲットを追加

### 1-1. Xcode でプロジェクトを開く

```
File → Open → soloMeet.xcodeproj
```

### 1-2. 新しいターゲットを追加

```
File → New → Target...
   → Filter: "Notification Service Extension"
   → Next
```

### 1-3. ターゲット設定

- **Product Name**: `SoloMeetNotificationService`
- **Language**: Swift
- **Include UI**: ✗ (チェック外す)
- **Team**: 設定可能であれば設定
- Finish

---

## ⚙️ ステップ2: App Groups を設定

（将来的なデータ共有用。現在は画像ファイルで対応）

### 2-1. メインアプリのCapabilities

```
SoloMeet (Project)
  → Signing & Capabilities
    → + Capability
      → App Groups
         → + コンテナ: group.com.solo.meet
```

### 2-2. Extension のCapabilities

```
SoloMeetNotificationService (Target)
  → Signing & Capabilities
    → + Capability
      → App Groups
         → + コンテナ: group.com.solo.meet
         (メインアプリと同じコンテナを指定)
```

---

## 🖼️ ステップ3: コーヒー豆画像アセットを追加

### 3-1. 画像ファイルを準備

以下の 4 つの画像を 320x320px で準備してください：

| 画像ファイル | 用途 | 推奨色 |
|------------|------|-------|
| `coffee_green.png` | フレッシュ・グリーン (0-2日) | #9AB380 (薄い緑) |
| `coffee_medium.png` | ミディアム・ロースト (3-6日) | #996633 (茶色) |
| `coffee_dark.png` | ダーク・ロースト (7-13日) | #664414 (濃い茶色) |
| `coffee_italian.png` | マスターズ・イタリアン (14日+) | #331800 (黒) |

### 3-2. Xcode にアセットを追加

**メインアプリに追加:**

```
Assets.xcassets に上記 4 つの PNG を追加
```

**Extension にもコピー:**

```
SoloMeetNotificationService フォルダ内に
上記 4 つの PNG をコピー
（または Xcode で Assets.xcassets を共有設定）
```

---

## 📝 ステップ4: Extension ファイルをコピー

### 4-1. NotificationService.swift をコピー

クローンしたリポジトリの `NotificationServiceExtension/NotificationService.swift` の内容を、Xcode が自動生成した NotificationService.swift に**置き換えてください**。

```
SoloMeetNotificationService/NotificationService.swift
```

### 4-2. Target Membership を確認

NotificationService.swift が以下のターゲットに属していることを確認：

- ✓ SoloMeetNotificationService
- ✓ SoloMeet (オプション)

---

## 🎯 ステップ5: Build Settings を確認

### 5-1. Minimum Deployments

```
SoloMeetNotificationService (Target)
  → Build Settings
    → Minimum Deployments: iOS 14.0 以上
```

### 5-2. Deployment Target

```
SoloMeetNotificationService
  → General
    → Minimum Deployments: iOS 14.0 以上
```

---

## 🧪 テスト方法

### テスト1: ビルドが成功するか

```bash
Xcode → Product → Build
  → ✅ Build Succeeded か確認
```

### テスト2: シミュレーターで実行

```bash
Xcode → Product → Run
  → シミュレーター起動
  → アプリ起動
  → 通知パーミッション許可
```

### テスト3: 朝の通知をテスト

**Device Features で時間を 07:00 に設定:**

```
Xcode → Debug → Simulate Background Fetch
または
Device → Features → Time Override → 07:00
```

**通知が表示されたか確認:**

```
✅ ロック画面に「☕ 朝のコーヒータイム」が表示
✅ 通知の右側に豆の画像が表示される
✅ テキスト + 画像 = Rich Notification 完成！
```

### テスト4: コンソール出力を確認

Xcode Console で以下が表示されているか確認：

```
📸 Notification Service Extension received:
   roastType: ミディアム・ロースト
   imageIdentifier: coffee_medium
✅ 画像を添付しました: coffee_medium
```

---

## 🐛 トラブルシューティング

### Issue: 画像が表示されない

**原因1: ファイルが見つからない**

```
❌ "画像ファイルが見つかりません: coffee_medium.png"
```

**解決策:**
- Assets.xcassets に正しい名前で PNG が追加されているか確認
- Build Phases → Copy Bundle Resources で画像が含まれているか確認

**原因2: ファイル名が違う**

```
NotificationManager.swift で "coffee_medium" と指定
Assets に "coffee_medium.png" が必要
```

---

### Issue: Extension がビルドできない

**原因: Deployment Target が合わない**

```
SoloMeet: iOS 14.0
SoloMeetNotificationService: iOS 16.0 ← 違う！
```

**解決策:**

```
両ターゲットの Minimum Deployments を揃える
```

---

### Issue: 通知が表示されるが、Extension が実行されない

**原因: Notification Service Extension が非アクティブ**

```
Settings → Developer → Low Power Mode が ON？
```

**解決策:**

```
Settings → Battery
   → Low Power Mode: OFF にしてテスト
```

---

## 📱 実装後の動作フロー

```
1️⃣ ユーザーが朝 7:00 に通知を受け取る

2️⃣ OS が NotificationService Extension を起動

3️⃣ userInfo から roastType を読取
   ├─ "coffee_green"
   ├─ "coffee_medium"
   ├─ "coffee_dark"
   └─ "coffee_italian"

4️⃣ 対応する PNG ファイルを添付

5️⃣ 通知が Rich Notification として表示
   ┌──────────────────────────┐
   │ ☕ 朝のコーヒータイム    │
   │                          │
   │ 「おはようございます。」 │  🫘 ← 豆の画像！
   │                          │
   │ [✅ 完了] [⏭️ スキップ]  │
   └──────────────────────────┘

6️⃣ ユーザーが [✅ 完了] をタップ

7️⃣ MeetingLog に記録 ✅
```

---

## 🎨 画像生成の代替案

手動で 4 つの PNG を作成するのが大変な場合：

### Option A: オンライン画像生成

```
https://www.photopea.com/
   → 320x320px キャンバス
   → 円形グラデーション
   → 色: #996633 (ミディアム用)
   → Export as PNG
```

### Option B: SwiftUI で画像生成

```swift
// Simple implementation:
func generateCoffeeImage(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 320, height: 320)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    color.setFill()
    UIBezierPath(ovalIn: rect).fill()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
}
```

---

## ✅ チェックリスト

- [ ] Notification Service Extension ターゲットを作成
- [ ] App Groups capability を追加
- [ ] コーヒー豆画像 4 つを準備
- [ ] NotificationService.swift を置き換え
- [ ] Build Phases で画像が含まれているか確認
- [ ] Minimum Deployment を揃えた
- [ ] シミュレーターで画像が表示されるか確認
- [ ] コンソールにエラーがないか確認

---

## 🎉 完成形

```
【通知ロック画面】

┌─────────────────────────────┐
│ 09:41                       │
│                             │
│ ☕ 朝のコーヒータイム      │ 🫘 ← Rich Image
│ 「おはようございます...」  │
│ [✅ 完了] [⏭️ スキップ]   │
└─────────────────────────────┘
```

**「通知に香り（画像）が乗った」瞬間、UX は次の次元へ！** ✨

---

## 📚 参考資料

- [Apple Developer: User Notifications](https://developer.apple.com/documentation/usernotifications)
- [UNNotificationServiceExtension](https://developer.apple.com/documentation/usernotifications/unnotificationserviceextension)
- [Notification Attachments](https://developer.apple.com/documentation/usernotifications/unnotificationattachment)
