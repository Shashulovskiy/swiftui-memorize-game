//
//  ThemePickerView.swift
//  Memorize
//
//  Created by Artem Shashulovskiy on 24.08.2020.
//  Copyright © 2020 Artem Shashulovskiy. All rights reserved.
//

import SwiftUI

struct ThemePickerView: View {
    @EnvironmentObject var themePicker: ThemePicker
    
    @State var newThemeSheetShown: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(themePicker.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(gameModel: EmojiMemoryGame(for: theme)), label: {
                        ThemePreview(theme: theme)
                    })
                    
                }
                .onDelete(perform: { indexSet in
                    indexSet.map({self.themePicker.themes[$0]}).forEach({self.themePicker.removeTheme(theme: $0)})
                })
            }
            .navigationBarTitle("Themes")
            .navigationBarItems(
                leading: Button(action: { self.newThemeSheetShown = true }, label: { Image(systemName: "plus").imageScale(.large) }),
                trailing: EditButton())
                .sheet(isPresented: $newThemeSheetShown, content: { ThemePickerForm(isShown: self.$newThemeSheetShown).environmentObject(self.themePicker) })
        }
    }
}

struct ThemePreview: View {
    var theme: Theme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(theme.name).foregroundColor(theme.colorTheme).font(.title)
            Text("\(theme.cardCount) pairs from \(theme.emojis.joined())")
        }
    }
}

struct ThemePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePickerView()
    }
}

