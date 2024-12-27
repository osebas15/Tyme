//
//  ActivityObjectDetailsBar.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 12/26/24.
//

import SwiftUI

struct ActivityObjectDetailsBar: View {
    var actObj: ActivityObject
    var body: some View {
        HStack{
            if let timeToComp = actObj.activityClass!.waitAfterCompletion{
                Text("\(Int(timeToComp / 60)) min")
                    .font(.callout)
                    .padding(5)
                    .padding(.horizontal, 6)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(17)
            }
            Spacer()
        }
    }
}

#Preview {
    let obj = {
        let obj = ActivityObject.dummyObject()
        obj.activityClass?.waitAfterCompletion = 300
        return obj
    }()
    ActivityObjectDetailsBar(actObj: obj)
}
