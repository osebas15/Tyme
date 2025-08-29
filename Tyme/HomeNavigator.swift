//
//  HomeNavigator.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/21/24.
//

import SwiftUI
import SwiftData

struct HomeNavigator: View {
    @Environment(\.modelContext) var context: ModelContext
    @Environment(\.navStore) var nav: NavigationStore
    
    @Query(filter: ModelHelper().homeObjectPredicate) var homeActObjs: [ActivityObject]
    @Query(filter: ModelHelper().homeActivityPredicate) var homeActClasses: [ActivityClass]
    
    var body: some View {
        if homeActObjs.isEmpty || homeActClasses.isEmpty {
            Text("error loading home models")
        }
        //ActiveObjects to show
        else if
            nav.focusedActObj != nil ||
            !homeActObjs[0].unOrderedActivities.isEmpty
        {
            let objsToShow = homeActObjs[0].lowestActivities
                .compactMap({$0})
                .duplicatesRemoved()
            
            List(objsToShow){ obj in
                ActivityObjectCellView(activityObject: obj, currentTime: Date())
            }
        }
        //select ActivityClass for nav and starting the activity
        else if let focusedClass = nav.focusedActClass ?? homeActClasses.first {
            ActivityClassList(classesToShow: focusedClass.orderedSubActivities) { subClass in
                HStack{
                    Text(subClass.name)
                        .onTapGesture {
                            nav.consumeAction(action: .focusActClass(subClass), context: context)
                        }
                    Spacer()
                    Button("start"){
                        nav.consumeAction(
                            action: .initializeAction(
                                actClass: subClass,
                                parentObj: !homeActObjs.isEmpty ? homeActObjs[0] : nil),
                            context: context
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    let container = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        return toReturn
    }()
    
    let nav = NavigationStore()
    
    NavigationStack{
        HomeNavigator()
            .modelContainer(container)
            .navigationRedux(nav)
    }
}
