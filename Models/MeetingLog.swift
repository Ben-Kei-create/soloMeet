import Foundation
import SwiftData

@Model
final class MeetingLog {
    var date: Date
    var successStatus: Bool
    var failureReason: String?
    var coffeeTipId: Int?
    var notes: String?

    init(
        date: Date = Date(),
        successStatus: Bool,
        failureReason: String? = nil,
        coffeeTipId: Int? = nil,
        notes: String? = nil
    ) {
        self.date = date
        self.successStatus = successStatus
        self.failureReason = failureReason
        self.coffeeTipId = coffeeTipId
        self.notes = notes
    }
}
