//
//  NewActivityListView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 9/30/24.
//

import SwiftUI
import SwiftData
/*
struct NewActivityListView: View {
    
    @State var editingClass: ActivityClass?
    
    var currentClass: ActivityClass
    
    var body: some View {
        if let editingClass = editingClass {
            ActClassFullEditableView(actClass: editingClass)
        }
        else {
            VStack{
                List(currentClass.orderedSubActivities){ activity in
                    DisclosureGroup{
                        ForEach(activity.orderedSubActivities){ subAct in
                            Text(subAct.name)
                                .onTapGesture {
                                    //currentClassHistory += [activity]
                                }
                        }
                    } label: {
                        ActivityClassSmallCellView(
                            activityClass: activity,
                            parentObject: homeObject[0],
                            onEditPressed: { editingClass = $0 }
                        )
                        .onTapGesture {
                            //currentClassHistory += [activity]
                        }
                    }
                }
            }
            .navigationTitle(currentClass.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add"){
                        print("add pressed")
                    }
                }
            }
        }
    }
}

#Preview {
    let sample = ActivityClass.dummyActivity()
    
    let container = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        toReturn.mainContext.insert(sample)
        return toReturn
    }()
    
    NavigationStack{
        NewActivityListView(currentClass: sample)
            .modelContainer(container)
    }
}
*/
