//
//  MemoryGame.swift
//  Memorize
//
//  Created by Artem Shashulovskiy on 27.07.2020.
//  Copyright © 2020 Artem Shashulovskiy. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent>: Codable where CardContent: Equatable & Codable {
    private(set) var cards: Array<Card>
    private var chosenCard: Int? {
        get {
            cards.indices.filter({cards[$0].isFaceUp}).only
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    var score = 0
    
    init(numberOfCardPairs : Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfCardPairs {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(cardContent: content, index: pairIndex * 2))
            cards.append(Card(cardContent: content, index: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        print("card chosen: \(card)")
        if let chosenCardIndex = cards.firstIndex(matching: card), !cards[chosenCardIndex].isFaceUp, !cards[chosenCardIndex].isMatched {
            if let potentialMatch = chosenCard {
                if (cards[potentialMatch].content == cards[chosenCardIndex].content) {
                    score += 2
                    cards[potentialMatch].isMatched = true
                    cards[chosenCardIndex].isMatched = true
                } else {
                    if (cards[potentialMatch].wasSeen || cards[chosenCardIndex].wasSeen) {
                        score -= 1
                    }
                }
                self.cards[chosenCardIndex].isFaceUp = true
                self.cards[chosenCardIndex].wasSeen = true
            } else {
                chosenCard = chosenCardIndex
                self.cards[chosenCardIndex].isFaceUp = true
            }
        }
        print("Current score is \(score)")
        
    }
    
    struct Card : Identifiable, Codable {
        var isFaceUp : Bool {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched : Bool {
            didSet {
                stopUsingBonusTime()
            }
        }
        var wasSeen : Bool
        var content : CardContent
        var id : Int
        
        init(cardContent : CardContent, index : Int) {
            isFaceUp = false
            isMatched = false
            wasSeen = false
            content = cardContent
            id = index
        }
        
        var bonusTimeLimit: TimeInterval = 6
        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
