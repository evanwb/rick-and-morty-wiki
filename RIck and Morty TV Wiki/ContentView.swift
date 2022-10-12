//
//  ContentView.swift
//  RIck and Morty TV Wiki
//
//  Created by Evan Burton on 10/11/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
                    List {
                        NavigationLink(destination: Characters()) {
                            Text("Characters")
                        }
                        NavigationLink(destination: Episodes()) {
                            Text("Episodes")
                        }
                        NavigationLink(destination: Locations()) {
                            Text("Locations")
                        }
                    }.navigationTitle("Rick and Morty")
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
