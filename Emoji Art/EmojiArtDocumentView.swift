//
//  EmojiArtDocumentView.swift
//  Emoji Art
//
//  Created by H470-088 on 2/1/25.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    @Environment(\.undoManager) var undoManager
    @StateObject var paletteStore = PaletteStore(named: "Share")
    typealias Emoji = EmojiArt.Emoji
    @ObservedObject var document: EmojiArtDocument
    @State var showBackgroundFailure: Bool = false
    
    private let emojis = "😊😢🚗🍕🏖️🐶🌳🏆🎨📚🕹️💼💪🎶📱⚽🎂🌌💡🚀🎮🎤🏰🌈💧🔥🌟🍎🍩🛠️🧭📷🎯🧩🚴🎓🌻🐾🎬🕊️🛫🎉"
    
    @ScaledMetric var paletteEmojiSize: CGFloat = 40
    
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChoser()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
        .toolbar {
            UndoButton()
        }
        .environmentObject(paletteStore)
    }
    
    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                if document.background.isFetching {
                    ProgressView()
                        .scaleEffect(2)
                        .tint(.blue)
                        .position(Emoji.Position.zero.in(geometry))
                }
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .onTapGesture(count: 2) {
                zoomToFit(document.bbox, in: geometry)
            }
            .dropDestination(for: Sturldata.self) { sturldata,location in
                return drop(sturldata, at: location, in: geometry)
            }
            .onChange(of: document.background.failureReason) {
                reason in
                showBackgroundFailure = (reason != nil)
            }
            .onChange(of: document.background.uiImage) { uiImage in
                zoomToFit(uiImage?.size, in:geometry)
            }
            .alert("Set Background Error", isPresented: $showBackgroundFailure,
                   presenting: document.background.failureReason,
                   actions: { reason in
                Button("OK", role: .cancel) {
                    
                }
            },
                   message: {reason in
                Text(reason)
            })
        }
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
            
            private func zoomToFit(_ size: CGSize?, in geometry: GeometryProxy) {
                if let size {
                    zoomToFit(CGRect(center: .zero, size: size), in: geometry)
                }
            }
            
            private func zoomToFit(_ rect: CGRect, in geometry: GeometryProxy) {
                withAnimation {
                    if rect.size.width > 0, rect.size.height > 0,
                       geometry.size.width > 0, geometry.size.height > 0 {
                        let hZoom = geometry.size.width / rect.size.width
                        let vZoom = geometry.size.height / rect.size.height
                        zoom = min(hZoom, vZoom)
                        pan = CGOffset(
                            width: -rect.midX * zoom,
                            height: -rect.midY * zoom
                        )
                    }
                }
            }
            
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        if let uiImage = document.background.uiImage {
            Image(uiImage: uiImage)
                .position(Emoji.Position.zero.in(geometry))
        }
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
        }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url, undoWith: undoManager)
                return true
            case .string(let emoji):
                document.addEmoji(emoji, at: emojiPosition(at: location, in: geometry), size: paletteEmojiSize / zoom, undoWith: undoManager)
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
