//
//  ContentView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack{
            VStack {
                NewActivityListView()
            }
        }
    }
}

#Preview {
    ContentView()
}
