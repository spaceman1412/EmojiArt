//
//  EmojiArtDocument.swift
//  Emoji Art
//
//  Created by H470-088 on 2/1/25.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    @Published private var emojiArt = EmojiArt()
    
    init() {
        emojiArt.addEmoji("👌", at: .init(x: 100, y: 100), size: 40)
        emojiArt.addEmoji("🦶", at: .init(x: -150, y: 100), size: 40)
    }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var background: URL? {
        emojiArt.background
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
    
    func updateEmoji(id: Emoji.ID, size: Int) {
        emojiArt.updateSizeEmoji(id: id, size: size)
    }
    
    func updatingPositionEmoji(id: Emoji.ID, position: Emoji.Position) {
        emojiArt.updatingPositionEmoji(id: id, position: position)
    }
}

extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}


