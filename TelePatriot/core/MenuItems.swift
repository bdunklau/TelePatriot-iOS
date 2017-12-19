//
//  MenuItems.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/24/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

// instance class so we can listen for AccountStatusEvent's
// The static methods in MenuItem made it so we couldn't listen for these events
class MenuItems {
    
    var team = MenuItem(title: "Team: (tap to choose)")
    var myMission = MenuItem(title: "My Mission")
    var directors = MenuItem(title: "Directors")
    var admins = MenuItem(title: "Admins")
    var mainSection0 : [MenuItem]
    var mainMenu : [[MenuItem]]
    var directorItems : [[MenuItem]]
    
    static let sharedInstance = MenuItems()
    
    private init() {
        
        mainSection0 = [team, myMission, directors, admins]
        mainMenu = [mainSection0,
                    [MenuItem(title: "Share Petition (coming soon)"),
                     /*MenuItem(title: "Chat/Help (coming soon)")*/ ],
                    [MenuItem(title: "Sign Out")]
                ]
        directorItems = [
                 [
                    MenuItem(title: "New Phone Campaign"),
                    //MenuItem(title: "My Active Missions (coming soon)"),
                    //MenuItem(title: "All My Missions (coming soon)"),
                    //MenuItem(title: "All Active Missions (coming soon)"),
                    MenuItem(title: "All Missions"),
                    MenuItem(title: "All Activity")
                 ]
            ]
        
    }
    
    var mainSections : [String] = ["Act", "Communicate", "My Account"]
    
    /*********
    var mainMenu : Array<Array<MenuItem>> = {
        var section1 = mainSection0
        
        var section2 = [MenuItem(title: "Share Petition"),
            MenuItem(title: "Chat/Help") ]
        
        var section3 = [
            MenuItem(title: "Sign Out")
        ]
        return [section1, section2, section3]
    }()
    
    
    var directorItems : Array<Array<MenuItem>> = {
        var section1 = [
            MenuItem(title: "New Phone Campaign"),
            MenuItem(title: "My Active Missions"),
            MenuItem(title: "All My Missions"),
            MenuItem(title: "All Active Missions"),
            MenuItem(title: "All Missions"),
            MenuItem(title: "All Activity")
        ]
        
        return [section1]
    }()
     ********/
    
    
}
