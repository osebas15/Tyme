//
//  ActClassFullEditableView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/19/24.
//

import SwiftUI

struct ActClassFullEditableView: View {
    @Environment(\.modelContext) var context
    let actClass: ActivityClass
    @State var editManager: ActivityClass.UIEditsManager
    
    init(actClass: ActivityClass) {
        self.actClass = actClass
        editManager = ActivityClass.UIEditsManager(for: actClass)
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $editManager.name)
                .multilineTextAlignment(.center)
            TextEditor(text: $editManager.detail)
            EditableTimer(time: $editManager.waitAfterStart)
            HStack{
                Text("Next: \(actClass.next?.name ?? "nil")")
            }
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
    
    ActClassFullEditableView(actClass: sample)
        .modelContainer(container)
}
