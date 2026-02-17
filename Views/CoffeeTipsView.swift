import SwiftUI
import SwiftData

struct CoffeeTipsView: View {
    @Query private var tips: [CoffeeTip]
    @Query private var userProfile: [UserProfile]

    @State private var selectedCategory: String? = nil
    @State private var searchText = ""
    @State private var showLockedTips = false

    var unlockedTips: [CoffeeTip] {
        tips.filter { $0.isUnlocked }.sorted { ($0.unlockedDate ?? Date()) > ($1.unlockedDate ?? Date()) }
    }

    var lockedTipsCount: Int {
        tips.count - unlockedTips.count
    }

    var filteredTips: [CoffeeTip] {
        var filtered = showLockedTips ? tips : unlockedTips

        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }

        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        return filtered.sorted { ($0.unlockedDate ?? Date.distantPast) > ($1.unlockedDate ?? Date.distantPast) }
    }

    var categories: [String] {
        Array(Set(tips.map { $0.category })).sorted()
    }

    var unlockedPercentage: Double {
        guard !tips.isEmpty else { return 0 }
        return Double(unlockedTips.count) / Double(tips.count)
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

                    // Progress bar
                    VStack(alignment: .leading, spacing: 6) {
                        ProgressView(value: unlockedPercentage)
                            .tint(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))
                            .frame(height: 8)

                        Text("\(Int(unlockedPercentage * 100))%完成")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.secondary)
                    }

                    .padding(20)
                    .background(Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.5)))
                }

                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    TextField("豆知識を検索", text: $searchText)
                        .font(.system(size: 14, design: .default))

                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(8)
                .padding(16)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button(action: { selectedCategory = nil }) {
                            Text("すべて")
                                .font(.system(size: 12, weight: .semibold, design: .default))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedCategory == nil ? Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)) : Color.white)
                                .foregroundColor(selectedCategory == nil ? .white : .black)
                                .cornerRadius(4)
                                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.2)))
                        }

                        ForEach(categories, id: \.self) { category in
                            Button(action: { selectedCategory = category }) {
                                Text(category)
                                    .font(.system(size: 12, weight: .semibold, design: .default))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedCategory == category ? Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)) : Color.white)
                                    .foregroundColor(selectedCategory == category ? .white : .black)
                                    .cornerRadius(4)
                                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.gray.opacity(0.2)))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Toggle locked tips
                HStack {
                    Spacer()
                    Toggle(isOn: $showLockedTips) {
                        Text("ロック中も表示")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                }

                // Tips list
                ScrollView {
                    VStack(spacing: 12) {
                        if filteredTips.isEmpty {
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
                            ForEach(filteredTips, id: \.id) { tip in
                                CoffeeTipCardView(tip: tip, isLocked: !tip.isUnlocked)
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
    let isLocked: Bool
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(isLocked ? "🔒" : "☕")
                            .font(.system(size: 16))

                        Text(tip.title)
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .foregroundColor(isLocked ? .secondary : Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))

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
                    } else if isLocked {
                        Text("タスク完了でアンロック")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }

                Spacer()

                if !isLocked {
                    Button(action: { isExpanded.toggle() }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
            }

            if isExpanded && !isLocked {
                Divider()

                Text(tip.content)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .lineSpacing(4)
                    .foregroundColor(.black)
            }
        }
        .padding(16)
        .background(isLocked ? Color(.systemGray6) : Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .opacity(isLocked ? 0.6 : 1.0)
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
