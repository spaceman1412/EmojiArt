//
//  PaletteChoser.swift
//  Emoji Art
//
//  Created by H470-088 on 13/1/25.
//

import SwiftUI

struct PaletteChoser: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }.clipped()
    }
    
    var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }.contextMenu {
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "Math", emojis: "☻☾☁︎⛅︎")
            }
            AnimatedActionButton("Delete", systemImage: "minus", role: .destructive) {
                store.palettes.remove(at: store.cursorIndex)
            }
        }
    }
    
    func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(AsymmetricTransition(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}


#Preview {
    PaletteChoser()
        .environmentObject(PaletteStore(named: "Preview"))
}
