//
//  MissionItem.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/1/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import Foundation

class MissionItem {
    /**
    These are the attributes in /mission_items...
     
     mission_item_id
         accomplished
         active
         active_and_accomplished
         description
         email
         mission_create_date
         mission_id
         mission_name
         mission_type
         name
         phone
         script
         uid
         uid_and_active
         url
    **/
    var mission_item_id : String
    var phone : String
    var name : String
    var uid : String
    
    init(mission_item_id: String, phone: String, name: String, uid: String) {
        self.mission_item_id = mission_item_id
        self.phone = phone
        self.name = name
        self.uid = uid
    }
}
