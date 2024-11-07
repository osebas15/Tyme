//
//  ActiveObjectCellView.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 10/31/24.
//

import SwiftUI
import SwiftData

struct ActiveObjectCellView: View {
    @Environment(\.modelContext) var context: ModelContext
    //@Environment(\.uiTimer) var uiTimer: UITimer
    @State var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let activity: ActivityObject
    
    var body: some View {
        HStack{
            if activity.focus != .done {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
            }
            else {
                Image(systemName: "circle.fill")
                    .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.2))
            }
            
            Text(activity.activityClass!.name)
            Spacer()
            
            Text(currentTime.formatted(date: .omitted, time: .standard))
                .onReceive(timer) { _ in
                    self.currentTime = Date()
                }
            
        }
        .onTapGesture {
            activity.done(context: context)
        }
    }
}

#Preview {
    ActiveObjectCellView(activity: ActivityObject.dummyObject())
}

