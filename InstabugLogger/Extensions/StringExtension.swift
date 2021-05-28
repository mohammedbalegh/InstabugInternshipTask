//
//  StringExtension.swift
//  InstabugLogger
//
//  Created by mohammed balegh on 28/05/2021.
//

import Foundation

extension String {
    func toLessThan1000Chars() -> String {
        if self.count > 1000 {
           return self.prefix(1000) + "..."
        }
        return self
    }
}
