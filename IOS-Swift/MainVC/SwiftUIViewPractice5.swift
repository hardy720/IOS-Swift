//
//  SwiftUIViewPractice5.swift
//  IOS-Swift
//
//  Created by Hardy on 2026/5/6.
//

import SwiftUI

struct Animal: Identifiable {
    let id = UUID()
    let name: String
    let description: String
}

let animals = [
    Animal(name: "🐼 熊猫", description: "爱吃竹子，中国国宝。"),
    Animal(name: "🦊 狐狸", description: "聪明又狡猾。"),
    Animal(name: "🐧 企鹅", description: "不会飞但游泳很棒。")
]

struct SwiftUIViewPractice5: View {
    var body: some View {
        NavigationStack {
            List(animals) { animal in
                NavigationLink(animal.name) {
                    AnimalDetailView(animal: animal)
                }
            }
            .navigationTitle("动物百科")
        }
    }
}

struct AnimalDetailView: View {
    let animal: Animal
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(animal.name)
                .font(.largeTitle)
            Text(animal.description)
                .font(.body)
            Spacer()
        }
        .padding()
        .navigationTitle(animal.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SwiftUIViewPractice5()
}
