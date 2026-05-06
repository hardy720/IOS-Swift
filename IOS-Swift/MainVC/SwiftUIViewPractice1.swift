//
//  SwiftUIViewPractice1.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI

struct SwiftUIViewPractice1: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).font(.largeTitle)
            .foregroundColor(.blue)
            .padding()
            .background(Color.yellow)
            .cornerRadius(10)
    }
}

#Preview {
    SwiftUIViewPractice1()
}
