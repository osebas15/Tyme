//
//  ActivityObjectCountDown.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/15/24.
//

import SwiftUI
import SwiftData

struct ActivityObjectWaitCountDown: View {
    var currentTime: Date
    var actObject: ActivityObject
    
    var countDownString: String {
        let formatter = DateComponentsFormatter()
        let timeToFormat = self.actObject.timeLeftToWait ?? 0
        return formatter.string(from: timeToFormat) ?? "0"
    }
    
    var body: some View {
        Text(countDownString)
    }
}


/*
#Preview {
    ActivityObjectWaitCountDown()
}
*/
