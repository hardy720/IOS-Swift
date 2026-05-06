//
//  SwiftUIViewPractice8.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI

struct SwiftUIViewPractice8: View {
    @State private var isScaled = false
    @State private var offsetX: CGFloat = 0
    @State private var color: Color = .red
    @State private var isExpanded = false
    @State private var textColor: Color = .primary
    var body: some View {
        VStack(spacing: 30) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(width: isScaled ? 200 : 100,
                       height: isScaled ? 200 : 100)
                .opacity(isScaled ? 0.5 : 1.0)
            // 隐式动画：当 isScaled 变化时，自动动画
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: isScaled)
            
            Button("切换") {
                isScaled.toggle()
            }
        }
        .padding()
        
        VStack {
            Circle()
                .fill(color)
                .frame(width: 80, height: 80)
                .offset(x: offsetX)
            
            Button("动画移动并变色") {
                // 显式动画：这两个状态的变化都会以动画执行
                withAnimation(.easeInOut(duration: 0.8)) {
                    offsetX = offsetX == 0 ? 120 : 0
                    color = color == .red ? .green : .red
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        VStack {
             Text("动态文字")
                 .foregroundColor(textColor)
                 // 隐式动画：字体大小随 isExpanded 变化
                 .font(.title)
                 .scaleEffect(isExpanded ? 1.5 : 1.0)
                 .animation(.easeInOut, value: isExpanded)

             Button("展开/收起") {
                 isExpanded.toggle()
             }

             Button("改变文字颜色") {
                 // 显式动画：颜色变化单独使用弹簧动画
                 withAnimation(.spring()) {
                     textColor = textColor == .primary ? .purple : .primary
                 }
             }
         }
    }
}

#Preview {
    SwiftUIViewPractice8()
}
