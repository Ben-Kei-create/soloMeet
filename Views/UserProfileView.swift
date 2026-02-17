import SwiftUI
import SwiftData

struct UserProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var userProfiles: [UserProfile]
    @Query(sort: \MeetingLog.date, order: .reverse) private var meetingLogs: [MeetingLog]

    var userProfile: UserProfile? {
        userProfiles.first
    }

    var completionRateThisWeek: Int {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let thisWeekLogs = meetingLogs.filter { $0.date >= weekAgo && $0.successStatus }
        return thisWeekLogs.count
    }

    var completionRateThisMonth: Int {
        let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        let thisMonthLogs = meetingLogs.filter { $0.date >= monthAgo && $0.successStatus }
        return thisMonthLogs.count
    }

    var weeklyCompletionPercentage: Double {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let thisWeekLogs = meetingLogs.filter { $0.date >= weekAgo }
        let successCount = thisWeekLogs.filter { $0.successStatus }.count
        return thisWeekLogs.isEmpty ? 0 : Double(successCount) / Double(thisWeekLogs.count)
    }

    var longestStreak: Int {
        var longest = 0
        var current = 0

        for log in meetingLogs.reversed() {
            if log.successStatus {
                current += 1
                longest = max(longest, current)
            } else {
                current = 0
            }
        }

        return longest
    }

    var totalTasksCompleted: Int {
        meetingLogs.filter { $0.successStatus }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header card
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("プロフィール")
                                    .font(.system(size: 24, weight: .bold, design: .default))

                                if let profile = userProfile {
                                    HStack(spacing: 12) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.yellow)

                                            Text("\(profile.totalBeans)")
                                                .font(.system(size: 18, weight: .semibold, design: .default))
                                        }

                                        Divider()
                                            .frame(height: 20)

                                        HStack(spacing: 4) {
                                            Image(systemName: "flame.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.orange)

                                            Text("\(profile.currentStreak)")
                                                .font(.system(size: 18, weight: .semibold, design: .default))
                                        }

                                        Divider()
                                            .frame(height: 20)

                                        HStack(spacing: 4) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.green)

                                            Text("\(profile.totalTasksCompleted)")
                                                .font(.system(size: 18, weight: .semibold, design: .default))
                                        }
                                    }
                                }
                            }

                            Spacer()
                        }
                        .padding(20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 1)),
                                    Color(#colorLiteral(red: 0.98, green: 0.94, blue: 0.86, alpha: 1))
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .padding(16)

                    // Stats section
                    VStack(spacing: 12) {
                        Text("統計情報")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)

                        VStack(spacing: 8) {
                            StatRowView(
                                title: "今週の完了数",
                                value: "\(completionRateThisWeek) 個",
                                icon: "checkmark.square.fill",
                                color: .green
                            )

                            StatRowView(
                                title: "月間完了数",
                                value: "\(completionRateThisMonth) 個",
                                icon: "calendar.badge.clock",
                                color: .blue
                            )

                            StatRowView(
                                title: "最長ストリーク",
                                value: "\(longestStreak) 日",
                                icon: "flame.fill",
                                color: .orange
                            )

                            StatRowView(
                                title: "週間達成率",
                                value: "\(Int(weeklyCompletionPercentage * 100))%",
                                icon: "chart.pie.fill",
                                color: .purple
                            )

                            StatRowView(
                                title: "総完了タスク数",
                                value: "\(totalTasksCompleted) 個",
                                icon: "list.bullet.clipboard.fill",
                                color: .cyan
                            )
                        }
                        .padding(16)
                        .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    }

                    // Premium section
                    if userProfile?.isPremium == false {
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.yellow)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("常連客パスにアップグレード")
                                        .font(.system(size: 16, weight: .semibold, design: .default))

                                    Text("広告なしでご利用いただけます")
                                        .font(.system(size: 13, weight: .regular, design: .default))
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding(16)
                            .background(Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.3)))
                            .cornerRadius(12)
                            .padding(16)
                        }
                    }

                    // Settings section
                    VStack(spacing: 8) {
                        Text("設定")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)

                        VStack(spacing: 0) {
                            SettingRowView(
                                title: "通知設定",
                                icon: "bell.fill",
                                action: {}
                            )

                            Divider()
                                .padding(.vertical, 0)

                            SettingRowView(
                                title: "データをエクスポート",
                                icon: "square.and.arrow.up.fill",
                                action: {}
                            )

                            Divider()
                                .padding(.vertical, 0)

                            SettingRowView(
                                title: "ヘルプ & フィードバック",
                                icon: "questionmark.circle.fill",
                                action: {}
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    }

                    Spacer()
                        .frame(height: 20)
                }
            }
            .background(Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.92, alpha: 1)))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func formattedLastLogin(_ date: Date?) -> String {
        guard let date = date else { return "-" }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")

        if Calendar.current.isDateInToday(date) {
            return "今日"
        } else if Calendar.current.isDateInYesterday(date) {
            return "昨日"
        } else {
            return formatter.string(from: date)
        }
    }
}

// MARK: - Helper Views

struct StatRowView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(.black)
        }
        .padding(12)
        .background(Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.92, alpha: 0.5)))
        .cornerRadius(8)
    }
}

struct SettingRowView: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))

                Text(title)
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .foregroundColor(.black)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(16)
        }
    }
}

#Preview {
    UserProfileView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}
