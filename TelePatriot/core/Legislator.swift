//
//  Legislator.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/20/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

struct Legislator : Decodable {

    var full_name = ""
    var first_name = ""
    var last_name = ""
    var leg_id = "" // an OpenStates attribute
    var email = ""
    var emails = [String]() // this kinda sucks
    var phone = ""
    var phones = [String]() // this kinda sucks
    var party = ""
    var photo_url = ""
    var photoUrl = "" // comes from Google Civic API
    var chamber = "" // upper or lower
    var url = ""
    var offices = [Office]()
    //var channels = [Channel]()
    var district = ""
    var state = "" // state abbrev
    
    var legislator_cos_position = ""
    var legislator_facebook = ""
    var legislator_facebook_id = ""
    var legislator_twitter = ""
    
    struct Office : Decodable {
        var name = ""
        var phone = ""
        var address = ""
        var type = ""
        //let email : String
        
        init(data: [String:Any]) {
            if let n = data["name"] as? String {
                name = n
            }
            if let ph = data["phone"] as? String {
                phone = ph
            }
            if let ad = data["address"] as? String {
                address = ad
            }
            if let t = data["type"] as? String {
                type = t
            }
        }
        
        func dictionary() -> [String:String] {
            return [
                "name":name,
                "phone":phone,
                "address":address,
                "type":type
            ]
        }
    }
    
    init(data: [String:Any]) {
        
        if let fn = data["first_name"] as? String {
            first_name = fn
        }
        if let ln = data["last_name"] as? String {
            last_name = ln
        }
        if let p = data["party"] as? String {
            party = p  
        }
        if let ph = data["photo_url"] as? String {
            photo_url = ph
        }
        if let ph2 = data["photoUrl"] as? String { // comes from Google Civic API
            photoUrl = ph2
        }
        if let ch = data["chamber"] as? String {
            chamber = ch
        }
        if let u = data["url"] as? String {
            url = u
        }
        if let offs = data["offices"] as? [[String:Any]] {
            for off in offs {
                offices.append(Office(data: off))
            }
        }
        // what do we do about offices?
        if let d = data["district"] as? String {
            district = d
        }
        if let s = data["state"] as? String {
            state = s
        }
        if let lp = data["legislator_cos_position"] as? String {
            legislator_cos_position = lp
        }
        
        if let chans = data["channels"] as? [[String:Any]] {
            for chan in chans {
                if let type = chan["type"] as? String, let id = chan["id"] as? String {
                    if type.lowercased() == "facebook" {
                        if let fbId = chan["facebook_id"] as? String {
                            legislator_facebook_id = fbId
                            legislator_facebook = id
                        }
                    } else if type.lowercased() == "twitter" {
                        legislator_twitter = id
                    }
                }
            }
        }
        
        if let ems = data["emails"] as? [String] {
            if ems.count > 0 {
                email = ems[0]
            }
            emails = ems
        }
        
        if let phs = data["phones"] as? [String] {
            if phs.count > 0 {
                phone = phs[0]
            }
            phones = phs
        }
        
        
        /****************
         This is from the constructor of VideoNode, which has a different group of node names...
         ****************/
        
        if let ln = data["legislator_full_name"] as? String {
            full_name = ln
        }
        
        if let lg = data["leg_id"] as? String {
            leg_id = lg
        }
        
        if let ls = data["legislator_state_abbrev"] as? String {
            state = ls
        }
        
        if let ch = data["legislator_chamber"] as? String {
            chamber = ch
        }
        
        if let ld = data["legislator_district"] as? String {
            district = ld
        }
        
        if let lfb = data["legislator_facebook"] as? String {
            legislator_facebook = lfb
        }
        
        if let lfbid = data["legislator_facebook_id"] as? String {
            legislator_facebook_id = lfbid
        }
        
        if let ltw = data["legislator_twitter"] as? String {
            legislator_twitter = ltw
        }
        
        if let lte = data["legislator_email"] as? String {
            email = lte
        }
        
        if let ltp = data["legislator_phone"] as? String {
            phone = ltp
        }
        /****************
         This is from the constructor of VideoNode...
         ****************/
     }
    
    func getPhotoURL() -> URL {
        if let url = URL(string: photoUrl) {
            return url
        }
        else if let url = URL(string: photo_url) {
            return url
        }
        else {
            return URL(string: "https://i.stack.imgur.com/34AD2.jpg")!
        }
    }
    
    private func officesAsDictionary() -> [[String:String]] {
        var olist = [[String:String]]()
        for office in offices {
            olist.append(office.dictionary())
        }
        return olist
    }
    
}
