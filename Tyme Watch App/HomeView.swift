//
//  HomeView.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/31/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    let activities: [ActivityClass]
    let mainObject: ActivityObject
    
    var body: some View {
        List(activities){ activity in
            ActivityClassCell(parentObject: mainObject, activity: activity)
        }
    }
}

/*
#Preview {
    HomeView()
 }*/
