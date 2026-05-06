//
//  SwiftUIViewPractice3.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI

struct SwiftUIViewPractice3: View {
    @State private var count = 0
    var body: some View {
        VStack(spacing: 20) {
            Text("当前计数：\(count)")
                .font(.largeTitle)
            
            HStack(spacing: 40) {
                Button("-") { count -= 1 }
                    .font(.title)
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .clipShape(Circle())
                
                Button("+") { count += 1 }
                    .font(.title)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .padding()
    }
}

#Preview {
    SwiftUIViewPractice3()
}
