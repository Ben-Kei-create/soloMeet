import Foundation
import SwiftData

@Model
final class UserProfile {
    var totalBeans: Int = 0
    var isPremium: Bool = false
    var lastLoginDate: Date = Date()
    var totalTasksCompleted: Int = 0
    var currentStreak: Int = 0

    init(
        totalBeans: Int = 0,
        isPremium: Bool = false
    ) {
        self.totalBeans = totalBeans
        self.isPremium = isPremium
        self.lastLoginDate = Date()
    }
}
