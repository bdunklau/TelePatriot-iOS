//
//  MenuItem.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/22/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

struct MenuItem {
    
    var title: String
    var icon: UIImageView
    
    init(icon: UIImageView, title: String) {
        self.icon = icon
        self.title = title
    }
    
    static func rightSections() -> [String] {
        return [""]
    }
    
    static func rightItems() -> Array<Array<MenuItem>> {
        let section1 : Array<MenuItem> = [ ]
        
        return [section1]
    }
}
