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
            case .error(let error):
                return ".error(\(error))"
            }
        }
        
        case landed(active: Bool), goToLanding
        case empty, error(error: Error)
    }
    
    init(context: ModelContext) {
        let initStack = reduce(context: context, action: .empty)
        self.navStack = initStack
    }
    
    func reduce(context: ModelContext, action: Action) -> [Action]{
        guard !navStack.isEmpty else {
            return [getLandingAction(context: context)]
        }
        
        return navStack
    }
    
    func getLandingAction(context: ModelContext) -> Action {
        let homeObj = ModelHelper().getHomeObject(container: context.container)
        
        print("inner: \(homeObj.unOrderedActivities.count)")
        return .landed(active:
            homeObj.unOrderedActivities.count > 0 ? true : false
        )
    }
}
