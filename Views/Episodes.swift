import SwiftUI

import SwiftUI

struct Episode: Decodable, Hashable {
    var id: Int
    var name: String
    var air_date: String
    var episode: String
    var characters: [String]
    var url: String
    var created: String
}


struct EResponse: Decodable, Hashable {
    var info: Info
    var results: [Episode]
}


struct Episodes: View {
    
    
    @State var episodes: Array<Episode>?
    @State var page: Int = 1
    @State var pages: Int?
    
    func fetchData() {
        guard let url = URL (string: "https://rickandmortyapi.com/api/episode/?page=\(page)"    ) else {
            return
        }
        
        
        let task =  URLSession.shared.dataTask(with: url) {
            data,_,error in 
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(EResponse.self, from: data)
                DispatchQueue.main.async {
                    episodes = result.results
                    pages = result.info.pages
                    
                } 
            } catch {
                print("JSONSerialization error:", error)
            }
        }
        task.resume()
    }
    
    var body: some View {
        
        if let episodes = episodes {
            List {
                Picker("Page", selection: $page) {
                    ForEach(1...pages!, id: \.self) {i in
                        Text("Page \(i)").tag(i)
                    }
                }.onChange(of: page) {_ in fetchData()}
                ForEach(episodes, id: \.self) {e in
                    NavigationLink(destination: EpisodeView(e: e)) { 
                        Text(e.episode+": "+e.name)
                    }
                }
            }.navigationTitle("Episodes")
        } else {
            ProgressView().onAppear{fetchData()}
        }
    }
}
