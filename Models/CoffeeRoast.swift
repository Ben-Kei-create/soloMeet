import SwiftUI

/// ストリーク数に応じたコーヒー豆の焙煎度を表現する列挙型
/// ユーザーの継続日数が増えるにつれて、豆の焙煎度が深まっていく
enum CoffeeRoast {
    case green      // 生豆・フレッシュ (0-2日)
    case medium     // 中煎り (3-6日)
    case dark       // 深煎り (7-13日)
    case italian    // 極深煎り・マスター (14日以上: 達人)

    /// ストリーク数から現在の焙煎度を決定
    static func current(streak: Int) -> CoffeeRoast {
        switch streak {
        case 0...2:
            return .green
        case 3...6:
            return .medium
        case 7...13:
            return .dark
        default:
            return .italian
        }
    }

    /// 焙煎度に応じた色を返す
    var color: Color {
        switch self {
        case .green:
            return Color(red: 0.6, green: 0.7, blue: 0.5) // フレッシュな緑
        case .medium:
            return Color(red: 0.6, green: 0.4, blue: 0.2) // 綺麗な茶色
        case .dark:
            return Color(red: 0.4, green: 0.25, blue: 0.1) // 艶のある焦げ茶
        case .italian:
            return Color(red: 0.2, green: 0.1, blue: 0.05) // 漆黒に近い黒
        }
    }

    /// 焙煎度の日本語名
    var name: String {
        switch self {
        case .green:
            return "フレッシュ・グリーン"
        case .medium:
            return "ミディアム・ロースト"
        case .dark:
            return "ダーク・ロースト"
        case .italian:
            return "マスターズ・イタリアン"
        }
    }

    /// 焙煎度のセクション（シンボル）
    var emoji: String {
        switch self {
        case .green:
            return "🌱"
        case .medium:
            return "☕"
        case .dark:
            return "🫘"
        case .italian:
            return "✨"
        }
    }

    /// Rich Notification 用のイメージ識別子
    var imageIdentifier: String {
        switch self {
        case .green:
            return "coffee_green"
        case .medium:
            return "coffee_medium"
        case .dark:
            return "coffee_dark"
        case .italian:
            return "coffee_italian"
        }
    }

    /// Rich Notification 用のディープリンクデータ
    var notificationUserInfo: [String: Any] {
        return [
            "roastType": self.name,
            "imageIdentifier": self.imageIdentifier,
            "emoji": self.emoji,
            "colorHex": self.colorHex
        ]
    }

    /// 16進数カラーコード（Notification Extension で使用）
    var colorHex: String {
        switch self {
        case .green:
            return "#9AB380"  // rgb(154, 179, 128)
        case .medium:
            return "#996633"  // rgb(153, 102, 51)
        case .dark:
            return "#664414"  // rgb(102, 68, 20)
        case .italian:
            return "#331800"  // rgb(51, 24, 0)
        }
    }
}
