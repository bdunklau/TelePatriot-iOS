//
//  VideoParticipant.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 4/4/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation

struct VideoParticipant {
    
    var uid : String
    var name : String
    var email : String
    var phone : String?
    var start_date : String   // first the person starts
    var start_date_ms : Int64
    var connect_date : String? // then they connect
    var connect_date_ms : Int64?   // while they're connected, the recording can start, but those timestamps are captured in VideoNode
    var disconnect_date : String? // then they disconnect from the Vidyo server
    var disconnect_date_ms : Int64?
    var end_date : String?   // finally the person ends his video session
    var end_date_ms : Int64?
    var role : String? //(interviewer, interviewee, other?)
    
    // this custom init method makes it so that...
    //  - we can pass in a TPUser object
    //  - we don't have to set a value for every field (phone, role)
    init(user: TPUser) {
        uid = user.getUid()
        name = user.getName()
        email = user.getEmail()
        // not init-ing with phone
        start_date = Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
        start_date_ms = Util.getDate_as_millis()
        // not init-ing with role
    }
    
    
    func dictionary() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "email": email,
            "phone": phone,
            "start_date": start_date,
            "start_date_ms": start_date_ms,
            "connect_date": connect_date,
            "connect_date_ms": connect_date_ms,
            "disconnect_date": disconnect_date,
            "disconnect_date_ms": disconnect_date_ms,
            "end_date": end_date,
            "end_date_ms": end_date_ms,
            "role": role
        ]
    }
}
