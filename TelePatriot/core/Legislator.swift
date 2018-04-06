//
//  Legislator.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/20/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation

struct Legislator : Decodable {

    
    let first_name : String
    let last_name : String
    let party : String
    let photo_url : String
    let chamber : String // upper or lower
    let url : String
    let offices : [Office]
    let district : String // but really a number
    let state : String // state abbrev
    
    let legislator_cos_position : String?
    let legislator_facebook : String?
    let legislator_twitter : String?
    
    struct Office : Decodable {
        let name : String
        let phone : String
        let address : String
        let type : String
        //let email : String
    }
}
