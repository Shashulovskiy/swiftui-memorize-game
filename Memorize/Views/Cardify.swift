//
//  Cardify.swift
//  Memorize
//
//  Created by Artem Shashulovskiy on 04.08.2020.
//  Copyright © 2020 Artem Shashulovskiy. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    var isFaceUp: Bool {
        rotation < 90
    }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
         
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .fill()
                    .foregroundColor(Color.white)
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .stroke(lineWidth: self.edgeLineWidth)
                content
            } else {
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .fill()
            }
    
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
        
    }
    
    // MARK: - Drawing constants
    private let cornerRadius : CGFloat = 10
    private let edgeLineWidth: CGFloat = 5
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
