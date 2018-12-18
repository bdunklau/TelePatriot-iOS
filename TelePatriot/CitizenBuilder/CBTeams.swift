//
//  CBTeams.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/13/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
struct CBTeams : Decodable {
    
    var teams : [CBTeam]?
    
    init(data: [String:Any]) {
        
        if let tms = data["teams"] as? [[String:Any]] {
            for t in tms {
                teams?.append(CBTeam(data: t))
            }
        }
        
    }
}
