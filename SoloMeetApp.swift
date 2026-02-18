import SwiftUI
import SwiftData

@main
struct SoloMeetApp: App {
    let modelContainer: ModelContainer

    // AppDelegate を登録
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        let schema = Schema([
            Task.self,
            MeetingLog.self,
            UserProfile.self,
            CoffeeTip.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            // Initialize sample data on first launch
            initializeSampleData()
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .onAppear {
                    NotificationManager.shared.requestNotificationPermission()
                }
        }
    }

    private func initializeSampleData() {
        let context = ModelContext(modelContainer)

        // Check if data already exists
        var fetchDescriptor = FetchDescriptor<Task>()
        let existingTasks = try? context.fetch(fetchDescriptor)

        guard existingTasks?.isEmpty ?? true else { return }

        // Create sample tasks
        let sampleTasks = [
            Task(
                title: "朝の瞑想",
                goal: "心を整えて1日をスタート",
                maxim: "今この瞬間に集中する",
                frequency: .daily,
                currentStreak: 3,
                status: .pending
            ),
            Task(
                title: "読書",
                goal: "月3冊の本を読む",
                maxim: "知識は無限の力",
                frequency: .daily,
                currentStreak: 1,
                status: .pending
            ),
            Task(
                title: "運動",
                goal: "健康的な体を保つ",
                maxim: "体が資本",
                frequency: .daily,
                currentStreak: 2,
                status: .pending
            )
        ]

        sampleTasks.forEach { context.insert($0) }

        // Create user profile
        let userProfile = UserProfile(totalBeans: 45, isPremium: false)
        context.insert(userProfile)

        // Initialize 100 coffee tips
        CoffeeTipsDatabase.tips.forEach { tipData in
            let tip = CoffeeTip(
                id: tipData.id,
                title: tipData.title,
                content: tipData.content,
                category: tipData.category,
                isUnlocked: false
            )
            context.insert(tip)
        }

        do {
            try context.save()
        } catch {
            print("Failed to save sample data: \(error)")
        }
    }
}
