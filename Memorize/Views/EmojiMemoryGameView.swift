//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Artem Shashulovskiy on 27.07.2020.
//  Copyright © 2020 Artem Shashulovskiy. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var gameModel : EmojiMemoryGame
    var body: some View {
        VStack{
            Grid(self.gameModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                self.gameModel.choose(card)
                            }
                            
                    
                }
                .padding(5)
                
            }
            Text("Score: \(self.gameModel.getScore())")
            Spacer()
        }
        .padding()
        .foregroundColor(self.gameModel.theme.colorTheme)
        .navigationBarTitle(Text(gameModel.theme.name))
        .navigationBarItems(trailing: Button("New Game") {
            withAnimation(.easeInOut) {
                self.gameModel.newGame()
            }
        })
        
    }
}

struct CardView : View {
    var card : MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    var body : some View {
        // TODO: Clean up
        GeometryReader { geometry in
            if (!self.card.isMatched || self.card.isFaceUp) {
                ZStack {
                    if self.card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0 - 90),
                            endAngle: Angle.degrees(-self.animatedBonusRemaining * 360 - 90),
                            clockwise: true)
                            .padding(7)
                            .opacity(0.4)
                            .onAppear() {
                                self.startBonusTimeAnimation()
                                
                        }
                        
                    } else {
                        Pie(startAngle: Angle.degrees(0 - 90),
                            endAngle: Angle.degrees(-self.card.bonusRemaining * 360 - 90),
                        clockwise: true)
                        .padding(7)
                        .opacity(0.4)
                    }
                    
                    Text(self.card.content)
                        .font(Font.system(size: min(geometry.size.width, geometry.size.height) * self.emojiSizeScale))
                }.cardify(isFaceUp: self.card.isFaceUp)
                    .transition(.scale)
            }
            
        }
    }
    
    // MARK: - Drawing Constants
    private let emojiSizeScale : CGFloat = 0.6
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame(for: Theme(name: "Halloween", emojis: ["👻", "🎃", "🗝", "🕷", "🕸"], colorTheme: Color.orange))
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(gameModel: game)
    }
}

