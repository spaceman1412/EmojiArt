//
//  EmojiArt.swift
//  Emoji Art
//
//  Created by H470-088 on 2/1/25.
//

import Foundation

struct EmojiArt {
    var background: URL?
    private(set) var emojis = [Emoji]()
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(string: emoji, position: position, size: size, id: uniqueEmojiId))
    }
    
    mutating func updateSizeEmoji(id: Emoji.ID, size: Int) {
        if let index = emojis.firstIndex (where: { $0.id == id }) {
            emojis[index].size = size
        }
    }
    
    mutating func updatingPositionEmoji(id: Emoji.ID, position: Emoji.Position) {
        if let index = emojis.firstIndex (where: { $0.id == id }) {
            emojis[index].position = position
        }
    }
    
    mutating func removeEmoji(id: Emoji.ID) {
        if let index = emojis.firstIndex (where: { $0.id == id }) {
            emojis.remove(at: index)
        }
    }
    
    struct Emoji: Identifiable {
        let string: String
        var position: Position
        var size: Int
        var id: Int
        
        struct Position {
            var x: Int
            var y: Int
            
            static let zero = Self(x: 0, y: 0)
        }
    }
}
