//
//  Date.swift
//  Twitter
//
//  Created by Ngan, Naomi on 9/29/17.
//  Copyright © 2017 Ngan, Naomi. All rights reserved.
//

import Foundation

extension Date {
    static let formatterIn: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z y" // Ex. "Tue Aug 28 21:16:23 +0000 2012"
        return formatter
    }()
    
    static let formatterOut: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd/yy hh:mm a" // Ex. "8/28/17 09:16 PM"
        return formatter
    }()
    
    init(dateString:String) {
        self = Date.formatterIn.date(from: dateString)!
    }
    
    func toString() -> String {
        return Date.formatterOut.string(from: self)
    }
}

