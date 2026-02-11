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

        // Schedule daily morning notification at 7:00 AM
        scheduleMorningNotification()

        // Schedule evening reminder at 6:00 PM
        scheduleEveningNotification()
    }

    private func scheduleMorningNotification() {
        let morningContent = UNMutableNotificationContent()
        morningContent.title = "おはようございます☕"
        morningContent.body = "今日も一緒に頑張ろう！まずは最初のタスクから始めましょう。"
        morningContent.sound = .default
        morningContent.badge = NSNumber(value: 1)

        // Add motivational messages based on previous day
        let motivationalMessages = [
            "昨日の努力は必ず報われます",
            "完璧を目指さず、続けることが大切です",
            "今この瞬間に集中しましょう",
            "小さな成功の積み重ねが大きな変化を生みます",
            "自分を信じて、今日も頑張ろう",
            "一日一日が人生を変える力を持っています",
            "コーヒーを飲みながら、今日のゴールを思い出そう",
            "失敗は成功への道。進み続けることが重要です"
        ]

        if let randomMessage = motivationalMessages.randomElement() {
            morningContent.body = randomMessage
        }

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
        eveningContent.title = "今日のタスクは完了しましたか？☕"
        eveningContent.body = "一日のまとめをして、明日に備えましょう。"
        eveningContent.sound = .default

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
