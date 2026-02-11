import SwiftUI
import SwiftData

struct CoffeeTipsView: View {
    @Query private var tips: [CoffeeTip]
    @Query private var userProfile: [UserProfile]

    var unlockedTips: [CoffeeTip] {
        tips.filter { $0.isUnlocked }.sorted { ($0.unlockedDate ?? Date()) > ($1.unlockedDate ?? Date()) }
    }

    var lockedTipsCount: Int {
        tips.count - unlockedTips.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with stats
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("コーヒー豆知識")
                                .font(.system(size: 24, weight: .bold, design: .default))

                            Text("\(unlockedTips.count) / \(tips.count) アンロック済み")
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if !userProfile.isEmpty {
                            VStack(alignment: .trailing, spacing: 4) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.yellow)

                                    Text("\(userProfile[0].totalBeans)")
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                }

                                Text("コーヒービーン")
                                    .font(.system(size: 12, weight: .regular, design: .default))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.5)))
                }

                // Tips list
                ScrollView {
                    VStack(spacing: 12) {
                        if unlockedTips.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)

                                Text("豆知識はまだありません")
                                    .font(.system(size: 16, weight: .semibold, design: .default))

                                Text("タスクを完了して豆知識をアンロックしよう！")
                                    .font(.system(size: 14, weight: .regular, design: .default))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                        } else {
                            ForEach(unlockedTips, id: \.id) { tip in
                                CoffeeTipCardView(tip: tip)
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .background(Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.92, alpha: 1)))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Coffee Tip Card

struct CoffeeTipCardView: View {
    let tip: CoffeeTip
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("☕")
                            .font(.system(size: 16))

                        Text(tip.title)
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))

                        Spacer()

                        Text(tip.category)
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))
                            .cornerRadius(4)
                    }

                    if let unlockedDate = tip.unlockedDate {
                        Text("アンロック日時: \(formattedDate(unlockedDate))")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }

            if isExpanded {
                Divider()

                Text(tip.content)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .lineSpacing(4)
                    .foregroundColor(.black)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

#Preview {
    CoffeeTipsView()
        .modelContainer(for: CoffeeTip.self, inMemory: true)
}
