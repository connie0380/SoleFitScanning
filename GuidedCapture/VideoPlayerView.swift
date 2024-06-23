import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @State private var player = AVPlayer()
    var url: String
    
    var body: some View {
        VideoPlayer(player: player)
            .hidden()
            .onAppear {
                let url = URL(string: url)!
                player = AVPlayer(url: url)
                player.play()
                
            }
            .onDisappear {
                player.pause()
            }
    }
}

//#Preview {
//    VideoPlayerView()
//}
