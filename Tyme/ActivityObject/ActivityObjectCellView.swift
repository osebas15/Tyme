//
//  ActivityObjectSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/11/24.
//

import SwiftUI

struct ActivityObjectCellView: View {
    @Environment(\.modelContext) var context
    
    let activityObject: ActivityObject
    
    var body: some View {
        VStack{
            Text(activityObject.activityClass?.name ?? "activityclass error")
            HStack{
                Button("pause"){
                    print("pause")
                }
                .buttonStyle(BorderlessButtonStyle())
                Button(activityObject.hasNext ? "next" : "done"){
                    activityObject.done(context: context)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

/*
#Preview {
    ActivityObjectSmallCellView()
}
*/
