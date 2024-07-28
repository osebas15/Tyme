//
//  PassiveView.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI

struct PassiveView: View {
    var activity: ActivityClass
    var body: some View {
        VStack {
            Text("\(activity)")//.subActivities.count)")
        }
    }
}

#Preview {
    PassiveView(activity: ActivityClass.getDummyActivities()[0])
}
