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
    
    @State var showingDetail: Bool
    
    let activityObject: ActivityObject
    
    var body: some View {
        VStack{
            Text(activityObject.activityClass.name)
            HStack{
                Button("show detail"){
                    print("toggle detail")
                }
                Button("pause"){
                    print("pause")
                }
                Button("done"){
                    activityObject.done(context: context, appState: appState)
                }
            }
        }
    }
}

/*
#Preview {
    ActivityObjectSmallCellView()
}
*/
