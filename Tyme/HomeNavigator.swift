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
    
    init() {
        let _ = self.nav.consumeAction(action: .goToLanding, context: self.context)
    }
    
    var body: some View {
        switch nav.currentView {
        case .landing(focus: nil, activeActivity: let actObj) where actObj != nil:
            Text(actObj?.activityClass?.name ?? "nil")
            /*
            ActivityClassList(classesToShow: homeActClasses.first?.orderedSubActivities ?? []) { actClass in
                ActivityClassSmallCellView(actClass: actClass) { actClassInner in
                    chosenActivity = actClassInner
                }
            }*/
        case .landing(focus: let actClass, activeActivity: _):
            let classes = actClass?.orderedSubActivities ?? homeActClasses.first?.orderedSubActivities ?? []
            
            ActivityClassList(classesToShow: classes) { subClass in
                //ActivityClassSmallCellView(actClass: subClass) { cellClass in
                    
                    //let _ = nav.consumeAction(action: .focusActClass(cellClass), context: context)
                //}
                Text(subClass.name)
                    .onTapGesture {
                        nav.currentView = .landing(focus: subClass, activeActivity: nil)
                    }
            }
            
            //ActivityFinderView(currentSelection: selectionBinding)
                //.navigationTitle("Start")
        default:
            Text("error in Home Nav")
                /*.onAppear{
                    nav.navStack = [.landed(active: false)]
                    //nav.reduce(context: context, action: .goToLanding)
                }*/
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
