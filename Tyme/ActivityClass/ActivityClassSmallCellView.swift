//
//  ActivityClassSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/8/24.
//

import SwiftUI

struct ActivityClassSmallCellView: View {
    var activityClass: ActivityClass
    
    var body: some View {
        HStack{
            Text(activityClass.name)
            Spacer()
            Button("Edit"){
                print("edit pressed")
            }
            Button("Start"){
                print("start pressed")
            }
        }
    }
}

/*
#Preview {
    ActivityClassSmallCellView()
}
*/
