//
//  ThemePickerForm.swift
//  Memorize
//
//  Created by Artem Shashulovskiy on 25.08.2020.
//  Copyright © 2020 Artem Shashulovskiy. All rights reserved.
//

import SwiftUI

struct ThemePickerForm: View {
    @EnvironmentObject var themePicker: ThemePicker
    @Binding var isShown: Bool
    
    @State var themeName: String = "Untitled"
    @State var emojiBuffer: String = ""
    @State var emojis: Set<Character> = ["🍎", "🍰", "🧀", "🥕", "🍕"]
    @State var cardCount: Int = 5
    @State var pickedColor: Color = Color.green
    
    @State var colors = [Color.green, Color.blue, Color.red, Color.purple, Color.yellow, Color.orange]
    
    @Environment(\.colorScheme) var theme
    
    
    var body: some View {
        VStack {
            ZStack {
                Text("Add Theme")
                HStack {
                    Button("Cancel") {
                        self.isShown = false
                    }
                    Spacer()
                    Button("Add") {
                        self.themePicker.addTheme(theme:
                            Theme(name: self.themeName,
                                  emojis: Array(self.emojis).map({String($0)}),
                                  colorTheme: self.pickedColor,
                                  cardCount: self.cardCount))
                        self.isShown = false
                    }
                }
            }.padding()
            Form {
                Section(header: Text("Name")) {
                    TextField("Theme name", text: $themeName)
                }
                Section(header: Text("Add Emoji")) {
                    HStack {
                        TextField("Emojis", text: $emojiBuffer)
                        Button("Add") {
                            for emoji in self.emojiBuffer {
                                self.emojis.insert(emoji)
                            }
                            self.emojiBuffer = ""
                        }
                    }
                    
                }
                Section(header: HStack {
                    Text("Emojis")
                    Spacer()
                    Text("tap to exclude").font(.caption)
                }) {
                    Grid(Array(emojis.map( { String($0) })), id: \.self) { emoji in
                        Group {
                            Text(emoji).font(.largeTitle)
                        }.onTapGesture {
                            for removedEmoji in emoji {
                                self.emojis.remove(removedEmoji)
                            }
                        }
                    }.frame(height: self.height)
                }
                Section(header: Text("Card Count")) {
                    Stepper("\(self.cardCount) pairs",
                        onIncrement: { self.cardCount += 1 },
                        onDecrement: { self.cardCount = max(2, self.cardCount - 1)
                    })
                    
                }
                Section(header: Text("Color Theme")) {
                    Grid(colors, id: \.self) { color in
                        Group {
                            if color == self.pickedColor {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: 3)
                                    .foregroundColor(self.theme == .dark ? .white : .black)
                            }
                            RoundedRectangle(cornerRadius: 5).foregroundColor(color)
                        }
                        .aspectRatio(0.9, contentMode: .fit).padding(3)
                        .onTapGesture {
                            self.pickedColor = color
                        }
                        
                    }
                    .frame(height: self.height)
                }
            }
        }
    }
    
    var height: CGFloat {
        CGFloat((emojis.count - 1) / 6) * 70 + 70
    }
}
