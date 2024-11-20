//
//  ActClassSearchView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/19/24.
//

import SwiftUI
import SwiftData

struct ActClassSearchView: View {
    @Environment(\.modelContext) var context
    
    @Query var actClasses: [ActivityClass]
    
    @Binding var selectedClass: ActivityClass?
    
    @State var searchText: String = ""
    
    init(selectedClass: Binding<ActivityClass?>){
        _actClasses = Query(
            filter: #Predicate<ActivityClass>{ _ in true },
            sort: \ActivityClass.name
        )
        
        _selectedClass = selectedClass
        
        searchText = selectedClass.wrappedValue?.name ?? ""
    }
    
    var body: some View {
        ZStack{
            if let selectedClass = selectedClass, searchText == "" {
                HStack{
                    Text(selectedClass.name)
                        .foregroundStyle(.gray)
                    Spacer()
                }
            }
            TextField("", text: $searchText)
        }
        ForEach(orderedClasses(compareText: searchText, classes: actClasses)){ actClass in
            Text(actClass.name)
                .onTapGesture {
                    selectedClass = actClass
                }
        }
    }
    
    func orderedClasses(compareText: String, classes: [ActivityClass]) -> [ActivityClass]{
        return classes.sorted(by: { searchOrdering(
            left: $0.name.lowercased(),
            right: $1.name.lowercased(),
            searchText: (searchText == "" ? (selectedClass?.name ?? searchText) : searchText).lowercased()
        )})
    }
}

extension ActClassSearchView {
    func searchOrdering(left: String, right: String, searchText: String) -> Bool {
        if left.contains(searchText) != right.contains(searchText) {
            return left.contains(searchText)
        }
        else {
            return levDis(left, searchText) < levDis(right, searchText)
        }
    }
    
    func levDis(_ w1: String, _ w2: String) -> Int {
        let empty = [Int](repeating:0, count: w2.count)
        var last = [Int](0...w2.count)

        for (i, char1) in w1.enumerated() {
            var cur = [i + 1] + empty
            for (j, char2) in w2.enumerated() {
                cur[j + 1] = char1 == char2 ? last[j] : min(last[j], last[j + 1], cur[j]) + 1
            }
            last = cur
        }
        return last.last!
    }
}

#Preview {
    @Previewable @State var dummyActivity : ActivityClass? = ActivityClass.dummyActivity()
    
    let container: ModelContainer = {
        var toReturn = ModelHelper().getBasicContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        toReturn.mainContext.insert(dummyActivity!)
        //try? toReturn.mainContext.save()
        return toReturn
    }()
    
    
    
    ActClassSearchView(
        selectedClass: $dummyActivity
    )
    .modelContainer(container)
}
