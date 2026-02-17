import Foundation

/// 「店主」がユーザーに話しかけるメッセージを生成するエンジン
/// 時間帯とユーザーの状態（ストリーク、前回の失敗理由）に基づいて、気の利いたセリフを生成
struct ShopkeeperEngine {

    /// 店主の挨拶メッセージを生成
    /// - Parameters:
    ///   - streak: 現在のストリーク（連続達成日数）
    ///   - lastFailureReason: 前回失敗した理由（オプション）
    /// - Returns: 店主からのメッセージ
    static func generateGreeting(streak: Int, lastFailureReason: String?) -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        // 優先度1: 失敗からの復帰（前回失敗した理由がある場合）
        if let reason = lastFailureReason, !reason.isEmpty {
            return generateRecoveryMessage(reason: reason, streak: streak)
        }

        // 優先度2: 時間帯別メッセージ
        return generateTimeBasedMessage(hour: hour, streak: streak)
    }

    /// 失敗から復帰する際のメッセージを生成
    private static func generateRecoveryMessage(reason: String, streak: Int) -> String {
        let recoveryMessages = [
            "「昨日は『\(reason)』でしたね。今日は気負わず、軽めからスタートしましょう。」",
            "「『\(reason)』か。そういう日もある。今日は一緒に頑張りましょう。」",
            "「昨日の『\(reason)』は、あなたへの試練です。乗り越えれば、ひと段階成長する。」",
            "「『\(reason)』で途切れたなら、ここから繋ぎ直す。そういう習慣もある。」"
        ]
        return recoveryMessages.randomElement() ?? "「昨日のことは忘れて、また新しい朝が来ました。」"
    }

    /// 時間帯に応じたメッセージを生成
    private static func generateTimeBasedMessage(hour: Int, streak: Int) -> String {
        switch hour {
        case 5..<10: // 早朝〜朝
            return generateMorningMessage(streak: streak)
        case 10..<12: // 午前
            return generateLatemorningMessage(streak: streak)
        case 12..<15: // 昼
            return generateNoonMessage(streak: streak)
        case 15..<18: // 午後
            return generateAfternoonMessage(streak: streak)
        case 18..<21: // 夜
            return generateEveningMessage(streak: streak)
        default: // 深夜
            return generateLatenightMessage(streak: streak)
        }
    }

    private static func generateMorningMessage(streak: Int) -> String {
        let messages = [
            "「おはようございます。熱いコーヒーが入りましたよ。」",
            "「おはようございます。新しい朝が来ました。希望の香りがします。」",
            "「朝の光が気持ちいい。さあ、一杯どうぞ。」",
        ]

        if streak >= 7 {
            return "「おはようございます。常連さんの顔を見ると、朝のドリップにも気合が入ります。」"
        }

        return messages.randomElement() ?? "「おはようございます。」"
    }

    private static func generateLatemorningMessage(streak: Int) -> String {
        let messages = [
            "「そろそろ集中したい時間ですね。特別なブレンドをどうぞ。」",
            "「朝のうちに一つ、片付けましょう。」",
        ]
        return messages.randomElement() ?? "「いい時間ですね。」"
    }

    private static func generateNoonMessage(streak: Int) -> String {
        let messages = [
            "「昼休みです。少し休憩して、午後の作戦を立てましょう。」",
            "「昼食の後の一杯。ここが大事です。」",
            "「午前の成果はどうでしたか？午後も一緒に頑張りましょう。」",
        ]
        return messages.randomElement() ?? "「お昼ですね。」"
    }

    private static func generateAfternoonMessage(streak: Int) -> String {
        let messages = [
            "「こんなに続いているなんて。あなたの集中力、半端ないです。」",
            "「午後の疲れはコーヒーで吹き飛ばしましょう。」",
            "「もう一息。ラスト・スパート、行きましょう。」",
        ]

        if streak >= 14 {
            return "「マスター級のあなたなら、この時間帯も乗り越えられる。」"
        }

        return messages.randomElement() ?? "「午後も頑張ってください。」"
    }

    private static func generateEveningMessage(streak: Int) -> String {
        let messages = [
            "「お疲れ様です。今日の成果を振り返りながら、静かな一杯をどうぞ。」",
            "「夜の落ち着いた時間。自分を褒めてあげてください。」",
            "「一日の終わりに、自分との対話。素敵ですね。」",
        ]
        return messages.randomElement() ?? "「夜のひと時。」"
    }

    private static func generateLatenightMessage(streak: Int) -> String {
        let messages = [
            "「こんな時間まで…。無理は禁物ですが、あなたの情熱には敬服します。」",
            "「深夜の集中力。寝坊しないようにね。」",
            "「夜更かしは味方に、敵にもなります。ほどほどに。」",
        ]
        return messages.randomElement() ?? "「夜中ですね。」"
    }
}
