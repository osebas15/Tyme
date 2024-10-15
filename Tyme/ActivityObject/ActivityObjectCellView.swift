//
//  ActivityObjectSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/11/24.
//

import SwiftUI

struct ActivityObjectCellView: View {
    @Environment(\.modelContext) var context
    
    @State var showingDetail: Bool = false
    
    let activityObject: ActivityObject
    
    var body: some View {
        VStack{
            Text(activityObject.activityClass?.name ?? "activityclass error")
            HStack{
                Button("show detail"){
                    print("toggle detail")
                }
                .buttonStyle(BorderlessButtonStyle())
                Button("pause"){
                    print("pause")
                }
                .buttonStyle(BorderlessButtonStyle())
                Button("done"){
                    activityObject.done(context: context)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        //if active sub activities or showing detail
        //  show the subactivites in a checkmark fashion
    }
}

/*
#Preview {
    ActivityObjectSmallCellView()
}
*/
