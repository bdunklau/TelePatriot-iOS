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
    //let image: UIImage?
    
    init(title: String) { //}, image: UIImage?) {
        self.title = title
        //self.image = image
    }
    
    /**********
    static func directorItems() -> Array<Array<MenuItem>> {
        let section1 = [
            MenuItem(title: "New Phone Campaign"),
            MenuItem(title: "My Active Missions"),
            MenuItem(title: "All My Missions"),
            MenuItem(title: "All Active Missions"),
            MenuItem(title: "All Missions"),
            MenuItem(title: "All Activity")
        ]
        
        return [section1]
    }
 *******/
    
    /********
    static func leftSections() -> [String] {
        return ["Act", "Communicate", "My Account"]
    }
 ******/
    
    static func rightSections() -> [String] {
        return [""]
    }
    
    /********
    static func leftItems() -> Array<Array<MenuItem>> {
        let section1 = [
            MenuItem(title: "My Mission"),
            MenuItem(title: "Directors"),
            MenuItem(title: "Admins")
        ]
        
        let section2 = [
            MenuItem(title: "Share Petition"),
            MenuItem(title: "Chat/Help")
        ]
        
        let section3 = [
            MenuItem(title: "Sign Out")
        ]
        return [section1, section2, section3]
    }
 ********/
    
    static func rightItems() -> Array<Array<MenuItem>> {
        let section1 = [
            MenuItem(title: "stuff here"),
            MenuItem(title: "more stuff")
        ]
        
        return [section1]
    }
}
