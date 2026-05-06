//
//  SwiftUIViewPractice4.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI

struct SwiftUIViewPractice4: View {
    // $newTodo 是双向绑定，文本框变化会自动更新 newTodo
    @State private var newTodo = ""
    @State private var todos = [String]()
    var body: some View {
        VStack {
            HStack {
                TextField("写点什么...", text: $newTodo)
                    .textFieldStyle(.roundedBorder)
                Button("添加") {
                    if !newTodo.isEmpty {
                        todos.append(newTodo)
                        newTodo = ""
                    }
                }
            }
            .padding()
            
            List(todos, id: \.self) { todo in
                Text(todo)
            }
        }
    }
}

#Preview {
    SwiftUIViewPractice4()
}
