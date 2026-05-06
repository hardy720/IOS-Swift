//
//  SwiftUIViewPractice2.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI

struct SwiftUIViewPractice2: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            Text("张三")
                .font(.title)
                .fontWeight(.bold)
            Text("iOS 工程师")
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text("📱 写代码")
                Text("🎸 弹吉他")
                Text("📚 读书")
            }
            .font(.footnote)
            .padding(.top, 8)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray6)))
        .shadow(radius: 5)
        
        ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 200)
                        .foregroundColor(.blue)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(20)

                    // 中层：半透明遮罩（从底部向上渐变）
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 300, height: 200)
                        .cornerRadius(20)

                    // 顶层：文字（右下角）
                    Text("© 2025 SwiftUI 练习")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(12)
                }
    }
}

#Preview {
    SwiftUIViewPractice2()
}
