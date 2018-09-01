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
    
    var uid: String?
    var date: String?
    var date_ms: Int64?
    var email: String?
    var name: String?
    var phone: String?
    var residential_address_line1: String?
    var residential_address_line2: String?
    var residential_address_city: String?
    var residential_address_state_abbrev: String?
    var residential_address_zip: String?
    
    init(user: TPUser) {
        uid = user.getUid()
        date = Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
        date_ms = Util.getDate_as_millis()
        email = user.getEmail()
        name = user.getName()
        phone = user.phone
        residential_address_line1 = user.residential_address_line1
        residential_address_line2 = user.residential_address_line2
        residential_address_city = user.residential_address_city
        residential_address_state_abbrev = user.residential_address_state_abbrev
        residential_address_zip = user.residential_address_zip
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
    
    
    private func dictionary() -> [String: Any] {
        let dict : [String:Any] = [
            "uid": uid as Any,
            "date": date as Any,
            "date_ms": date_ms as Any,
            "email": email as Any,
            "name": name as Any,
            "phone": phone as Any,
            "residential_address_line1": residential_address_line1 as Any,
            "residential_address_line2": residential_address_line2 as Any,
            "residential_address_city": residential_address_city as Any,
            "residential_address_state_abbrev": residential_address_state_abbrev as Any,
            "residential_address_zip": residential_address_zip as Any
        ]
        
        return dict
        
    }
    
}
