//
//  Util.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/23/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

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
    
    
    static func getDate_yyyy_MM_dd() -> String {
        return getDate(withFormat: "yyyy-MM-dd") // i.e.  2018-04-09
    }
    
    
    private static func getDate(withFormat: String) -> String {
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        return dateFormatter.string(from: date)
    }
    
    
    static func openFacebook(legislator: Legislator?) {
        let fbInstalled = schemeAvailable(scheme: "fb://")
        if fbInstalled {
            if let fbHandle = legislator?.legislator_facebook_id {
                open(scheme: "fb://profile/\(fbHandle)")
            }
        }
        else {
            if let fbHandle = legislator?.legislator_facebook_id {
                open(scheme: "https://www.facebook.com/\(fbHandle)")
            }
        }
    }
    
    
    static func openTwitter(legislator: Legislator?) {
        let twInstalled = schemeAvailable(scheme: "twitter://")
        if twInstalled {
            if let twHandle = legislator?.legislator_twitter {
                open(scheme: "twitter://user?screen_name=\(twHandle)")
            }
        }
        else {
            if let twHandle = legislator?.legislator_twitter {
                open(scheme: "https://www.twitter.com/\(twHandle)")
            }
        }
    }
    
    private static func schemeAvailable(scheme: String) -> Bool {
        if let url = URL(string: scheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    private static func open(scheme: String) {
        if let url = URL(string: scheme) {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Open \(scheme): \(success)")
            })
        }
    }
}
