//
//  SwiftUIViewPractice6.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI
// @StateObject 负责创建并持有 ObservableObject，且当 @Published 属性改变时，视图自动刷新。
// 1. 模型
class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    
    struct Habit: Identifiable {
        let id = UUID()
        var name: String
        var isCompleted = false
    }
    
    func addHabit(_ name: String) {
        habits.append(Habit(name: name))
        saveToUserDefaults()
    }
    
    func toggleCompletion(for habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isCompleted.toggle()
            saveToUserDefaults()
        }
    }
    
    private func saveToUserDefaults() {
        // 简化：实际应使用 Codable 编码
        print("保存成功")
    }
}

struct SwiftUIViewPractice6: View {
    @StateObject private var store = HabitStore()
    @State private var newHabitName = ""
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.habits) { habit in
                    HStack {
                        Text(habit.name)
                        Spacer()
                        Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(habit.isCompleted ? .green : .gray)
                            .onTapGesture {
                                store.toggleCompletion(for: habit)
                            }
                    }
                }
            }
            .navigationTitle("习惯追踪")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        TextField("新习惯", text: $newHabitName)
                            .textFieldStyle(.roundedBorder)
                        Button("添加") {
                            guard !newHabitName.isEmpty else { return }
                            store.addHabit(newHabitName)
                            newHabitName = ""
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    SwiftUIViewPractice6()
}
