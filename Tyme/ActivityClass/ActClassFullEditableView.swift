//
//  ActClassFullEditableView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/19/24.
//

import SwiftUI

struct ActClassFullEditableView: View {
    let actClass: ActivityClass
    @State var editManager: ActivityClass.UIEditsManager
    
    init(actClass: ActivityClass) {
        self.actClass = actClass
        editManager = ActivityClass.UIEditsManager(for: actClass)
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $editManager.name)
                .multilineTextAlignment(.center)
            TextEditor(text: $editManager.detail)
            EditableTimer(time: $editManager.waitAfterStart)
            HStack{
                Text("Next: \(actClass.next?.name ?? "nil")")
            }
        }
    }
}

#Preview {
    let sample = {
        let toReturn = ActivityClass.dummyActivity()
        toReturn.next = ActivityClass.dummyActivity()
        return toReturn
    }()
    
    ActClassFullEditableView(actClass: sample)
}
