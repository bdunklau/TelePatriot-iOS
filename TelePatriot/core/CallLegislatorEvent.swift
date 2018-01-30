//
//  CallLegislatorEvent.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/23/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation

class CallLegislatorEvent : MissionItemEvent {
    
    var legislator_name : String
    var legislator_state_abbrev : String
    var legislator_chamber : String
    var legislator_district : String
    
    init(event_type: String, volunteer_uid: String, volunteer_name: String, mission_name: String, phone: String, volunteer_phone: String,
         legislator_name: String,
         legislator_state_abbrev: String,
         legislator_chamber: String,
         legislator_district: String,
         event_date: String) {
        
        self.legislator_name = legislator_name
        self.legislator_state_abbrev = legislator_state_abbrev
        self.legislator_chamber = legislator_chamber
        self.legislator_district = legislator_district
        
        super.init(event_type: event_type, volunteer_uid: volunteer_uid, volunteer_name: volunteer_name,
                   mission_name: mission_name, phone: phone, volunteer_phone: volunteer_phone, supporter_name: "", event_date: event_date)
        
        
    }
    
    override func dictionary() -> [String: String] {
        return [
            "event_type": event_type,
            "volunteer_uid": volunteer_uid,
            "volunteer_name": volunteer_name,
            "mission_name": mission_name,
            "phone": phone,
            "volunteer_phone": volunteer_phone,
            "legislator_name": legislator_name,
            "legislator_state_abbrev": legislator_state_abbrev,
            "legislator_chamber": legislator_chamber,
            "legislator_district": legislator_district,
            "event_date": event_date
        ]
    }
}
