//
//  NewActivityListView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 9/30/24.
//

import SwiftUI
import SwiftData

struct NewActivityListView: View {
    @Query(filter: ModelHelper().homeObjectPredicate) var homeObject: [ActivityObject]
    @Query(filter: ModelHelper().homeActivityPredicate ) var mainClass: [ActivityClass]
    
    @State var editingClass: ActivityClass?
    
    @State var currentClassHistory: [ActivityClass] = []
    
    var body: some View {
        if mainClass.count > 0 && homeObject.count > 0 {
            if let editingClass = editingClass {
                ActClassFullEditableView(actClass: editingClass)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back"){
                            self.editingClass = nil
                        }
                    }
                }
            }
            else {
                VStack{
                    let classToDisplay = currentClassHistory.last ?? mainClass[0]
                    List(classToDisplay.orderedSubActivities){ activity in
                        DisclosureGroup{
                            ForEach(activity.orderedSubActivities){ subAct in
                                Text(subAct.name)
                                    .onTapGesture {
                                        currentClassHistory += [activity]
                                    }
                            }
                        } label: {
                            ActivityClassSmallCellView(
                                activityClass: activity,
                                parentObject: homeObject[0],
                                onEditPressed: { editingClass = $0 }
                            )
                        }
                    }
                }
                .navigationTitle(currentClassHistory.last?.name ?? "Start Activity")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add"){
                            print("add pressed")
                        }
                    }
                    if let currentClass = currentClassHistory.last {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Back"){
                                self.currentClassHistory = self.currentClassHistory.dropLast()
                            }
                        }
                    }
                }
            }
        }
        else {
            Text("add new activities \(mainClass.count) \(homeObject.count)")
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
        NewActivityListView()
            .modelContainer(container)
    }
}

