//
//  ActivityFinderView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/21/24.
//

import SwiftUI
import SwiftData

struct ActivityFinderView: View {
    
    @Binding var currentSelection: ActivityClass?
    
    @State var navPath = NavigationPath()
    
    var body: some View {
        ActClassSearchView(selectedClass: $currentSelection)
        NavigationStack(path: $navPath) {
            
        }
    }
}

#Preview {
    @Previewable @State var sample: ActivityClass? = ActivityClass.dummyActivity()
    
    let container: ModelContainer = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        return toReturn
    }()
    
    ActivityFinderView(currentSelection: $sample)
        .modelContainer(container)
}
