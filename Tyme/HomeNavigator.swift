//
//  HomeNavigator.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/21/24.
//

import SwiftUI
import SwiftData

struct HomeNavigator: View {
    @Query(filter: ModelHelper().homeObjectPredicate) var homeActObjs: [ActivityObject]
    @Query(filter: ModelHelper().homeActivityPredicate) var homeActClasses: [ActivityClass]
    
    @State var navPath = NavigationPath()
    
    var body: some View {
        if let currentActivities = homeActObjs.first?.orderedActivities, !currentActivities.isEmpty {
            ActiveActivitiesView(activeActivities: currentActivities)
        }
        else if let homeActClass = homeActClasses.first{
            //NewActivityListView(currentClass: homeActClass)
        }
        else {
            Text("error")
        }
    }
}

#Preview {
    let container = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        return toReturn
    }()
    
    HomeNavigator()
        .modelContainer(container)
}
