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
    let container = ModelHelper().getBasicContainer()
    let nav = NavigationStore()
    
    let testData = ActivityDummyData().getFlowSamplesClassesAnObjects(container: container, nav: nav)
    
    VStack{
        ForEach(testData.actClasses){ actClass in
            Text(actClass.name)
            ActiveObjCellButton(actObj: testData.actObjects.first(where: {$0.activityClass == actClass})!)
                .modelContainer(container)
                .navigationRedux(nav)
            Spacer()
        }
    }
}
