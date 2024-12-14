//
//  NavigationRedux.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 12/12/24.
//

import SwiftUI
import SwiftData

enum UserActions {
    case goToLanding, error(Error), startAction(actClass: ActivityClass, parentObj: ActivityObject? = nil), completeAction(ActivityObject)
}

enum ViewNavigator: Equatable {
    case landing(focus: ActivityClass? = nil, activeActivity: ActivityObject? = nil), error(Error)
    
    static func == (lhs: ViewNavigator, rhs: ViewNavigator) -> Bool {
        return lhs.toString() == rhs.toString()
    }
    
    func toString() -> String{
        switch self {
        case .landing(let actClass, let actObj):
            return ".landing(\(actClass?.id.uuidString ?? "nil"), \(actObj?.id.uuidString ?? "nil")"
        case .error(let error):
            return ".error(\(error))"
        }
    }
}

enum NavigationError: Error {
    case incorrectAction
    case contextUnavailable
}

typealias NavigationReducer = (ModelContext, [UserActions]) -> ViewNavigator

@MainActor
class NavigationStore {
    @Published var currentView: ViewNavigator = .landing()
    @Published var actionStack: [UserActions] = []
    
    func consumeAction(action: UserActions, context: ModelContext? = nil) -> Error? {
        var destination: ViewNavigator = ViewNavigator.error(NavigationError.incorrectAction)
        switch action {
        case .goToLanding:
            actionStack = []
            destination = .landing()
        case .startAction(_, _), .completeAction(_):
            actionStack.append(action)
            destination = .error(NavigationError.contextUnavailable)
        case .error:
            return NavigationError.incorrectAction
        }
        
        if let context = context {
            destination = defaultReducer(context: context, actions: actionStack)
        }
        currentView = destination
        
        return nil
    }
    
    func defaultReducer(context: ModelContext, actions: [UserActions]) -> ViewNavigator{
        var actionsToBeProcessed = actions
        let latestAction = actionsToBeProcessed.popLast()
        
        switch latestAction ?? .goToLanding{
        case .goToLanding:
            if let activity = ModelHelper().getHomeObject(container: context.container).unOrderedActivities.first {
                return .landing(activeActivity: activity)
            }
            else {
                return .landing()
            }
        case .startAction(let actClass, let parentObj):
            let parentObj = parentObj ?? ModelHelper().getHomeObject(container: context.container)
            actClass.start(context: context, parentObject: parentObj)
            
            let newAct = parentObj.unOrderedActivities.first(where: { $0.activityClass == actClass })
            
            return .landing(focus: actClass, activeActivity: newAct)
            
        case .completeAction(let object):
            object.complete(context: context)
            
            if let next = object.currentStep {
                return .landing(activeActivity: next)
            }
            else {
                return .landing()
            }
            
        case .error:
            return .error(NavigationError.incorrectAction)
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
