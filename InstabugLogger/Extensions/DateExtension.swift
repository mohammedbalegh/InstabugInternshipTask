//
//  DateExtension.swift
//  InstabugLogger
//
//  Created by mohammed balegh on 27/05/2021.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-MM-dd hh:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
