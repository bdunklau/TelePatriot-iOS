//
//  Team.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/16/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import Foundation

class Team {
    
    // If you add attributes here, make sure they get added to dictionary() below also
    var team_name: String
    
    init(team_name: String) {
        self.team_name = team_name
    }
    
    
    func dictionary() -> [String: String] {
        return [
            "team_name": team_name
            // as you add attributes above, make sure you add them here also so they
            // get saved to the database also
            // See TPUser.setCurrentTeam()
        ]
    }

}
