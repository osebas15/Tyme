//
//  ActiveObjCellButton.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 12/26/24.
//

import SwiftUI
import SwiftData

struct ActiveObjCellButton: View {
    @Environment(\.modelContext) var context: ModelContext
    @Environment(\.navStore) var nav: NavigationStore
    let actObj: ActivityObject
    
    var body: some View {
        switch actObj.verifyCurrentState(){
        case .waitingToStart where actObj.activityClass?.waitAfterCompletion == nil:
           Button {
                nav.consumeAction(action: .startAction(actObj), context: context)
            } label: {
                Image(systemName: "circle")
                    .foregroundColor(Color.black)
            }
        case .waitingToStart:
            Button {
                nav.consumeAction(action: .startAction(actObj), context: context)
            } label: {
                Image(systemName: "play.circle.fill")
                    .foregroundColor(Color.green)
            }
            
        case .started:
            Button {
                nav.consumeAction(action: .completeAction(actObj), context: context)
            } label: {
                Image(systemName: "stop.circle.fill")
                    .foregroundColor(Color.blue)
            }
        case .overdue:
            Button {
                nav.consumeAction(action: .completeAction(actObj), context: context)
            } label: {
                Image(systemName: "stop.circle.fill")
                    .foregroundColor(Color.orange)
            }
        case .done:
            Button {
                //nav.consumeAction(action: .completeAction(actObj), context: context)
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.green)
            }
        default:
            Text("default")
         /*
        case .inSubsteps:
        case .overdue:
        case .error:
          */
        }
    }
}

#Preview {
    let waitingToStartWithWait = ActivityClass(name: "waiting to start with wait", waitAfterCompletion: 1)
    let waitingToStartWithoutWait = ActivityClass(name: "waiting to start without wait")
    let startedWithWait = ActivityClass(name: "started with wait", waitAfterCompletion: 1)
    let startedWithOutWait = ActivityClass(name: "started without wait")
    let overdue = ActivityClass(name: "overdue", waitAfterCompletion: 1)
    //let inSubsteps = ActivityClass(name: "inSubsteps")
    let doneWithWait = ActivityClass(name: "done with wait", waitAfterCompletion: 1)
    let doneWithOutWait = ActivityClass(name: "done without wait")
    
    let allClasses = [waitingToStartWithWait, waitingToStartWithoutWait, startedWithWait, startedWithOutWait, overdue, doneWithWait, doneWithOutWait]
    
    let container = {
        let container = ModelHelper().getBasicContainer()
        allClasses.forEach { container.mainContext.insert($0) }
        return container
    }()
    
    let nav = {
        let nav = NavigationStore()
        
        allClasses.forEach { actClass in
            nav.consumeAction(
                action: .initializeAction(
                    actClass: actClass,
                    parentObj: ModelHelper().getHomeObject(container: container)
                ),
                context: container.mainContext
            )
        }
        
        let allObj = ModelHelper().getHomeObject(container: container).orderedActivities
        
        let toStart = allObj.dropFirst(2)
        toStart.forEach { actObj in
            nav.consumeAction(
                action: .startAction(actObj),
                context: container.mainContext
            )
        }
        
        let toComplete = allObj.dropFirst(5)
        toComplete.forEach { actObj in
            nav.consumeAction(
                action: .completeAction(actObj),
                context: container.mainContext
            )
        }
        
        return nav
    }()
    
    let allObj = ModelHelper().getHomeObject(container: container).orderedActivities
        .map({obj in
            if obj.activityClass == overdue {
                obj.startDate = Date() - 10
            }
            return obj
        })
    
    VStack{
        ForEach(allClasses){ actClass in
            Text(actClass.name)
            ActiveObjCellButton(actObj: allObj.first(where: {$0.activityClass == actClass})!)
                .modelContainer(container)
                .navigationRedux(nav)
            Spacer()
        }
    }
}
