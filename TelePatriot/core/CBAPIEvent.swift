//
//  File.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 8/29/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

/**
 This class was first created so people could check on their own "legal" status, meaning
 verify with CB that they had signed the petition and the confidentiality agreement.
 **/
class CBAPIEvent {
    
    // don't need to know the key yet
    var uid : String
    var email : String
    var name : String
    var event_type : String
    // no need for date on the client side, let the server side handle that with a trigger - less code on the client

    init(uid: String, name: String, email: String, event_type: String) {
        self.uid = uid
        self.email = email
        self.name = name
        self.event_type = event_type
    }

    func save() {
        Database.database().reference().child("cb_api_events/all-events").childByAutoId().setValue(dictionary())
    }

    private func dictionary() -> [String:Any] {
        return [
            "uid": uid,
            "name": name,
            "email": email,
            "event_type": event_type
        ]
    }
}
