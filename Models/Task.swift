import SwiftUI
import SwiftData

@Model
final class Task {
    var title: String
    var goal: String
    var maxim: String
    var frequency: TaskFrequency = .daily
    var currentStreak: Int = 0
    var status: TaskStatus = .pending
    var createdDate: Date = Date()
    var lastCompletedDate: Date?

    init(
        title: String,
        goal: String,
        maxim: String,
        frequency: TaskFrequency = .daily,
        currentStreak: Int = 0,
        status: TaskStatus = .pending
    ) {
        self.title = title
        self.goal = goal
        self.maxim = maxim
        self.frequency = frequency
        self.currentStreak = currentStreak
        self.status = status
    }
}

enum TaskFrequency: String, Codable {
    case daily = "日次"
    case weekly = "週次"
    case monthly = "月次"
}

enum TaskStatus: String, Codable {
    case pending = "未完了"
    case completed = "完了"
    case partial = "一部完了"
}
