//
//  AppStateSchema.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/9/24.
//

import Foundation
import SwiftData
import SwiftUI

typealias AppState = AppState0_0_0.AppState

enum AppState0_0_0: VersionedSchema {
    static var models: [any PersistentModel.Type] = [AppState.self]
    
    static var versionIdentifier = Schema.Version(0,0,0)
    
    @Model
    class AppState {
        var activeActivities: [ActivityObject]
        
        init(activeActivities: [ActivityObject] = []) {
            self.activeActivities = activeActivities
        }
    }
}

private struct AppStateKey: EnvironmentKey {
    static let defaultValue = AppState()
}

extension EnvironmentValues{
    var appState: AppState{
        get{
            self[AppStateKey.self]
        }
        set{
            self[AppStateKey.self] = newValue
        }
    }
}
