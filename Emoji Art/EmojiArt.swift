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
        for index in emojis.indices {
            if emojis[index].id == id {
                emojis[index].size = size
            }
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
