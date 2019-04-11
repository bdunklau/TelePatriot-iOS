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
    static let videoChatIcon : UIImageView = {
        let img = UIImage(named: "ic_video_library_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let videoOffersIcon : UIImageView = {
        let img = UIImage(named: "ic_video_library_18pt.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    // icons came from material.io/icons
    static let videoInvitationsIcon : UIImageView = {
        let img = UIImage(named: "ic_video_library_18pt.png")
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
    static let videoChat = MenuItem(icon: MenuItems.videoChatIcon, title: "Video Chat")
    static let videoOffers = MenuItem(icon: MenuItems.videoOffersIcon, title: "Video Offers")
    var mainSection0 : [MenuItem]
    var mainMenu : [[MenuItem]]
    var directorItems : [[MenuItem]]
    
    static let sharedInstance = MenuItems()
    
    private init() {
        
        // See SidePanelViewController - doRoleAdded() and doRoleRemoved()
        mainSection0 = [MenuItems.team
                        ,MenuItems.myMission
            
                          // TODO will want to put these back in at some point (Dec 2018)
                        ,MenuItems.directors // uncomment to make these start showing up again.  See the comments below also at getItem()
                        ,MenuItems.admins     // this will be later on though, once CB integration is complete and we want to restore this functionality
                        ]
        
        
        // See also the end of SidePanelViewController.viewDidLoad() - that method removes all menu items.
        // Then they are added back according to the roleAdded events
        mainMenu = [mainSection0,
                    
                    // Communicate section - ICONS AREN'T RIGHT - FIX LATER
                    [MenuItem(icon: MenuItems.videoChatIcon, title: "Video Chat"),
                     MenuItem(icon: MenuItems.videoOffersIcon, title: "Video Offers"),
                     MenuItem(icon: MenuItems.videoInvitationsIcon, title: "Video Invitations")
                    /*MenuItem(icon: MenuItems.allActivityIcon, title: "Share Petition (coming soon)"),
                     MenuItem(icon: MenuItems.allActivityIcon, title: "Chat/Help (coming soon)")*/ ],
            
                    // My Account section
                    [//MenuItem(icon: MenuItems.myProfileIcon, title: "My Profile"),
                     //MenuItem(icon: MenuItems.myLegislatorsIcon, title: "My Legislators"), put this back in once it's working better
                            // This screen is messed up and it never handled districts that had more than one rep - NJ, NH, MA
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
    
    // See also the end of SidePanelViewController.viewDidLoad() - that method removes all menu items.
    // Then they are added back according to the roleAdded events
    static func getItem(withText: String) -> MenuItem? {
        let roleItems : [String: MenuItem] = {
            var items = [String: MenuItem]()
            items["My Mission"] = myMission
            
            // TODO will want to put these back in at some point (Dec 2018)
            items["Directors"] = directors  // uncomment these 2 items and the 2 items at mainSection0 above
            items["Admins"] = admins        // When you do, the Admins and Directors menu items will appear again
            items["Video Chat"] = videoChat    // They have been taken out for the first phase of CB integration because all the
            items["Video Offers"] = videoOffers    // functionality for these 2 roles is being absorbed into CB.  There won't be anything
            return items                            // for Directors and Admins to do from the phone in the short term anyway
        }()
        
        return roleItems[withText]
    }
    
}
