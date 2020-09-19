//
//  ThemePicker.swift
//  Memorize
//
//  Created by Artem Shashulovskiy on 24.08.2020.
//  Copyright © 2020 Artem Shashulovskiy. All rights reserved.
//

import SwiftUI

typealias Theme = EmojiMemoryGame.Theme

class ThemePicker: ObservableObject {
    @Published private(set) var themes: [Theme] = [Theme(name: "Halloween", emojis: ["👻", "🎃", "🗝", "🕷", "🕸"], colorTheme: Color.orange),
                           Theme(name: "Food", emojis: ["🧀", "🍰", "🍎", "🍒"], colorTheme: Color.blue),
                           Theme(name: "Animals", emojis: ["🐶", "🐱", "🐭"], colorTheme: Color.green)]
    
    func addTheme(theme: Theme) {
        themes.append(theme)
    }
    
    func removeTheme(theme: Theme) {
        if let index = themes.firstIndex(matching: theme) {
            themes.remove(at: index)
        }
    }
}
