//
//  TrailerVideoView.swift
//  Anime Landia
//
//  Created by Victor Saint Hilaire on 9/30/23.
//

import SwiftUI
import YouTubePlayerKit

struct TrailerVideoView: View {
    var youtubeUrl: String
    var body: some View {
        YouTubePlayerView(
                   YouTubePlayer(stringLiteral: youtubeUrl)
        ).ignoresSafeArea()
    }
}

#Preview {
    TrailerVideoView(youtubeUrl: "https://youtube.com/watch?v=psL_5RIBqnY")
}
