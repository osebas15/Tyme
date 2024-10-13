//
//  ActivityClassSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/8/24.
//

import SwiftUI

struct ActivityClassSmallCellView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.homeObject) private var homeObject
    var activityClass: ActivityClass
    
    var body: some View {
        HStack{
            Text(activityClass.name)
            Spacer()
            Button("Edit"){
                print("edit pressed")
            }
            .buttonStyle(.automatic)
            Button("Start"){
                //TODO
                //activityClass.start(context: context, appState: appState)
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
