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
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
        }
    }
}
