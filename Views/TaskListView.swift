import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [Task]
    @State private var showNewTaskSheet = false

    var body: some View {
        NavigationStack {
            List {
                if tasks.isEmpty {
                    VStack(alignment: .center, spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)

                        Text("タスクなし")
                            .font(.system(size: 18, weight: .semibold, design: .default))

                        Text("「+」をタップして新しいタスクを追加してください")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(40)
                } else {
                    ForEach(tasks, id: \.self) { task in
                        TaskRowView(task: task)
                    }
                    .onDelete(perform: deleteTask)
                }
            }
            .navigationTitle("すべてのタスク")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showNewTaskSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color(#colorLiteral(red: 0.243, green: 0.157, blue: 0.137, alpha: 1)))
                    }
                }
            }
            .sheet(isPresented: $showNewTaskSheet) {
                NewTaskSheetView(isPresented: $showNewTaskSheet)
            }
        }
    }

    private func deleteTask(_ offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            modelContext.delete(task)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}

// MARK: - Task Row Component

struct TaskRowView: View {
    let task: Task

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(.black)

                    Text(task.goal)
                        .font(.system(size: 13, weight: .regular, design: .default))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)

                        Text("\(task.currentStreak)")
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundColor(.orange)
                    }

                    Text(task.status.rawValue)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(.secondary)
                }
            }

            Text("「\(task.maxim)」")
                .font(.system(size: 12, weight: .light, design: .default))
                .foregroundColor(.secondary)
                .italic()
        }
        .padding(12)
        .background(Color(#colorLiteral(red: 1, green: 0.976, blue: 0.773, alpha: 0.2)))
        .cornerRadius(8)
    }
}

// MARK: - New Task Sheet

struct NewTaskSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool

    @State private var title = ""
    @State private var goal = ""
    @State private var maxim = ""
    @State private var frequency: TaskFrequency = .daily

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !goal.trimmingCharacters(in: .whitespaces).isEmpty &&
        !maxim.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    TextField("タスクのタイトル", text: $title)
                    TextField("目的", text: $goal)
                    TextField("格言・モットー", text: $maxim)
                }

                Section("頻度") {
                    Picker("頻度", selection: $frequency) {
                        ForEach([TaskFrequency.daily, TaskFrequency.weekly, TaskFrequency.monthly], id: \.self) { freq in
                            Text(freq.rawValue).tag(freq)
                        }
                    }
                }
            }
            .navigationTitle("新しいタスク")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("キャンセル") { isPresented = false }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("追加") {
                        let newTask = Task(
                            title: title.trimmingCharacters(in: .whitespaces),
                            goal: goal.trimmingCharacters(in: .whitespaces),
                            maxim: maxim.trimmingCharacters(in: .whitespaces),
                            frequency: frequency
                        )
                        modelContext.insert(newTask)

                        do {
                            try modelContext.save()
                            isPresented = false
                        } catch {
                            print("Failed to save new task: \(error)")
                        }
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

#Preview {
    TaskListView()
        .modelContainer(for: Task.self, inMemory: true)
}
