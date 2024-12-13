//
//  NavigationRedux.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 12/12/24.
//

import SwiftUI
import SwiftData

@MainActor
class NavigationRedux: ObservableObject {
    var navStack: [Action] = []
    
    enum Action: Equatable {
        static func == (lhs: NavigationRedux.Action, rhs: NavigationRedux.Action) -> Bool {
            return lhs.toString() == rhs.toString()
        }
        
        func toString() -> String {
            switch self {
            case .landed(let active):
                return ".landed(\(active))"
            case .goToLanding:
                return ".goToLanding"
            case .empty:
                return ".empty"
            case .error:
                return ".error"
            }
        }
        
        func isMainView() -> Bool {
            switch self {
            case .landed(active: _):
                return true
            default:
                return false
            }
        }
        
        case landed(active: Bool), goToLanding
        case empty, error
    }
    
    func reduce(context: ModelContext, action: Action){
        guard
            !navStack.isEmpty
        else {
            navStack = [getLandingAction(context: context)]
            return
        }
        
        switch action{
        case .landed(active: _), .goToLanding :
            navStack = [getLandingAction(context: context)]
        default:
            navStack.append(.error)
        }
    }
    
    func getLandingAction(context: ModelContext) -> Action {
        let homeObj = ModelHelper().getHomeObject(container: context.container)
        
        print("inner: \(homeObj.unOrderedActivities.count)")
        return .landed(active:
            homeObj.unOrderedActivities.count > 0 ? true : false
        )
    }
    
    func getMainView() -> Action {
        return navStack.reversed().first(where: { $0.isMainView() }) ?? .error
    }
}
