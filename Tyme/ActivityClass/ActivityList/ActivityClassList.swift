//
//  ActivityClassList.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/22/24.
//

import SwiftUI
import SwiftData

struct ActivityClassList<Content: View>: View {
    //@Query(filter: ModelHelper().homeActivityPredicate) var homeClassResult: [ActivityClass]
    var classesToShow: [ActivityClass]
    @ViewBuilder var content: (ActivityClass) -> Content
    
    var body: some View {
        VStack{
            /*if classesToShow.isEmpty, let homeClasses = homeClassResult.first?.orderedSubActivities {
                List(homeClasses){ actClass in
                    content(actClass)
                }
            }
            else {*/
                List(classesToShow) { actClass in
                    content(actClass)
                        /*.onTapGesture {
                            print("pati")
                        }*/
                }
            //}
        }
    }
}

#Preview {
    
    @Previewable @State var actClass: ActivityClass? = ActivityClass.dummyActivity()
    
    var container = {
        let toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        toReturn.mainContext.insert(actClass!)
        return toReturn
    }()
    
    ActivityClassList(classesToShow: [actClass!]){ actClass in
        Text(actClass.name)
            .onTapGesture {
                print(actClass.name)
            }
    }
    .modelContainer(container)
}

