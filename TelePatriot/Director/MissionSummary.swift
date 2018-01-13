//
//  MissionSummary.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import Firebase

// In Android, the class is just called Mission
class MissionSummary : NSObject {
    var mission_id : String?
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
    
    var total_rows_in_spreadsheet : Int?
    var total_rows_in_spreadsheet_with_phone : Int?
    var total_rows_activated : Int?
    var total_rows_deactivated : Int?
    var total_rows_completed : Int?
    var percent_complete : Int?
    
    
    func updateWith(mission: MissionSummary) {
        self.active = mission.active
        self.descrip = mission.descrip
        self.mission_create_date = mission.mission_create_date
        self.mission_name = mission.mission_name
        self.name = mission.name
        self.script = mission.script
        self.uid = mission.uid
        self.uid_and_active = mission.uid_and_active
        self.url = mission.url
        self.mission_type = mission.mission_type
        
        self.total_rows_in_spreadsheet = mission.total_rows_in_spreadsheet
        self.total_rows_in_spreadsheet_with_phone = mission.total_rows_in_spreadsheet_with_phone
        self.total_rows_activated = mission.total_rows_activated
        self.total_rows_deactivated = mission.total_rows_deactivated
        self.total_rows_completed = mission.total_rows_completed
        self.percent_complete = mission.percent_complete
    }
}
