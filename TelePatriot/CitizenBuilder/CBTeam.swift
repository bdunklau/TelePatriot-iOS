//
//  CBTeam.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/12/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation

struct CBTeam : Decodable, TeamIF {
    
    var id : Int32?
    var name : String?
    
    init(data: [String:Any]) {
        
        if let id = data["id"] as? Int32 {
            self.id = id
        }
        if let name = data["name"] as? String {
            self.name = name
        }
        if let name = data["team_name"] as? String { // another possibility
            self.name = name
        }
    }
    
    func getId() -> Int32? {
        return id
    }
    
    func getName() -> String? {
        return name
    }
    
    func dictionary() -> [String: Any] {
        return [
            "team_name": name,
            "id": id
        ]
    }
}

protocol TeamIF {
    func getId() -> Int32?
    func getName() -> String?
    func dictionary() -> [String: Any]
}
