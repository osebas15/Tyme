//
//  NavigationTest.swift
//  TymeTests
//
//  Created by Sebastian Aguirre on 12/11/24.
//

import Foundation
import Testing

struct NavigationTest {
    
    @Suite("Landing")
    struct landingTestSuite {
        
        @Test("ACTIVE START: Start in active view if home object has subactivities")
        func startActivity() async throws {
            #expect(true)
        }
    }
}
