import SwiftUI
import SwiftData

struct ProgressDialogView: View {
    let task: Task?
    @Binding var isPresented: Bool
    let onComplete: (Bool) -> Void

    @Environment(\.modelContext) private var modelContext
    @Query private var coffeeTips: [CoffeeTip]

    @State private var selectedStatus: CompletionStatus = .completed
    @State private var failureReason = ""
    @State private var unlockedTip: CoffeeTip?

    enum CompletionStatus: String {
        case completed = "達成した"
        case partial = "一部達成"
        case failed = "達成できなかった"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("今日の進捗")
                        .font(.system(size: 20, weight: .bold, design: .default))
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }

                if let task = task {
                    Text(task.title)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.secondary)
                }
            }
            .padding(20)
            .background(Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 1)))

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Status selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("状態を選択")
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundColor(.secondary)

                        ForEach([
                            CompletionStatus.completed,
                            CompletionStatus.partial,
                            CompletionStatus.failed
                        ], id: \.self) { status in
                            HStack {
                                Image(systemName: selectionIcon(for: status))
                                    .foregroundColor(
                                        selectedStatus == status
                                            ? Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1))
                                            : .gray
                                    )

                                Text(status.rawValue)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .foregroundColor(
                                        selectedStatus == status
                                            ? Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1))
                                            : .black
                                    )

                                Spacer()

                                if selectedStatus == status {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))
                                }
                            }
                            .padding(12)
                            .background(
                                selectedStatus == status
                                    ? Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.5))
                                    : Color.white
                            )
                            .cornerRadius(8)
                            .onTapGesture {
                                selectedStatus = status
                            }
                        }
                    }

                    // Failure reason input
                    if selectedStatus == .failed {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("理由を教えてください")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                                .foregroundColor(.secondary)

                            TextEditor(text: $failureReason)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .font(.system(size: 14, design: .default))
                        }
                    }

                    // Coffee tip preview
                    if selectedStatus == .completed && unlockedTip != nil {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("豆知識を獲得しました", systemImage: "star.fill")
                                .font(.system(size: 14, weight: .semibold, design: .default))
                                .foregroundColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))

                            if let tip = unlockedTip {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(tip.title)
                                        .font(.system(size: 13, weight: .semibold, design: .default))

                                    Text(tip.content)
                                        .font(.system(size: 12, weight: .regular, design: .default))
                                        .lineLimit(4)
                                        .foregroundColor(.secondary)
                                }
                                .padding(12)
                                .background(Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.3)))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(20)
            }

            // Action buttons
            HStack(spacing: 12) {
                Button(action: { isPresented = false }) {
                    Text("キャンセル")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.5)))
                        .cornerRadius(8)
                }

                Button(action: {
                    // Unlock a random coffee tip if task is completed
                    if selectedStatus == .completed {
                        unlockRandomCoffeeTip()
                    }
                    onComplete(selectedStatus == .completed || selectedStatus == .partial)
                    isPresented = false
                    impactHaptic()
                }) {
                    Text("保存")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))
                        .cornerRadius(8)
                }
            }
            .padding(20)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
    }

    private func selectionIcon(for status: CompletionStatus) -> String {
        switch status {
        case .completed:
            return "checkmark.circle"
        case .partial:
            return "minus.circle"
        case .failed:
            return "xmark.circle"
        }
    }

    private func impactHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    private func unlockRandomCoffeeTip() {
        // Find all locked tips
        let lockedTips = coffeeTips.filter { !$0.isUnlocked }

        // If no locked tips, all are already unlocked
        guard !lockedTips.isEmpty else { return }

        // Randomly select a locked tip
        if let randomTip = lockedTips.randomElement() {
            randomTip.isUnlocked = true
            randomTip.unlockedDate = Date()
            unlockedTip = randomTip

            do {
                try modelContext.save()
            } catch {
                print("Failed to unlock coffee tip: \(error)")
            }
        }
    }
}

#Preview {
    ProgressDialogView(
        task: Task(
            title: "朝の瞑想",
            goal: "心を整えて1日をスタート",
            maxim: "今この瞬間に集中する"
        ),
        isPresented: .constant(true),
        onComplete: { _ in }
    )
    .modelContainer(for: CoffeeTip.self, inMemory: true)
}
