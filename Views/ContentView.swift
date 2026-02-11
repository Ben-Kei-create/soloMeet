import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [Task]
    @Query private var userProfile: [UserProfile]

    @State private var showProgressDialog = false
    @State private var selectedTaskIndex = 0
    @State private var progress: Double = 0.65
    @State private var selectedTab: TabType = .home

    enum TabType {
        case home
        case tasks
        case tips
        case profile
    }

    var currentTask: Task? {
        guard !tasks.isEmpty else { return nil }
        return tasks[selectedTaskIndex % tasks.count]
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            homeView
                .tabItem {
                    Label("ホーム", systemImage: "cup.and.saucer.fill")
                }
                .tag(TabType.home)

            // Tasks Tab
            TaskListView()
                .tabItem {
                    Label("タスク", systemImage: "checklist")
                }
                .tag(TabType.tasks)

            // Coffee Tips Tab
            CoffeeTipsView()
                .tabItem {
                    Label("豆知識", systemImage: "book.fill")
                }
                .tag(TabType.tips)

            // Profile Tab
            UserProfileView()
                .tabItem {
                    Label("プロフィール", systemImage: "person.fill")
                }
                .tag(TabType.profile)
        }
        .accentColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))
    }

    private var homeView: some View {
        ZStack {
            // Background with time-based color
            backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Section: Goal & Maxim
                topSection
                    .padding(.top, 40)
                    .padding(.horizontal, 20)

                Spacer()

                // Center Section: Coffee Cup
                coffeeCupSection
                    .frame(height: 300)

                Spacer()

                // Bottom Section: Ad Space
                adBannerSection
                    .frame(height: 60)
                    .padding(.bottom, 10)
            }
        }
        .sheet(isPresented: $showProgressDialog) {
            ProgressDialogView(
                task: currentTask,
                isPresented: $showProgressDialog,
                onComplete: handleTaskCompletion
            )
        }
        .onAppear {
            setupInitialState()
        }
    }

    // MARK: - Subviews

    private var topSection: some View {
        VStack(alignment: .center, spacing: 16) {
            if let task = currentTask {
                VStack(spacing: 8) {
                    Text(task.goal)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .tracking(0.5)

                    Text("「\(task.maxim)」")
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundColor(.white.opacity(0.8))
                        .italic()
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 0.3)))
                .cornerRadius(12)
            }
        }
    }

    private var coffeeCupSection: some View {
        VStack {
            ZStack(alignment: .bottom) {
                // Cup outline
                CoffeeCupView(fillPercentage: progress)
                    .stroke(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)), lineWidth: 2)

                // Coffee liquid
                CoffeeCupView(fillPercentage: progress)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(#colorLiteral(red: 0.62, green: 0.47, blue: 0.35, alpha: 1)),
                                Color(#colorLiteral(red: 0.42, green: 0.28, blue: 0.20, alpha: 1))
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .frame(width: 120, height: 140)
            .onTapGesture {
                showProgressDialog = true
                impactHaptic()
            }

            Text("\(Int(progress * 100))% 完了")
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))
                .padding(.top, 12)
        }
    }

    private var adBannerSection: some View {
        VStack {
            Divider()
            HStack {
                Text("📢 広告スペース")
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.5)))
    }

    private var backgroundGradient: some View {
        let hour = Calendar.current.component(.hour, from: Date())
        let colors: [Color] = hour < 12
            ? [Color(#colorLiteral(red: 0.98, green: 0.96, blue: 0.92, alpha: 1)), Color(#colorLiteral(red: 0.94, green: 0.91, blue: 0.86, alpha: 1))] // Morning
            : hour < 18
            ? [Color(#colorLiteral(red: 0.96, green: 0.93, blue: 0.88, alpha: 1)), Color(#colorLiteral(red: 0.91, green: 0.87, blue: 0.80, alpha: 1))] // Afternoon
            : [Color(#colorLiteral(red: 0.88, green: 0.82, blue: 0.75, alpha: 1)), Color(#colorLiteral(red: 0.80, green: 0.72, blue: 0.62, alpha: 1))] // Evening

        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Actions

    private func handleTaskCompletion(success: Bool) {
        if success {
            if let task = currentTask {
                task.status = .completed
                task.lastCompletedDate = Date()
                task.currentStreak += 1

                // Increase progress
                progress = min(1.0, progress + 0.25)

                // Create meeting log
                let log = MeetingLog(date: Date(), successStatus: true)
                modelContext.insert(log)

                do {
                    try modelContext.save()
                } catch {
                    print("Failed to save task completion: \(error)")
                }
            }
        } else {
            progress = max(0.0, progress - 0.1)
        }
    }

    private func setupInitialState() {
        // Initialize progress based on current time
        let hour = Calendar.current.component(.hour, from: Date())
        progress = Double(hour) / 24.0
    }

    private func impactHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - Coffee Cup Shape

struct CoffeeCupView: Shape {
    var fillPercentage: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let cupWidth = rect.width
        let cupHeight = rect.height
        let topPadding: CGFloat = 10
        let bottomPadding: CGFloat = 15

        // Cup outline (rounded rectangle at bottom)
        let cupPath = UIBezierPath(roundedRect: CGRect(
            x: rect.minX,
            y: rect.minY + topPadding,
            width: cupWidth,
            height: cupHeight - topPadding - bottomPadding
        ), cornerRadius: 8)

        path = Path(cupPath.cgPath)

        return path
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Task.self, inMemory: true)
}
