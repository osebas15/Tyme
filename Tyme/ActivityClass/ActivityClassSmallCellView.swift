//
//  ActivityClassSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/8/24.
//

import SwiftUI

struct ActivityClassSmallCellView: View {
    @Environment(\.modelContext) private var context
    
    var activityClass: ActivityClass
    var parentObject: ActivityObject
    
    var onEditPressed: (ActivityClass) -> ()
    
    var body: some View {
        VStack{
            HStack{
                Text(activityClass.name)
                Spacer()
                Button("Edit"){
                    onEditPressed(activityClass)
                    print("edit pressed")
                }
                .buttonStyle(BorderlessButtonStyle())
                Button("Start"){
                    activityClass.start(context: context, parentObject: parentObject, stepNumber: 0)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

#Preview {
    let actClass = ActivityClass.dummyActivity()
    let actObj = ActivityObject.dummyObject()
    let container = {
        let toReturn = ModelHelper().getBasicContainer()
        //toReturn.mainContext.insert(actClass)
        toReturn.mainContext.insert(actObj)
        return toReturn
    }()
    
    ActivityClassSmallCellView(activityClass: actClass, parentObject: actObj, onEditPressed: {_ in})
        .modelContainer(container)
}
