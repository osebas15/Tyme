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
    
    @State var navStack: [Action] = []
    
    enum Action {
        case Landed(active: Bool)
        case Error(error: Error)
    }
    
    func reducer(navStack: [Action], action: Action, context: ModelContext) -> [Action]{
        guard !navStack.isEmpty else {
            return [getLandingAction(context: context)]
        }
        
        return navStack
    }
    
    func getLandingAction(context: ModelContext) -> Action {
        let homeObj = ModelHelper().getHomeObject(container: context.container)
        
        return .Landed(active:
            homeObj.unOrderedActivities.count > 0 ? true :false
        )
    }
}
