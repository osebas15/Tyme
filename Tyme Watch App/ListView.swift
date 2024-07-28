//
//  HomeView.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Query(filter: #Predicate<ActivityClass>{ act in
        act.parent == nil
    }) var activityClasses: [ActivityClass]
    var body: some View {
        VStack{
            NavigationStack{
                List{
                    ForEach(activityClasses){ activity in
                        NavigationLink(destination: ActiveView(activity: activity)) {
                            Text(activity.name!)
                        }
                    }
                }
            }
        }
    }
    /*
    @ViewBuilder
    func destinationBuilder(activity: ActivityClass) -> some View {
        <#function body#>
    }*/
}

#Preview {
    ListView()
}
