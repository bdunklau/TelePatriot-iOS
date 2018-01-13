//
//  BackTracker.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/12/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation

class BackTracker {
    //static let sharedInstance = BackTracker()
    
    var history = [UIViewController]()
    
    func onChoose(vc: UIViewController) {
        history.append(vc)
    }
    
    func onBack() -> UIViewController? {
        if history.count > 0 {
            let removed = history.remove(at: history.count-1)
            return removed
        }
        return nil
    }
    
    func last() -> UIViewController? {
        if history.count > 0 {
            let lst = history[history.count-1]
            return lst
        }
        return nil
    }
}
