//
//  ContentView.swift
//  Tenki App
//
//  Created by ethancr0wn on 2021/03/02.
//

import SwiftUI

struct ContentView: View {
    @State private var location: String = ""
    var body: some View {
        TextField("Enter location", text: $location)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
