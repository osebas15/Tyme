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
                Text(activityObject.activityClass?.name ?? "activityclass error")
                    .font(.title)
                Spacer()
                ActiveObjCellButton(actObj: activityObject)
                    .frame(maxWidth: 60)
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
        //toRet.actClasses.forEach({$0.name = $0.name + "just a long stinfgc asdfasd fas dfas dfsdf"})
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
