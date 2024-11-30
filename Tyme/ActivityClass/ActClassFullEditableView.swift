//
//  ActClassFullEditableView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/19/24.
//

import SwiftUI
import SwiftData

struct ActClassFullEditableView: View {
    @Environment(\.modelContext) var context
    
    @Query(filter: ModelHelper().homeObjectPredicate) var homeObjRes: [ActivityObject]
    
    @State var editManager: ActivityClass.UIEditsManager
    @State var searching: Bool = false
    
    @Binding var actClass: ActivityClass
    
    init(actClass: Binding<ActivityClass>) {
        _actClass = actClass
        editManager = ActivityClass.UIEditsManager(for: actClass.wrappedValue)
    }
    
    var body: some View {
        VStack {
            if editManager.isEditing {
                TextField("Do what?", text: $editManager.name)
                TextEditor(text: $editManager.detail)
                EditableTimer(time: $editManager.waitAfterStart)
                ActClassSearchView(selectedClass: $editManager.next)
                ActivityClassList(classesToShow: actClass.orderedSubActivities){  ActivityClassSmallCellView(actClass: $0) { selectedClass in
                    actClass = selectedClass
                }}
            }
            else {
                HStack{
                    Text(actClass.name)
                    Spacer()
                    if let homeObj = homeObjRes.first {
                        Button("Start"){
                            actClass.start(
                                context: context,
                                parentObject: homeObj,
                                stepNumber: 0
                            )
                        }
                    }
                    
                }
                Text(actClass.detail ?? "")
                Text((actClass.waitAfterCompletion ?? Double(0)).formatted())
                Divider()
                HStack{
                    Text("Next: ")
                    Spacer()
                    Button(actClass.next?.name ?? "none"){
                        if let next = actClass.next {
                            actClass = next
                        }
                    }.disabled(actClass.next == nil)
                }
                ActivityClassList(classesToShow: actClass.orderedSubActivities){  ActivityClassSmallCellView(actClass: $0) { selectedClass in
                    actClass = selectedClass
                }}
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
                        editManager = ActivityClass.UIEditsManager(for: actClass)
                        editManager.isEditing = true
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var sample: ActivityClass = {
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
    
    NavigationStack{
        ActClassFullEditableView(actClass: $sample)
            .modelContainer(container)
    }
}
