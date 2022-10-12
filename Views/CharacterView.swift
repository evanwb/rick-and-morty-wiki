import SwiftUI

struct EpisodesView: View {
    let e: [String]
    let c: Character
    
    @State var fetched: Bool = false
    
    @State var episodes = [Episode]()
    
    func fetchNames() async throws {
        if (fetched) {
            return}
        for ep in e {
            guard let url = URL (string: ep ) else {
                return
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(Episode.self, from: data)
            episodes.append(result)
        }
        
        fetched = true
    }
    
    
    var body: some View {
        
        
        List {
            ForEach(episodes, id: \.self) {ep in
                NavigationLink(destination: EpisodeView(e: ep) ) {
                    Text(ep.episode+": "+ep.name)
                }
                
            }
        }.navigationTitle("\(c.name) Episodes").onAppear{Task{
            try await fetchNames()
        }}}
}

struct CharacterView: View {
    let c: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack {
                    //Text(c.name).font(.system(size: 40, weight: .bold))
                    NavigationLink(destination: EpisodesView(e: c.episode, c: c)) {
                        Text("Appears in \(c.episode.count) \(c.episode.count==1 ? "episode":"episodes")").font(.system(size: 20))
                    }}.padding(.horizontal)
                AsyncImage(url: URL(string: c.image),
                           content: {image in
                    image.resizable().padding(.horizontal).aspectRatio(contentMode: .fit)
                },
                           placeholder: {
                    ProgressView()
                }
                ).clipShape(Circle()).padding(.vertical, 20)
                
                
                VStack(alignment: .leading) {
                    Text("**Status:** \(c.status)")
                    Text("**Species:** \(c.species)")
                    Text("**Location:** \(c.location.name)")
                    Text("**Origin:** \(c.origin.name)").onTapGesture {
                        print(c.origin.url)
                    }
                    
                    
                    
                    
                }.font(.system(size: 25)).padding(.all)
                
                Spacer()
            }}.navigationTitle(c.name)
    }
}

struct CharacterPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


