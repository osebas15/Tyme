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
    @State var chosenActivity: ActivityClass?
    
    var body: some View {
        if let currentActivities = homeActObjs.first?.lowestActivities, currentActivities.count > 1 {
            ActiveActivitiesView(activeActivities: currentActivities)
        }
        else if let first = homeActClasses.first, chosenActivity == first {
            ActivityClassList(classesToShow: first.orderedSubActivities) { actClass in
                ActivityClassSmallCellView(actClass: actClass) { actClass in
                    chosenActivity = actClass
                }
            }
        }
        else {
            ActivityFinderView(currentSelection: $chosenActivity)
                .navigationTitle("Start")
        }
    }
}

#Preview {
    let container = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        return toReturn
    }()
    
    NavigationStack{
        HomeNavigator()
            .modelContainer(container)
    }
}
