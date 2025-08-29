//
//  ActivityObjectSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/11/24.
//

import SwiftUI

struct ActivityObjectCellView: View {
    @Environment(\.modelContext) var context
    //@Environment(\.timerManager) var timerManager
    let activityObject: ActivityObject
    let currentTime: Date
    
    var body: some View {
        VStack {
            HStack{
                VStack{
                    Text(activityObject.activityClass?.name ?? "activityclass error")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.top)
                Spacer()
                ActiveObjCellButton(actObj: activityObject)
                    .frame(maxWidth: 60)
            }
            HStack{
                TimeLeftToWait(totalTime: activityObject.timeFromStartTo(date: currentTime), expectedTime: activityObject.activityClass?.waitAfterCompletion)
                Spacer()
            }
            Spacer()
            Text(activityObject.activityClass?.detail ?? "")
        }
        .padding()
    }
}

#Preview {
    let container = ModelHelper().getBasicContainer()
    let nav = NavigationStore()
    
    let data = {
        let toRet = ActivityDummyData().getFlowSamplesClassesAnObjects(container: container, nav: nav)
        toRet.actObjects.enumerated().forEach({(index, obj) in
            if index == 1 {
                obj.creationDate = Date() - 60
            }
            if index == 2 {
                obj.startDate = Date() - 60
            }
        })
        return toRet
    }()
    
    VStack{
        List(data.actObjects){ obj in
            ActivityObjectCellView(activityObject: obj, currentTime: Date())
        }
    }
    .modelContainer(container)
    .environment(\.navStore, nav)
}
