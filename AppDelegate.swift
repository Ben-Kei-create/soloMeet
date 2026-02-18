import UIKit
import UserNotifications
import SwiftData

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

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

    /// バックグラウンドから戻ってきて、ユーザーが通知をタップした時
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let actionIdentifier = response.actionIdentifier

        print("📲 Notification action received:")
        print("   Action: \(actionIdentifier)")

        // 通知アクションを処理
        NotificationManager.shared.handleNotificationAction(
            identifier: actionIdentifier,
            userInfo: userInfo
        )

        completionHandler()
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
