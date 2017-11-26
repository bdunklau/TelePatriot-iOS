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
class MenuItems : AccountStatusEventListener {
    
    var myMission = MenuItem(title: "My Mission")
    var directors = MenuItem(title: "Directors")
    var admins = MenuItem(title: "Admins")
    var mainSection0 : [MenuItem]
    var mainMenu : [[MenuItem]]
    var directorItems : [[MenuItem]]
    
    static let sharedInstance = MenuItems()
    
    private init() {
        mainSection0 = [myMission, directors, admins]
        mainMenu = [mainSection0,
                    [MenuItem(title: "Share Petition"),
                     MenuItem(title: "Chat/Help") ],
                    [MenuItem(title: "Sign Out")]
                ]
        directorItems = [
                 [
                    MenuItem(title: "New Phone Campaign"),
                    MenuItem(title: "My Active Missions"),
                    MenuItem(title: "All My Missions"),
                    MenuItem(title: "All Active Missions"),
                    MenuItem(title: "All Missions"),
                    MenuItem(title: "All Activity")
                 ]
            ]
        
        listenForAccountStatusEvents()
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
    
    
    
    func listenForAccountStatusEvents() {
        if(TPUser.sharedInstance.accountStatusEventListeners.count == 0
            || !TPUser.sharedInstance.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == "MenuItems" })) {
            TPUser.sharedInstance.accountStatusEventListeners.append(self)
        }
    }
    
    // required by AccountStatusEventListener
    func roleAssigned(role: String) {
        if( role == "Volunteer" ) {
            doRoleAdded(role: role, menuText: "My Mission", index: 0, items: mainSection0)
        }
        if( role == "Director" ) {
            doRoleAdded(role: role, menuText: "Directors", index: 1, items: mainSection0)
        }
        if( role == "Admin" ) {
            doRoleAdded(role: role, menuText: "Admins", index: 2, items: mainSection0)
        }
    }
    
    // required by AccountStatusEventListener
    func roleRemoved(role: String) {
        if( role == "Volunteer" ) {
            doRoleRemoved(role: role, menuText: "My Mission", items: mainSection0)
        }
        if( role == "Director" ) {
            doRoleRemoved(role: role, menuText: "Directors", items: mainSection0)
        }
        if( role == "Admin" ) {
            doRoleRemoved(role: role, menuText: "Admins", items: mainSection0)
        }
    }
    
    private func doRoleAdded(role: String, menuText: String, index: Int, items: Array<MenuItem>) {
        let itemText = menuText
        var alreadyGranted = false
        let loop = items
        for mi in loop {
            if(mi.title == itemText) {
                alreadyGranted = true
            }
        }
        if(!alreadyGranted) {
            let volItem = MenuItem(title: itemText)
            //mainMenu[0].insert(volItem, at: index)
            mainMenu[0][index].title = menuText
        }
        
    }
    
    private func doRoleRemoved(role: String, menuText: String, items: Array<MenuItem>) {
        var i = 0
        var found = -1
        for mi in items {
            if(mi.title == menuText) {
                found = i
                break
            }
            i = i + 1
        }
        //mainMenu[0].remove(at: found)
        mainMenu[0][found].title = ""
    }
}
