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
    
    // icons came from material.io/icons
    static let teamIcon : UIImageView = {
        let img = UIImage(named: "ic_people_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let myMissionIcon : UIImageView = {
        let img = UIImage(named: "ic_video_library_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let directorsIcon : UIImageView = {
        let img = UIImage(named: "ic_video_library_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let newPhoneCampaignIcon : UIImageView = {
        let img = UIImage(named: "ic_video_library_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let allMissionsIcon : UIImageView = {
        let img = UIImage(named: "ic_video_library_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let allActivityIcon : UIImageView = {
        let img = UIImage(named: "ic_video_library_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let adminsIcon : UIImageView = {
        let img = UIImage(named: "ic_video_library_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let myProfileIcon : UIImageView = {
        let img = UIImage(named: "ic_person_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let myLegislatorsIcon : UIImageView = {
        let img = UIImage(named: "ic_people_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let logoutIcon : UIImageView = {
        let img = UIImage(named: "ic_power_settings_new_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    static let team = MenuItem(icon: MenuItems.teamIcon, title: "Team: (tap to choose)")
    static let myMission = MenuItem(icon: MenuItems.myMissionIcon, title: "My Mission")
    static let directors = MenuItem(icon: MenuItems.directorsIcon, title: "Directors")
    static let admins = MenuItem(icon: MenuItems.adminsIcon, title: "Admins")
    var mainSection0 : [MenuItem]
    var mainMenu : [[MenuItem]]
    var directorItems : [[MenuItem]]
    
    static let sharedInstance = MenuItems()
    
    private init() {
        
        mainSection0 = [MenuItems.team,
                        MenuItems.myMission,
                        MenuItems.directors,
                        MenuItems.admins]
        
        mainMenu = [mainSection0,
                    
                    // Communicate section - ICONS AREN'T RIGHT - FIX LATER
                    [MenuItem(icon: MenuItems.allActivityIcon, title: "Video Chat")
                    /*MenuItem(icon: MenuItems.allActivityIcon, title: "Share Petition (coming soon)"),
                     MenuItem(icon: MenuItems.allActivityIcon, title: "Chat/Help (coming soon)")*/ ],
            
                    // My Account section
                    [MenuItem(icon: MenuItems.myProfileIcon, title: "My Profile"),
                     MenuItem(icon: MenuItems.myLegislatorsIcon, title: "My Legislators"),
                     MenuItem(icon: MenuItems.logoutIcon, title: "Sign Out")]
                ]
        directorItems = [
                 [
                    MenuItem(icon: MenuItems.newPhoneCampaignIcon, title: "New Phone Campaign"),
                    //MenuItem(title: "My Active Missions (coming soon)"),
                    //MenuItem(title: "All My Missions (coming soon)"),
                    //MenuItem(title: "All Active Missions (coming soon)"),
                    MenuItem(icon: MenuItems.allMissionsIcon, title: "All Missions"),
                    MenuItem(icon: MenuItems.allActivityIcon, title: "All Activity")
                 ]
            ]
        
    }
    
    var mainSections : [String] = ["Act", "Communicate", "My Account"]
    
    static func getItem(withText: String) -> MenuItem? {
        let roleItems : [String: MenuItem] = {
            var items = [String: MenuItem]()
            items["My Mission"] = myMission
            items["Directors"] = directors
            items["Admins"] = admins
            return items
        }()
        
        return roleItems[withText]
    }
    
}
