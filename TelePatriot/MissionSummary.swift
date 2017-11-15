//
//  MissionSummary.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import Firebase

class MissionSummary : NSObject {
    var active : Bool?
    var descrip : String?  // can't use description  AHHHHHHHHHH !
    var mission_create_date : String?
    var mission_name : String?
    var name : String?
    var script : String?
    var uid : String?
    var uid_and_active : String?
    var url : String?
    var mission_type : String?
    
    /*****
    init(snap: DataSnapshot) {
        self.name = snap.childSnapshot(forPath: "name").value as? String
    }
    *****/
}
