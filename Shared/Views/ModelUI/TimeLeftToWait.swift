//
//  TimeLeftToWait.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 12/28/24.
//

import SwiftUI

struct TimeLeftToWait: View {
    var totalTime: TimeInterval
    var expectedTime: TimeInterval?
    
    private var formattedTotalTime: String {
        return formatTimeInterval(totalTime)
    }
    
    private var formattedExpectedTime: String? {
        guard let expTime = expectedTime else {
            return nil
        }
        return formatTimeInterval(expTime)
    }
    
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.second]
        if interval >= 60 {
            formatter.allowedUnits.insert(.minute)
        }
        if interval >= 60 * 60 {
            formatter.allowedUnits.insert(.hour)
        }
        
        formatter.unitsStyle = .abbreviated // Use abbreviated units (e.g., "hr", "min", "sec")
        formatter.zeroFormattingBehavior = .pad // Pad with zeros (e.g., "01" instead of "1")
        
        return formatter.string(from: interval) ?? "0 sec" // Return "0 sec" if formatting fails
    }
    
    private func backgroundColor() -> Color {
        guard let expectedTime = expectedTime else {
            return .gray
        }
        if totalTime < (expectedTime * 0.25){
            return .green
        }
        else if totalTime < (expectedTime * 0.75){
            return .mint
        }
        else if totalTime < (expectedTime * 0.9){
            return .blue
        }
        else if totalTime < expectedTime {
            return .indigo
        }
        else {
            return .purple
        }
    }
    
    var body: some View {
        HStack { // Use an HStack for better layout
            Text("\(formattedTotalTime)")
            if let expectedTime = formattedExpectedTime {
                Text("/")
                Text("\(expectedTime)")
            }
            
        }
        .foregroundColor(.white)
        .padding(.horizontal, 30)
        .padding(.vertical, 10)
        .background(backgroundColor())
        .cornerRadius(20)
    }
}

#Preview {
    VStack{
        TimeLeftToWait(totalTime: 2 * 60)
        TimeLeftToWait(totalTime: 45, expectedTime: (10 * 60))
        TimeLeftToWait(totalTime: (5 * 60), expectedTime: (10 * 60))
        TimeLeftToWait(totalTime: (8 * 60), expectedTime: (10 * 60))
        TimeLeftToWait(totalTime: (9 * 60), expectedTime: (10 * 60))
        TimeLeftToWait(totalTime: (11 * 60), expectedTime: (10 * 60))
    }
}
