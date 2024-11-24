//
//  ActivityClassList.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/22/24.
//

import SwiftUI
import SwiftData

struct ActivityClassList<Content: ActivityCell>: View {
    @Query(filter: ModelHelper().homeActivityPredicate) var homeClassResult: [ActivityClass]
    
    @Binding var selectedClass: ActivityClass?
    
    @ViewBuilder var content: (ActivityClass) -> Content
    
    var body: some View {
        VStack{
            let selectedClass = selectedClass ?? homeClassResult.first ?? ActivityClass.error()
            content(selectedClass)
            List(selectedClass.orderedSubActivities) { actClass in
                content(actClass)
            }
        }
    }
    
    init(selectedClass: Binding<ActivityClass?>, @ViewBuilder content: @escaping (ActivityClass) -> Content) {
        _selectedClass = selectedClass
        self.content = content
    }
}

protocol ActivityCell: View {
    typealias OnSelect = (_ actClass: ActivityClass) -> ()
    var onSelect: OnSelect { get set }
}

#Preview {
    
    @Previewable @State var actClass: ActivityClass? = ActivityClass.dummyActivity()
    
    var container = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        toReturn.mainContext.insert(actClass!)
        return toReturn
    }()
    
    ActivityClassList(selectedClass: $actClass){ actClass in
        ActivityClassSmallCellView(
            activityClass: actClass,
            onSelect: {_ in print("other")})
    }
    .modelContainer(container)
}

