//
//  NavigationRedux.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 12/12/24.
//

import SwiftUI
import SwiftData

enum UserActions {
    case goToLanding, error(Error),
         focusActClass(ActivityClass),
         initializeAction(actClass: ActivityClass, parentObj: ActivityObject? = nil),
         startAction(ActivityObject),
         completeAction(ActivityObject)
}

enum NavigationError: Error {
    case incorrectAction
    case contextUnavailable
}

@Observable
class NavigationStore {
    var focusedActClass: ActivityClass?
    var focusedActObj: ActivityObject?
    var actionStack: [UserActions] = []
    
    @MainActor
    func consumeAction(action: UserActions, context: ModelContext? = nil){
        switch action {
        case .goToLanding:
            actionStack = []
            
        case .initializeAction(_, _), .startAction(_), .completeAction(_), .focusActClass(_):
            actionStack.append(action)
            
        case .error:
            return //NavigationError.incorrectAction
        }
        
        if let context = context {
            destinationReducer(context: context, actions: actionStack)
        }
    }
    
    @MainActor
    func destinationReducer(context: ModelContext, actions: [UserActions]){
        var actionsToBeProcessed = actions
        let latestAction = actionsToBeProcessed.popLast()
        
        switch latestAction ?? .goToLanding{
        case .goToLanding:
            if let activity = ModelHelper().getHomeObject(container: context.container).unOrderedActivities.first {
                self.focusedActObj = activity
                return
            }
            else {
                self.focusedActObj = nil
                self.focusedActClass = ModelHelper().getHomeActClass(container: context.container).orderedSubActivities.first
                
                return
            }
        case .initializeAction(let actClass, let parentObj):
            let parentObj = parentObj ?? ModelHelper().getHomeObject(container: context.container)
            actClass.start(context: context, parentObject: parentObj)
            
            let newAct = parentObj.unOrderedActivities.first(where: { $0.activityClass == actClass })
            
            self.focusedActObj = newAct
            self.focusedActClass = actClass
            
            return
            
        case .focusActClass(let actClass):
            self.focusedActClass = actClass
            self.focusedActObj = nil
            return
            
        case .startAction(let actObj):
            self.focusedActObj = actObj
            actObj.start()
            return
            
        case .completeAction(let object):
            object.complete(context: context)
            self.focusedActObj = object.currentStep
            return
            
        case .error:
            return
        }
    }
}

private struct NavigationStoreKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = NavigationStore()
}

extension EnvironmentValues {
    var navStore: NavigationStore {
        get { self[NavigationStoreKey.self] }
        set { self[NavigationStoreKey.self] = newValue }
    }
}

extension Scene {
    func navigationRedux(_ store: NavigationStore) -> some Scene {
        environment(\.navStore, store)
    }
}

extension View {
    func navigationRedux(_ store: NavigationStore) -> some View {
        environment(\.navStore, store)
    }
}
