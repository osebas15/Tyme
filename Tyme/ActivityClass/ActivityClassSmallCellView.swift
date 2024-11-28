//
//  ActivityClassSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/8/24.
//

import SwiftUI

struct ActivityClassSmallCellView: ActivityCell {
    @Environment(\.modelContext) private var context
    
    var actClass: ActivityClass
    var onSelect: OnSelect
    
    var body: some View {
        VStack{
            HStack{
                Text(actClass.name)
                Spacer()
                Button("Edit"){
                    //onEditPressed(activityClass)
                }
                .buttonStyle(BorderlessButtonStyle())
                Button("Start"){
                    //activityClass.start(context: context, parentObject: parentObject, stepNumber: 0)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .onTapGesture {
                onSelect(actClass)
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
    
    ActivityClassSmallCellView(actClass: actClass, onSelect: {_ in})
        .modelContainer(container)
}
