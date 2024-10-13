//
//  ActivityObjectSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/11/24.
//

import SwiftUI

struct ActivityObjectCellView: View {
    @Environment(\.modelContext) var context
    @Environment(\.homeObject) var homeObject
    
    @State var showingDetail: Bool = false
    
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
                    //TODO
                    //activityObject.done(context: context, appState: appState)
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
