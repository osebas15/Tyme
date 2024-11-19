//
//  ActObjStatusCircleView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/19/24.
//

import SwiftUI

struct ActObjStatusCircleView: View {
    let obj: ActivityObject
    var body: some View {
        if obj.focus == .done {
            Image(systemName: "circle.fill")
                .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.2))
        }
        else if obj.focus == .passive {
            Image(systemName: "circle.fill")
                .foregroundColor(.yellow)
        }
        else {
            Image(systemName: "circle")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    {
        var sample = ActivityObject.dummyObject()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
            sample.focus = .passive
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
                sample.focus = .done
            }
        }
        
        return ActObjStatusCircleView(obj: sample)
    }()
}
