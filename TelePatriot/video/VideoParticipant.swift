//
//  VideoParticipant.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 4/4/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

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
    var present = true // indicates that the user is "present" on the video chat screen
//    var vidyo_token : String? // don't use this anymore
    var twilio_token : String?
    var twilio_token_record : String?
    
    
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
    
    
    // use then when working with database results
    init(data: [String:Any]) {
        if let userId = data["uid"] as? String {
            uid = userId
        }
        else { uid = "-" }
        
        if let nm = data["name"] as? String {
            name = nm
        }
        else { name = "-" }
        
        if let em = data["email"] as? String {
            email = em
        }
        else { email = "-" }
        
        if let ph = data["phone"] as? String {
            phone = ph
        }
        else { phone = "-" }
        
        if let sd = data["start_date"] as? String {
            start_date = sd
        }
        else { start_date = "-" }
        
        if let sdm = data["start_date_ms"] as? Int64 {
            start_date_ms = sdm
        }
        else { start_date_ms = 0 }
        
        if let cd = data["connect_date"] as? String {
            connect_date = cd
        }
        if let cdm = data["connect_date_ms"] as? Int64 {
            connect_date_ms = cdm
        }
        if let dd = data["disconnect_date"] as? String {
            disconnect_date = dd
        }
        if let ddm = data["disconnect_date_ms"] as? Int64 {
            disconnect_date_ms = ddm
        }
        if let ed = data["end_date"] as? String {
            end_date = ed
        }
        if let edm = data["end_date_ms"] as? Int64 {
            end_date_ms = edm
        }
        if let r = data["role"] as? String {
            role = r
        }
        if let p = data["present"] as? Bool {
            present = p
        }
        if let val = data["twilio_token"] as? String {
            twilio_token = val
        }
        if let val = data["twilio_token_record"] as? String {
            twilio_token_record = val
        }
    }
    
    
    static func parseParticipants(list: [String:[String:Any]]) -> [String: VideoParticipant] {
        var p = [String: VideoParticipant]()
        for item in list.values {
            let participant = VideoParticipant(data: item)
            let uid = participant.uid
            p[uid] = participant
        }
        return p
    }
    
    
    func dictionary() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "email": email,
            "phone": phone as Any,
            "start_date": start_date,
            "start_date_ms": start_date_ms,
            "connect_date": connect_date as Any,
            "connect_date_ms": connect_date_ms as Any,
            "disconnect_date": disconnect_date as Any,
            "disconnect_date_ms": disconnect_date_ms as Any,
            "end_date": end_date as Any,
            "end_date_ms": end_date_ms as Any,
            "role": role as Any,
            "present": present,
            "twilio_token": twilio_token as Any,
            "twilio_token_record": twilio_token_record as Any
        ]
    }
    
    // this function is really like "should we be connected"
    func isConnected() -> Bool {
        return connect_date != nil && (twilio_token != nil || twilio_token_record != nil) && disconnect_date == nil
    }
}
