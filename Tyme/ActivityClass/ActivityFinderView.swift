//
//  ActivityFinderView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/21/24.
//

import SwiftUI
import SwiftData

struct ActivityFinderView: View {
    @Environment(\.navStore) var nav: NavigationStore
    @Environment(\.modelContext) var context: ModelContext
    
    @Query(filter: ModelHelper().homeActivityPredicate) var homeActRes: [ActivityClass]
    
    @Binding var currentSelection: ActivityClass?
    
    @State var navPath = NavigationPath()
    
    var body: some View {
        ActClassSearchView(selectedClass: $currentSelection)
        NavigationStack(path: $navPath) {
            if let bridgedBinding = Binding<ActivityClass>($currentSelection){
                VStack{
                    Text("here")
                    //ActClassFullEditableView(actClass: bridgedBinding)
                }
                
            }
            else if let homeActClass = homeActRes.first {
                ActivityClassList(classesToShow: homeActClass.orderedSubActivities) { actClass in
                    Text(actClass.name + " 7")
                        /*.onTapGesture {
                            print("print statement")
                            let _ = nav.consumeAction(action: .focusActClass(actClass), context: context)
                        }*/
                }
                .onTapGesture{
                    print("pati is here")
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
        //ActivityDummyData().insertSwissBurgerRecepie(into: toReturn)
        return toReturn
    }()
    
    let nav = NavigationStore()
    
    ActivityFinderView(currentSelection: $sample)
        .modelContainer(container)
        .navigationRedux(nav)
}
