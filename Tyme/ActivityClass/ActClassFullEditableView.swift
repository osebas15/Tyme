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
    
    let actClass: ActivityClass
    
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
        }
        .toolbar { ToolbarItem(placement: .topBarTrailing) {
            Button("save"){
                editManager.save(container: context.container)
            }
        }}
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
    
    ActClassFullEditableView(actClass: sample)
        .modelContainer(container)
}
