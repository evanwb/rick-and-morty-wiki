import SwiftUI

struct EpisodeView: View {
    let e: Episode
    var body: some View {
        Text(e.episode)
        Text(e.name)
        
    }
}

