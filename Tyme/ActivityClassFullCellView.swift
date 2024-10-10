//
//  ActiviyClassFullCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 9/30/24.
//

import SwiftUI

struct ActivityClassFullCellView: View {
    var activity: ActivityClass
    
    var body: some View {
        VStack{
            Text(activity.name)
            HStack{
                Button("Detail"){
                    print("detail clicked")
                }
                .buttonStyle(.bordered)
                
                Button("Start"){
                    print("start clicked")
                }
                .buttonStyle(.bordered)
            }
            if let detail = activity.detail {
                Text(detail)
            }
            List(activity.subActivities){ activity in
                Text(activity.name ?? "name error")
            }
            
        }
    }
}
/*
#Preview {
    ActiviyClassFullCellView()
}
*/
