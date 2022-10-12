import SwiftUI


struct ChLocation: Decodable, Hashable {
    var name, url: String
}

struct Character : Decodable, Hashable {
    var id : Int
    var name, status, species, image, type : String
    var location: ChLocation
    var episode: [String]
    var origin: Origin
}

struct Info: Decodable, Hashable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}


struct Origin: Decodable, Hashable {
    var name, url: String
}
struct CResponse: Decodable, Hashable {
    var info: Info
    var results: [Character]
}


var res: CResponse?

struct Characters: View {
    
    
    @State var chars: Array<Character>?
    @State var pages: Int?
    @State var page: Int = 0
    @State private var searchText = ""

    
    func getData() {
        print("")
        guard let url = URL (string: "https://rickandmortyapi.com/api/character/?page=\(page)"    ) else {
            return
        }
        
        let task =  URLSession.shared.dataTask(with: url) {
            data,_,error in 
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(CResponse.self, from: data)
                DispatchQueue.main.async {
                    chars = result.results
                    pages = result.info.pages
                } 
            } catch {
                print("JSONSerialization error:", error)
            }
        }
        task.resume()
    }
    
    func fetchData(name: String) {
        print("naming")
        if (name == "") {
            getData()
            return
        }
        guard let url = URL (string: "https://rickandmortyapi.com/api/character/?page=\(page)&name=\(name)"    ) else {
            return
        }
        
        let task =  URLSession.shared.dataTask(with: url) {
            data,_,error in
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(CResponse.self, from: data)
                DispatchQueue.main.async {
                    chars = result.results
                    pages = result.info.pages
                }
            } catch {
                print("JSONSerialization error:", error)
            }
        }
        task.resume()
    }
    
    var body: some View {
        
        if let chars = chars {
            List {
                Picker("Page", selection: $page) {
                        ForEach(1...pages!, id: \.self) {i in
                            Text("Page \(i)").tag(i)
                        }
                    }.onChange(of: page) {_ in getData()}
                ForEach(chars, id: \.self) {c in
                    NavigationLink(destination: CharacterView(c: c)) {
                        Text(c.name)
                    }
                }
            }.navigationTitle("Characters").searchable(text: $searchText, prompt: Text("Character Name")).onChange(of: searchText) { newValue in
                fetchData(name: searchText)
            }
        } else {
            ProgressView().onAppear{getData()}
        }
    }
    
    var searchResults: [Character]! {
            if searchText.isEmpty {
                return chars
            } else {
                return chars!.filter { $0.name.contains(searchText) }
            }
        }
}

struct Characters_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
