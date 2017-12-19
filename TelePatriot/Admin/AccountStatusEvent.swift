//
//  AccountStatusEvent.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/15/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class AccountStatusEvent {
    var thedate: String?
    var event: String?
    init(thedate: String, event: String) {
        self.thedate = thedate
        self.event = event
    }
}

protocol AccountStatusEventListener {
    func roleAssigned(role: String)
    
    func roleRemoved(role: String)
    
    func teamSelected(team: Team, whileLoggingIn: Bool)
}
