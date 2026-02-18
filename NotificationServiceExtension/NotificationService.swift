import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
            contentHandler(request.content)
            return
        }

        // userInfo から Rich Notification 情報を取得
        let userInfo = request.content.userInfo
        let imageIdentifier = userInfo["imageIdentifier"] as? String ?? ""
        let roastType = userInfo["roastType"] as? String ?? ""

        print("📸 Notification Service Extension received:")
        print("   roastType: \(roastType)")
        print("   imageIdentifier: \(imageIdentifier)")

        // 豆の色に応じた画像を添付
        attachCoffeeImage(to: bestAttemptContent, imageIdentifier: imageIdentifier, roastType: roastType)

        // 通知を表示
        contentHandler(bestAttemptContent)
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    // MARK: - Rich Notification Helper

    private func attachCoffeeImage(to content: UNMutableNotificationContent, imageIdentifier: String, roastType: String) {
        // アプリバンドルから画像を取得（Xcodeで手動追加した画像ファイル）
        if let imageURL = Bundle.main.url(forResource: imageIdentifier, withExtension: "png") {
            do {
                let attachment = try UNNotificationAttachment(identifier: imageIdentifier, url: imageURL, options: nil)
                content.attachments = [attachment]
                print("✅ 画像を添付しました: \(imageIdentifier)")
            } catch {
                print("❌ 画像添付エラー: \(error.localizedDescription)")
                // 代替として、豆の状態をタイトル下に表示
                content.subtitle = roastType
            }
        } else {
            print("⚠️ 画像ファイルが見つかりません: \(imageIdentifier).png")
            // 代替として、豆の状態をサブタイトルに表示
            content.subtitle = roastType
        }
    }
}
