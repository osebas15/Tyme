//
//  ActClassFullEditableView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/19/24.
//

import SwiftUI

struct ActClassFullEditableView: View {
    @Environment(\.modelContext) var context
    
    @State var editManager: ActivityClass.UIEditsManager
    @State var searching: Bool = false
    
    @State var actClass: ActivityClass?
    
    init(actClass: ActivityClass) {
        self.actClass = actClass
        editManager = ActivityClass.UIEditsManager(for: actClass)
    }
    
    var body: some View {
        VStack {
            TextField("Do what?", text: $editManager.name).background(.clear)
            TextEditor(text: $editManager.detail)
            EditableTimer(time: $editManager.waitAfterStart)
            ActClassSearchView(selectedClass: $editManager.next)
            ActivityClassList(classesToShow: actClass?.orderedSubActivities){  ActivityClassSmallCellView(activityClass: $0) { selectedClass in
                actClass = selectedClass
            }
            }
        }
        .toolbar {
            if editManager.isEditing {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("save"){
                        editManager.save(container: context.container)
                        editManager.isEditing = false
                    }
                }
            }
            else {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("edit"){
                        editManager.isEditing = true
                    }
                }
            }
        }
    }
}

#Preview {
    let sample = {
        let toReturn = ActivityClass.dummyActivity()
        toReturn.next = ActivityClass.dummyActivity()
        return toReturn
    }()
    
    let container = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        toReturn.mainContext.insert(sample)
        return toReturn
    }()
    
    let notAdded = ActivityClass(name: "")
    
    NavigationStack{
        ActClassFullEditableView(actClass: sample)
            .modelContainer(container)
    }
}
