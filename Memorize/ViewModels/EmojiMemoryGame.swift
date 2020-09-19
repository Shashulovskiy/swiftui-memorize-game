//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Artem Shashulovskiy on 27.07.2020.
//  Copyright © 2020 Artem Shashulovskiy. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame : ObservableObject {
    var theme : Theme
    @Published private var game : MemoryGame<String>?
    
    init(for theme: Theme) {
        self.theme = theme
        game = MemoryGame<String>(numberOfCardPairs : theme.cardCount, cardContentFactory: cardContentFactory(index:))
    }
    
    private func restartGame() {
        game = MemoryGame<String>(numberOfCardPairs : theme.cardCount, cardContentFactory: cardContentFactory(index:))
    }
    
    
        
    func cardContentFactory(index: Int) -> String {
        return self.theme.emojis[index % theme.emojis.count]
    }
    
    // MARK: - Access to the Game Model
    var cards: Array<MemoryGame<String>.Card> {
        return game!.cards
    }
    
    
    // MARK: - Intents
    func choose(_ card : MemoryGame<String>.Card) {
        objectWillChange.send()
        game!.choose(card)
    }
    
    func newGame() {
        print("New game requested")
        restartGame()
    }
    
    func getScore() -> Int {
        return game!.score
    }
    
    struct Theme: Identifiable {
        let id = UUID()
        let name: String
        let emojis: [String]
        let cardCount: Int
        let colorTheme: Color
        
        init(name: String, emojis: [String], colorTheme: Color, cardCount: Int? = nil) {
            self.name = name
            self.emojis = emojis
            self.colorTheme = colorTheme
            
            self.cardCount = cardCount ?? emojis.count
        }
    }
    
    
}

