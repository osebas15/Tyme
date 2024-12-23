//
//  ArrayUtils.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 12/23/24.
//

import Foundation

extension Array where Element: Hashable{
    func duplicatesRemoved() -> Array{
        var tracker = Set<Element>()
        var toReturn = Array<Element>()
        
        self.forEach { el in
            if !tracker.contains(el){
                tracker.insert(el)
                toReturn.insert(el, at: toReturn.count)
            }
        }
        
        return toReturn
    }
}

