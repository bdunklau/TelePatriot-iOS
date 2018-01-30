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
     These are the attributes in /teams/{team}/mission_items...
     
     mission_item_id
         accomplished
         active
         active_and_accomplished
         description
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
    var accomplished : String
    var active : Bool
    var active_and_accomplished : String
    var description : String
    //var email : String
    var mission_create_date : String
    var mission_id : String
    var mission_name : String
    var mission_type : String
    var name : String
    var phone : String
    var script : String
    var uid : String
    var uid_and_active : String
    var url : String
    var group_number : Int
    var group_number_was : Int?
    var number_of_missions_in_master_mission : Int
    
    // set in AppDelegate
    static var nextViewController : UIViewController?
    
    
    init(mission_item_id : String,
         accomplished : String,
         active : Bool,
         active_and_accomplished : String,
         description : String,
         //email : String,
         mission_create_date : String,
         mission_id : String,
         mission_name : String,
         mission_type : String,
         name : String,
         phone : String,
         script : String,
         uid : String,
         uid_and_active : String,
         url : String,
         group_number : Int,
         number_of_missions_in_master_mission : Int) {
        
        self.mission_item_id = mission_item_id
        self.accomplished = accomplished
        self.active = active
        self.active_and_accomplished = active_and_accomplished
        self.description = description
        //self.email = email
        self.mission_create_date = mission_create_date
        self.mission_id = mission_id
        self.mission_name = mission_name
        self.mission_type = mission_type
        self.name = name
        self.phone = phone
        self.script = script
        self.uid = uid
        self.uid_and_active = uid_and_active
        self.url = url
        self.group_number = group_number
        self.number_of_missions_in_master_mission = number_of_missions_in_master_mission
    }
    
    
}
