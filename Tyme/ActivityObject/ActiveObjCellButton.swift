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
        Button {
            print("act")
        } label: {
            
        }

    }
}

#Preview {
    ActiveObjCellButton()
}
