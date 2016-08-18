//
//  Extension.swift
//  PartyMenu
//
//  Created by Михаил on 18.08.16.
//  Copyright © 2016 empatika. All rights reserved.
//

import Foundation

extension String {
    var unicodeDeparse: String {
        let transform = "Any-Hex/Java"
        let input = self
        
        let convertedString = input.mutableCopy() as! NSMutableString
        
        CFStringTransform(convertedString, nil, transform as NSString, true)
        return convertedString as String
    }
}