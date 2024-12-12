//
//  ActivityClassSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/8/24.
//

import SwiftUI
import SwiftData

struct ActivityClassSmallCellView: ActivityCell {
    @Query(filter: ModelHelper().homeObjectPredicate) var homeObjRes: [ActivityObject]
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
                if let homeObj = homeObjRes.first {
                    Button("Start"){
                        actClass.start(context: context, parentObject: homeObj)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                
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
