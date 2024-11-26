//
//  ActivityFinderView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/21/24.
//

import SwiftUI
import SwiftData

struct ActivityFinderView: View {
    @Query(filter: ModelHelper().homeActivityPredicate) var homeActRes: [ActivityClass]
    
    @Binding var currentSelection: ActivityClass?
    
    @State var navPath = NavigationPath()
    
    var body: some View {
        ActClassSearchView(selectedClass: $currentSelection)
        NavigationStack(path: $navPath) {
            if let bridgedBinding = Binding<ActivityClass>($currentSelection){
                VStack{
                    ActClassFullEditableView(actClass: bridgedBinding)
                }
                
            }
            else if let homeActClass = homeActRes.first {
                ActivityClassList(classesToShow: homeActClass.orderedSubActivities) { actClass in
                    ActivityClassSmallCellView(activityClass: actClass){ actClass in
                        self.currentSelection = actClass
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var sample: ActivityClass? = nil//ActivityClass.dummyActivity()
    
    let container: ModelContainer = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        ActivityDummyData().insertSwissBurgerRecepie(into: toReturn)
        return toReturn
    }()
    
    ActivityFinderView(currentSelection: $sample)
        .modelContainer(container)
}
