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
    
    var body: some View {
        HStack{
            Text(activityClass.name)
            Spacer()
            Button("Edit"){
                print("edit pressed")
            }
            .buttonStyle(.automatic)
            Button("Start"){
                activityClass.start(context: context, parentObject: parentObject)
            }
            .buttonStyle(.automatic)
        }
    }
}

/*
#Preview {
    ActivityClassSmallCellView()
}
*/
