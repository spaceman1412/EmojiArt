//
//  Emoji_ArtApp.swift
//  Emoji Art
//
//  Created by H470-088 on 2/1/25.
//

import SwiftUI

@main
struct Emoji_ArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")
    @StateObject var store2 = PaletteStore(named: "Alternative")
    @StateObject var store3 = PaletteStore(named: "Special")

    
    var body: some Scene {
        WindowGroup {
//            PaletteManager(stores: [paletteStore,store2,store3])
                        EmojiArtDocumentView(document: defaultDocument)
                .environmentObject(paletteStore)
        }
    }
}
