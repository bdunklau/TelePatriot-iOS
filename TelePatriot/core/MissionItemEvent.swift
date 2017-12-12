//
//  MissionItemEvent.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/12/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import Foundation

class MissionItemEvent {
    
    var event_date: String, event_type: String, volunteer_uid: String, volunteer_name: String, mission_name: String
    var phone: String, volunteer_phone: String, supporter_name: String
    
    init(event_type: String, volunteer_uid: String, volunteer_name: String, mission_name: String, phone: String, volunteer_phone: String, supporter_name: String, event_date: String) {
        
        self.event_type = event_type
        self.volunteer_uid = volunteer_uid
        self.volunteer_name = volunteer_name
        self.mission_name = mission_name
        self.phone = phone
        self.volunteer_phone = volunteer_phone
        self.supporter_name = supporter_name
        self.event_date = event_date
        
    }
    
    func dictionary() -> [String: String] {
        return [
            "event_type": event_type,
            "volunteer_uid": volunteer_uid,
            "volunteer_name": volunteer_name,
            "mission_name": mission_name,
            "phone": phone,
            "volunteer_phone": volunteer_phone,
            "supporter_name": supporter_name,
            "event_date": event_date
        ]
    }
    
}
