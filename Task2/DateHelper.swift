//
//  DateHelper.swift
//  Task2
//
//  Created by Nicholas Laughter on 5/19/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation

extension NSDate {
    
    func stringValue() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(self)
    }
}