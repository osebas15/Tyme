//
//  HomeView.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/31/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    
    @Query(filter: #Predicate<ActivityClass>{ act in
        true//act.parents == nil
    }) var activityClasses: [ActivityClass]
    
    var body: some View {
        Text("Hello, World! \(activityClasses.count) \(context)")
    }
}

#Preview {
    HomeView()
}
