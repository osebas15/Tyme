//
//  EditableTimer.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/19/24.
//

import SwiftUI

struct EditableTimer: View {
    let textFieldWidth: CGFloat = 25
    
    @Binding var time: TimeInterval
    @State var inEditMode: Bool = false
    
    var body: some View {
        if inEditMode{
            HStack{
                TextField("days", value: $time.dhmsBindableComponents.days, format: .number)
                    .frame(maxWidth: textFieldWidth)
                Text("days, ")
                TextField("hours", value: $time.dhmsBindableComponents.hours, format: .number)
                    .frame(maxWidth: textFieldWidth)
                Text(":")
                TextField("minutes", value: $time.dhmsBindableComponents.minutes, format: .number)
                    .frame(maxWidth: textFieldWidth)
                Text(":")
                TextField("seconds", value: $time.dhmsBindableComponents.seconds, format: .number)
                    .frame(maxWidth: textFieldWidth)
                Button("done"){
                    inEditMode.toggle()
                }
            }
        }
        else {
            Text($time.dhmsBindableComponents.timerFormattedString)
                .onTapGesture {
                    inEditMode.toggle()
                }
        }
    }
}

#Preview {
    @Previewable @State var time: TimeInterval = 100000
    
    return VStack{
        Text("\(time.description) seconds")
        HStack{
            EditableTimer(time: $time)
        }
    }
}

extension Binding<TimeInterval> {
    struct DHMSBindableComponents {
        @Binding var time: TimeInterval
        
        var seconds: Binding<Int> {
            Binding<Int>(
                get: { return Int(time) % 60 },
                set: { newValue in
                    let change = newValue - (Int(time) % 60)
                    time += Double(change)
                })
        }
        
        var minutes: Binding<Int> {
            Binding<Int>(
                get: { return (Int(time) % (60 * 60)) / 60 },
                set: { newValue in
                    let change = newValue - ((Int(time) % (60 * 60)) / 60)
                    time += Double(change * 60)
                })
        }
        
        var hours: Binding<Int> {
            Binding<Int>(
                get: { return (Int(time) % (60 * 60 * 24)) / (60 * 60) },
                set: { newValue in
                    let change = newValue - ((Int(time) % (60 * 60 * 24)) / (60 * 60))
                    time += Double(change * 60 * 60)
                })
        }
        
        var days: Binding<Int> {
            Binding<Int>(
                get: { return Int(time) / (60 * 60 * 24) },
                set: { newValue in
                    let change = newValue - (Int(time) / (60 * 60 * 24))
                    time += Double(change * 60 * 60 * 24)
                }
            )
        }
        
        var timerFormattedString: String {
            var toReturn = "\(seconds.wrappedValue)"
            
            if time > 60 {
                toReturn = "\(minutes.wrappedValue < 10 ? "0" : "")\(minutes.wrappedValue):\(toReturn)"
            }
            if time > (60 * 60) {
                toReturn = "\(hours.wrappedValue):\(toReturn)"
            }
            if time > (60 * 60 * 24){
                toReturn = "\(days.wrappedValue) days, \(toReturn)"
            }
            
            return toReturn
        }
    }
    
    var dhmsBindableComponents: DHMSBindableComponents {
        DHMSBindableComponents(time: self)
    }
}
