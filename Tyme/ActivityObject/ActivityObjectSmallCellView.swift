//
//  ActivityObjectSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/11/24.
//

import SwiftUI

struct ActivityObjectSmallCellView: View {
    @Environment(\.modelContext) var context
    @Environment(\.appState) var appState
    let activityObject: ActivityObject
    
    var body: some View {
        HStack{
            Text(activityObject.activityClass.name)
            Spacer()
            Button("done"){
                activityObject.done(context: context, appState: appState)
            }
        }
    }
}

/*
#Preview {
    ActivityObjectSmallCellView()
}
*/
