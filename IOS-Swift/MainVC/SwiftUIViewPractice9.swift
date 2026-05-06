//
//  SwiftUIViewPractice9.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI

struct SwiftUIViewPractice9: View {
    @EnvironmentObject var userState: UserLoginState
    @State private var inputUserName = ""

    var body: some View {
        VStack(spacing: 20) {
            // 状态展示区
            GroupBox(label: Label("当前状态", systemImage: "person.circle")) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("登录状态：")
                        Text(userState.isLoggedIn ? "✅ 已登录" : "❌ 未登录")
                            .foregroundColor(userState.isLoggedIn ? .green : .red)
                    }
                    if userState.isLoggedIn {
                        HStack {
                            Text("用户名：")
                            Text(userState.userName)
                                .font(.headline)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)
            }

            // 未登录时显示登录界面
            if !userState.isLoggedIn {
                VStack(spacing: 12) {
                    TextField("请输入用户名", text: $inputUserName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    Button(action: login) {
                        Label("登录", systemImage: "arrow.right.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(inputUserName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.top, 8)
            } else {
                // 已登录时显示登出按钮
                Button(action: logout) {
                    Label("登出", systemImage: "escape")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }

            Spacer()

            // 提示信息：证明数据是全局共享的
            Text("💡 提示：此用户状态通过 @EnvironmentObject 全局共享")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .navigationTitle("登录状态演示")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("全局状态")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
    }

    // MARK: - Actions
    private func login() {
        let trimmed = inputUserName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        userState.isLoggedIn = true
        userState.userName = trimmed
        inputUserName = "" // 清空输入框
    }

    private func logout() {
        userState.isLoggedIn = false
        userState.userName = ""
    }
}

#Preview {
    SwiftUIViewPractice9()
}
