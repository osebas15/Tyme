//
//  ActivityClassCell.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 10/26/24.
//

import SwiftUI
import SwiftData

struct ActivityClassCell: View {
    @Environment(\.modelContext) var model: ModelContext
    let parentObject: ActivityObject
    let activity: ActivityClass
    
    var body: some View {
        Text(activity.name)
        .onTapGesture {
            activity.start(context: model, parentObject: parentObject, stepNumber: 0)
        }
    }
}
/*
#Preview {
    ActivityClassCell()
}*/
