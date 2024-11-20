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
    @State var test: String = "other"
    
    init(actClass: ActivityClass) {
        self.actClass = actClass
        editManager = ActivityClass.UIEditsManager(for: actClass)
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $editManager.name)
            TextEditor(text: $editManager.detail)
        }
    }
}

#Preview {
    let sample = ActivityClass.dummyActivity()
    
    ActClassFullEditableView(actClass: sample)
}
