import UserNotifications
import SwiftData

struct NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                scheduleNotifications()
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotifications() {
        // Remove all existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        // Setup notification categories with actions
        setupNotificationCategories()

        // Schedule daily morning notification at 7:00 AM
        scheduleMorningNotification()

        // Schedule evening reminder at 6:00 PM
        scheduleEveningNotification()
    }

    // MARK: - Interactive Notification Setup

    private func setupNotificationCategories() {
        // 完了アクション
        let completeAction = UNNotificationAction(
            identifier: "COMPLETE_ACTION",
            title: "✅ 完了",
            options: [.foreground]
        )

        // スキップアクション
        let skipAction = UNNotificationAction(
            identifier: "SKIP_ACTION",
            title: "⏭️ スキップ",
            options: []
        )

        // 後で通知するアクション
        let remindLaterAction = UNNotificationAction(
            identifier: "REMIND_LATER",
            title: "🔔 5分後に再通知",
            options: []
        )

        // モーニングカテゴリ
        let morningCategory = UNNotificationCategory(
            identifier: "MORNING_CATEGORY",
            actions: [completeAction, skipAction],
            intentIdentifiers: [],
            options: []
        )

        // イブニングカテゴリ
        let eveningCategory = UNNotificationCategory(
            identifier: "EVENING_CATEGORY",
            actions: [completeAction, remindLaterAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([morningCategory, eveningCategory])
    }

    private func scheduleMorningNotification() {
        let morningContent = UNMutableNotificationContent()

        // 店主のグリーティングメッセージを生成（簡易版：ストリークデータはサンドボックス環境では取得困難なため）
        let shopkeeperMessage = ShopkeeperEngine.generateGreeting(streak: 7, lastFailureReason: nil)

        morningContent.title = "☕ 朝のコーヒータイム"
        morningContent.body = shopkeeperMessage
        morningContent.sound = .default
        morningContent.badge = NSNumber(value: 1)
        morningContent.categoryIdentifier = "MORNING_CATEGORY"

        // Deep link to app
        morningContent.userInfo = ["action": "morning_greeting"]

        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "morningNotification", content: morningContent, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling morning notification: \(error.localizedDescription)")
            }
        }
    }

    private func scheduleEveningNotification() {
        let eveningContent = UNMutableNotificationContent()

        // 店主のイブニングメッセージを生成
        let shopkeeperMessage = ShopkeeperEngine.generateGreeting(streak: 7, lastFailureReason: nil)

        eveningContent.title = "☕ 夜のおさらい時間"
        eveningContent.body = shopkeeperMessage
        eveningContent.sound = .default
        eveningContent.categoryIdentifier = "EVENING_CATEGORY"

        // Deep link to app
        eveningContent.userInfo = ["action": "evening_review"]

        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "eveningNotification", content: eveningContent, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling evening notification: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Notification Handling

    func handleNotificationAction(identifier: String, userInfo: [AnyHashable: Any]) {
        print("Notification action: \(identifier)")

        switch identifier {
        case "COMPLETE_ACTION":
            print("✅ ユーザーが 完了 を選択")
            // TODO: MeetingLog に完了ログを追加

        case "SKIP_ACTION":
            print("⏭️ ユーザーが スキップ を選択")
            // TODO: MeetingLog にスキップログを追加

        case "REMIND_LATER":
            print("🔔 5分後に再通知")
            scheduleReminder(afterSeconds: 300)

        default:
            break
        }
    }

    private func scheduleReminder(afterSeconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "☕ 再度のお願い"
        content.body = "お時間ができましたら、お立ち寄りください。"
        content.sound = .default
        content.categoryIdentifier = "EVENING_CATEGORY"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: afterSeconds, repeats: false)
        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling reminder: \(error.localizedDescription)")
            }
        }
    }

    func checkPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("Pending notifications: \(requests.count)")
            for request in requests {
                print("- \(request.identifier): \(request.content.title)")
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
