import UIKit
import UserNotifications
import SwiftData

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // App全体で使う ModelContainer への参照
    static var modelContainer: ModelContainer?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Notification delegate を設定
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // MARK: - Notification Delegate Methods

    /// フォアグラウンド中に通知を受け取る
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo

        print("📬 Foreground notification received:")
        print("   Title: \(notification.request.content.title)")
        print("   Body: \(notification.request.content.body)")

        // フォアグラウンドでもアラートとサウンドを表示
        completionHandler([.banner, .sound, .badge])
    }

    /// バックグラウンド・フォアグラウンド共通で、ユーザーが通知をタップした時
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let actionIdentifier = response.actionIdentifier

        print("📲 Notification tapped:")
        print("   Action Identifier: \(actionIdentifier)")
        print("   UserInfo: \(userInfo)")

        // Main thread で実行（UIの更新が必要な場合に備えて）
        DispatchQueue.main.async {
            // 通知本文をタップ（デフォルトアクション）
            if actionIdentifier == UNNotificationDefaultActionIdentifier {
                print("🔗 通知本文がタップされました（Deep Link）")
                self.handleNotificationDeepLink(userInfo: userInfo)
            } else {
                // カスタムアクション（完了、スキップ等）
                print("🔘 通知アクションが選択されました")
                NotificationManager.shared.handleNotificationAction(
                    identifier: actionIdentifier,
                    userInfo: userInfo
                )
            }
        }

        completionHandler()
    }

    // MARK: - Deep Link Handler

    /// 通知本文タップ時の処理（ダイアログを表示）
    private func handleNotificationDeepLink(userInfo: [AnyHashable: Any]) {
        let action = userInfo["action"] as? String ?? ""

        switch action {
        case "morning_greeting":
            print("🌅 朝のグリーティング → ダイアログを表示")
            NotificationCenter.default.post(name: NSNotification.Name("OpenProgressDialog"), object: userInfo)

        case "evening_review":
            print("🌙 夜のおさらい → ダイアログを表示")
            NotificationCenter.default.post(name: NSNotification.Name("OpenProgressDialog"), object: userInfo)

        default:
            print("⚠️ 不明なアクション: \(action)")
        }
    }

    // MARK: - UISceneDelegate Methods

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}
