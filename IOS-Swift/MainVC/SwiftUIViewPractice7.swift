//
//  SwiftUIViewPractice7.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let name: String
}

struct SwiftUIViewPractice7: View {
    @State private var showAlert = false
    @State private var selectedItem: Item?
    @State private var showSheet = false

    var body: some View {
        VStack(spacing: 12) {
            Button("编辑个人资料") {
                showSheet = true
            }.padding(.top, 20)

            .sheet(isPresented: $showSheet) {
                SheetView()
            }
            Button("删除文件") {
                showAlert = true
            }
            .padding(.top, 20)
            .alert("确认删除", isPresented: $showAlert) {
                Button("取消", role: .cancel) { }
                Button("删除", role: .destructive) {
                    // 执行删除操作
                    print("文件已删除")
                }
            } message: {
                Text("此操作将永久删除该文件，无法恢复。")
            }
            List {
                ForEach([Item(name: "文档A"), Item(name: "图片B")], id: \.id) { item in
                    Text(item.name)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
            .alert(item: $selectedItem) { item in
                Alert(
                    title: Text("删除 \(item.name)"),
                    message: Text("确定要删除吗？"),
                    primaryButton: .destructive(Text("删除")) {
                        FLPrint("删除 \(item.name)")
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss  // 用于手动关闭 sheet

    var body: some View {
        NavigationStack {
            Form {
                TextField("昵称", text: .constant("张三"))
                TextField("签名", text: .constant("热爱SwiftUI"))
            }
            .navigationTitle("编辑资料")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        dismiss()  // 关闭 sheet
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SwiftUIViewPractice7()
}
