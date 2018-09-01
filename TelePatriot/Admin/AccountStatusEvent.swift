//
//  AccountStatusEvent.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/15/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

/**
 Not sure that we need this class anymore (8/28/18)  See LimboViewController
 **/
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
    
    func userSignedOut()
    
    func allowed()
    
    func notAllowed()
    
    func accountEnabled()
    func accountDisabled()
}
