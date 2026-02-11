import Foundation
import SwiftData

@Model
final class CoffeeTip {
    var id: Int
    var title: String
    var content: String
    var category: String
    var isUnlocked: Bool = false
    var unlockedDate: Date?

    init(
        id: Int,
        title: String,
        content: String,
        category: String,
        isUnlocked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.isUnlocked = isUnlocked
    }
}
