//
//  Test.swift
//  KastuGO_CoreChallenge02
//
//  Created by Kelvin Ongko Hakim on 04/05/25.
//

import SwiftUI

struct Test: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Go to Detail") {
                    DetailView()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct DetailView: View {
    var body: some View {
        VStack {
            Text("Detail Screen")
        }
        .navigationTitle("Detail")
    }
}


#Preview {
    Test()
}
