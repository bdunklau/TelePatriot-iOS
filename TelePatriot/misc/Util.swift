//
//  Util.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/23/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation

class Util {
    
    static func getDate_as_millis() -> Int64 {
        let date : Date = Date()
        return Int64((date.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    static func getDate_Day_MMM_d_hmmss_am_z_yyyy() -> String {
        return getDate(withFormat: "EEE MMM d, h:mm:ss a z yyyy")
    }
    
    
    static func getDate_MMM_d_yyyy_hmm_am_z() -> String {
        return getDate(withFormat: "MMM d, yyyy h:mm a z") // i.e.  Jan 13, 2018 2:15 pm CST
    }
    
    
    private static func getDate(withFormat: String) -> String {
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        return dateFormatter.string(from: date)
    }
}
