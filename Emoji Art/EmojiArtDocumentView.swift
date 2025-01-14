//
//  EmojiArtDocumentView.swift
//  Emoji Art
//
//  Created by H470-088 on 2/1/25.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    @ObservedObject var document: EmojiArtDocument
    
    private let emojis = "😊😢🚗🍕🏖️🐶🌳🏆🎨📚🕹️💼💪🎶📱⚽🎂🌌💡🚀🎮🎤🏰🌈💧🔥🌟🍎🍩🛠️🧭📷🎯🧩🚴🎓🌻🐾🎬🕊️🛫🎉"
    
    private let paletteEmojiSize: CGFloat = 40
    
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChoser()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
    
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldata,location in
                return drop(sturldata, at: location, in: geometry)
            }
            .onTapGesture {
                deselectAllEmojis()
            }
        }
    }
    
    private func deselectAllEmojis() {
        selectedEmojisId = .init()
    }
    
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    
    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, _ in
                gestureZoom = inMotionPinchScale
            }
            .onEnded { endingPinchScale in
                zoom *= endingPinchScale
            }
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePan) { value, gesturePan, _ in
                gesturePan = value.translation
            }
            .onEnded { value in
                pan += value.translation
            }
    }
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    
    @State private var selectedEmojisId = Set<Emoji.ID>()
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            // Emoji view
            Text(emoji.string)
                .font(emoji.font)
                // show border if selected
                .border(.red, width: isSelected(emoji.id) ? 1 : 0)
                .scaleEffect(isSelected(emoji.id) ? zoom * gestureZoom : 1)
                .position(emoji.position.in(geometry))
                .onTapGesture {
                    handleEmojiTapping(emoji.id)
                }
        }
    }
    
    private func isSelected(_ id: Emoji.ID) -> Bool {
        selectedEmojisId.contains(id)
    }
    
    private func handleEmojiTapping(_ id: Emoji.ID) {
        if selectedEmojisId.contains(id) {
            selectedEmojisId.remove(id)
        } else {
            selectedEmojisId.insert(id)
        }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(emoji, at: emojiPosition(at: location, in: geometry), size: paletteEmojiSize / zoom)
                return true
            default:
                break
            }
        }
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(x: Int((location.x - center.x - pan.width)/zoom), y: Int(-(location.y - center.y - pan.height) / zoom))
    }
}



#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
        .environmentObject(PaletteStore(named: "Preview"))
}
