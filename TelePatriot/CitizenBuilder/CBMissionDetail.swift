//
//  CBMissionDetail.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/4/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation

// analog to CBMissionDetail on the Android side
struct CBMissionDetail : Decodable {
    
    var mission_id : Int32?
    var description : String? = ""
    var script : String? = ""
    var priority : Int32 = -1
    var status = ""
    var name = ""  // the mission name
    var first_name : String? = ""
    var last_name : String? = ""
    var phone : String? = ""
    var name2 : String? = ""
    var phone2 : String? = ""
    var person_id : Int32? = -1
    var info : String? = ""
    var total : Int32 = 0
    var calls_made : Int32 = 0
    var percent_complete : Int32 = 0
    
    var citizen_builder_domain : String? = ""
    var citizen_builder_api_key_name : String? = ""
    var citizen_builder_api_key_value : String? = ""
    
    init(data: [String:Any]) {
        
        if let val = data["mission_id"] as? Int32 {
            mission_id = val
        }
        if let val = data["description"] as? String {
            description = val
        }
        if let val = data["script"] as? String {
            script = val
        }
        if let val = data["priority"] as? Int32 {
            priority = val
        }
        if let val = data["status"] as? String {
            status = val
        }
        if let val = data["name"] as? String {
            name = val
        }
        if let val = data["phone"] as? String {
            phone = val
        }
        if let val = data["name2"] as? String {
            name2 = val
        }
        if let val = data["phone2"] as? String {
            phone2 = val
        }
        if let val = data["person_id"] as? Int32 {
            person_id = val
        }
        if let val = data["total"] as? Int32 {
            total = val
        }
        if let val = data["calls_made"] as? Int32 {
            calls_made = val
        }
        if let val = data["percent_complete"] as? Int32 {
            percent_complete = val
        }
//        if let val = data["citizen_builder_domain"] as? String {
//            citizen_builder_domain = val
//        }
//        if let val = data["citizen_builder_api_key_name"] as? String {
//            citizen_builder_api_key_name = val
//        }
//        if let val = data["citizen_builder_api_key_value"] as? String {
//            citizen_builder_api_key_value = val
//        }
        
    }
    
}
