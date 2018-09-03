//
//  VideoOffer.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 8/31/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

class VideoOffer {
    
    var uid: String? // also the key of the node
    var date: String?
    var date_ms: Int64?
    var email: String?
    var name: String?
    var phone: String?
    var photoUrl: String?
    var residential_address_line1: String?
    var residential_address_line2: String?
    var residential_address_city: String?
    var residential_address_state_abbrev: String?
    var residential_address_zip: String?
    var state_upper_district: String?
    var state_lower_district: String?
    
    init(user: TPUser) {
        uid = user.getUid()
        date = Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
        date_ms = Util.getDate_as_millis()
        email = user.getEmail()
        name = user.getName()
        phone = user.phone
        photoUrl = user.getPhotoURL().absoluteString
        residential_address_line1 = user.residential_address_line1
        residential_address_line2 = user.residential_address_line2
        residential_address_city = user.residential_address_city
        residential_address_state_abbrev = user.residential_address_state_abbrev
        residential_address_zip = user.residential_address_zip
//        state_upper_district = user.state_upper_district
//        state_lower_district = user.state_lower_district
    }
    
    
    func save(f: @escaping ()->Void, e: @escaping ()->Void) {
        if let uid = uid {
            Database.database().reference().child("video/offers/\(uid)").setValue(dictionary()) {
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                    e()
                } else {
                    print("Data saved successfully!")
                    f()
                }
            }
        }
    }
    
    
    static func createOffers(snapshot: DataSnapshot) -> [VideoOffer] {
        
        var offers = [VideoOffer]()
        let children = snapshot.children
        while let snap = children.nextObject() as? DataSnapshot {
            let offer = VideoOffer(snapshot: snap)
            offers.append(offer)
        }
        return offers
    }
    
    init(snapshot: DataSnapshot) {
        guard let dictionary = snapshot.value as? [String : Any] else {
            return
        }
//        key = snapshot.key // we don't bother with the key here because the use the uid as the key
        if let val = dictionary["uid"] as? String {
            uid = val
        }
        if let val = dictionary["date"] as? String {
            date = val
        }
        if let val = dictionary["date_ms"] as? Int64 {
            date_ms = val
        }
        if let val = dictionary["email"] as? String {
            email = val
        }
        if let val = dictionary["name"] as? String {
            name = val
        }
        if let val = dictionary["phone"] as? String {
            phone = val
        }
        if let val = dictionary["photoUrl"] as? String {
            photoUrl = val
        }
        if let val = dictionary["residential_address_line1"] as? String {
            residential_address_line1 = val
        }
        if let val = dictionary["residential_address_line2"] as? String {
            residential_address_line2 = val
        }
        if let val = dictionary["residential_address_city"] as? String {
            residential_address_city = val
        }
        if let val = dictionary["residential_address_state_abbrev"] as? String {
            residential_address_state_abbrev = val
        }
        if let val = dictionary["residential_address_zip"] as? String {
            residential_address_zip = val
        }
        if let val = dictionary["state_upper_district"] as? String {
            state_upper_district = val
        }
        if let val = dictionary["state_lower_district"] as? String {
            state_lower_district = val
        }
    }
    
    func delete() {
        if let uid = uid {
            Database.database().reference().child("video/offers").child(uid).removeValue()
        }
    }
    
    
    private func dictionary() -> [String: Any] {
        let dict : [String:Any] = [
            "uid": uid as Any
            ,"date": date as Any
            ,"date_ms": date_ms as Any
            ,"email": email as Any
            ,"name": name as Any
            ,"phone": phone as Any
            ,"photoUrl": photoUrl as Any
            ,"residential_address_line1": residential_address_line1 as Any
            ,"residential_address_line2": residential_address_line2 as Any
            ,"residential_address_city": residential_address_city as Any
            ,"residential_address_state_abbrev": residential_address_state_abbrev as Any
            ,"residential_address_zip": residential_address_zip as Any
            ,"state_upper_district": state_upper_district as Any
            ,"state_lower_district": state_lower_district as Any
        ]
        
        return dict
        
    }
    
}
