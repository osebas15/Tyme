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
            ActivityClassList(selectedClass: $currentSelection) { actClass in
                ActivityClassSmallCellView(activityClass: actClass) { actClass in
                    print("selected")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var sample: ActivityClass? = nil//ActivityClass.dummyActivity()
    
    let container: ModelContainer = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        return toReturn
    }()
    
    ActivityFinderView(currentSelection: $sample)
        .modelContainer(container)
}
