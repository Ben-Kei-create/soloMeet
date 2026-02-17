import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var morningNotificationTime = Date()
    @State private var eveningNotificationTime = Date()
    @State private var showNotificationAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Notifications Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("通知設定")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .padding(.horizontal, 16)

                        VStack(spacing: 12) {
                            Toggle(isOn: $notificationsEnabled) {
                                HStack(spacing: 12) {
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))
                                        .frame(width: 24)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("通知を有効化")
                                            .font(.system(size: 16, weight: .semibold, design: .default))

                                        Text("朝と夜に最優先タスクのリマインダーを受け取ります")
                                            .font(.system(size: 12, weight: .regular, design: .default))
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .onChange(of: notificationsEnabled) { oldValue, newValue in
                                if newValue {
                                    NotificationManager.shared.scheduleNotifications()
                                } else {
                                    NotificationManager.shared.cancelAllNotifications()
                                }
                            }

                            Divider()

                            if notificationsEnabled {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("朝の通知時刻")
                                            .font(.system(size: 14, weight: .semibold, design: .default))

                                        Spacer()

                                        Text("7:00 AM")
                                            .font(.system(size: 14, weight: .regular, design: .default))
                                            .foregroundColor(.secondary)
                                    }

                                    HStack {
                                        Text("夜の通知時刻")
                                            .font(.system(size: 14, weight: .semibold, design: .default))

                                        Spacer()

                                        Text("6:00 PM")
                                            .font(.system(size: 14, weight: .regular, design: .default))
                                            .foregroundColor(.secondary)
                                    }

                                    Button(action: {
                                        showNotificationAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 14))
                                                .foregroundColor(.green)

                                            Text("通知設定を確認")
                                                .font(.system(size: 14, weight: .semibold, design: .default))

                                            Spacer()
                                        }
                                        .padding(12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                                    .alert("通知設定", isPresented: $showNotificationAlert) {
                                        Button("確認") { }
                                    } message: {
                                        Text("朝7時と夜6時に、タスク関連の通知が配信されます。")
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                    }

                    // About Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("アプリについて")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .padding(.horizontal, 16)

                        VStack(spacing: 12) {
                            SettingRowView(
                                title: "アプリバージョン",
                                value: "1.0.0"
                            )

                            Divider()

                            SettingRowView(
                                title: "開発者",
                                value: "Solo Meet Team"
                            )

                            Divider()

                            SettingRowView(
                                title: "プライバシーポリシー",
                                value: "表示",
                                isLink: true
                            )
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                    }

                    Spacer()
                }
                .padding(16)
            }
            .background(Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.92, alpha: 1)))
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingRowView: View {
    let title: String
    let value: String
    let isLink: Bool

    init(title: String, value: String, isLink: Bool = false) {
        self.title = title
        self.value = value
        self.isLink = isLink
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundColor(.black)

            Spacer()

            if isLink {
                HStack(spacing: 4) {
                    Text(value)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundColor(.blue)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.blue)
                }
            } else {
                Text(value)
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
}
