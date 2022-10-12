import SwiftUI



struct Location : Decodable, Hashable {
    var id : Int
    var name : String
    var type: String
    var dimension: String
    var residents: [String]
}
struct LResponse: Decodable, Hashable {
    var info: Info
    var results: [Location]
}

struct Locations: View {
    
    
    @State var locations: [Location]?
    @State var page: Int = 0
    @State var pages: Int?
    
    func fetchData() {
        guard let url = URL (string: "https://rickandmortyapi.com/api/location/?page=\(page)"    ) else {
            return
        }
        let task =  URLSession.shared.dataTask(with: url) {
            data,_,error in 
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(LResponse.self, from: data)
                DispatchQueue.main.async {
                    locations = result.results
                    pages = result.info.pages
                    
                } 
            } catch {
                print("JSONSerialization error:", error)
            }
        }
        task.resume()
    }
    
    var body: some View {
        
        if let locations = locations {
            List {
                Picker("Page", selection: $page) {
                    ForEach(1...pages!, id: \.self) {i in
                        Text("Page \(i)").tag(i)
                    }
                }.onChange(of: page) {_ in fetchData()}
                ForEach(locations, id: \.self) {l in
                    NavigationLink(destination: LocationView(l: l)) { 
                        Text(l.name)
                    }
                }
            }.navigationTitle("Locations")
        } else {
            ProgressView().onAppear{fetchData()}
        }
    }
}
