//
//  MissionItem2.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/23/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

// See OfficeTableViewCell.makeCall()
// This class is poorly named.  It looks like it was created so that we could call legislators
// directly
// Probably should have named this class something like CallLegislatorMission
class MissionItem2 {
    
    var id : String?
    var legislator : Legislator?
    var user : TPUser?
    var dictionary = Dictionary<String, Any>()
    
    // set in AppDelegate
    static var nextViewController : UIViewController?
    
    
    /******
     
     not present here
     var description : String
     var mission_id : String
     ******/
    
    
    init() {
        dictionary["mission_create_date"] = Util.getDate_MMM_d_yyyy_hmm_am_z()
    }
    
    func set(user: TPUser) {
        dictionary["uid"] = user.getUid()
        self.user = user
    }
    
    func set(legislator: Legislator) {
        self.legislator = legislator
        dictionary["name"] = legislator.first_name + " " + legislator.last_name
        dictionary["legislator_name"] = legislator.first_name + " " + legislator.last_name
        dictionary["legislator_state_abbrev"] = legislator.state.uppercased()
        dictionary["legislator_chamber"] = legislator.chamber
        dictionary["legislator_district"] = legislator.district
    }
    
    func getLegislator() -> Legislator? {
        return legislator
    }
    
    func set(phone: String) {
        dictionary["phone"] = phone
    }
    
    func getPhone() -> String? {
        return dictionary["phone"] as? String
    }
    
    func set(mission_type: String)  {
        dictionary["mission_type"] = mission_type
    }
    
    func set(mission_name: String)  {
        dictionary["mission_name"] = mission_name
    }
    
    func getMission_name() -> String? {
        return dictionary["mission_name"] as? String
    }
    
    // general purpose
    func set(attribute: String, value: String)  {
        dictionary[attribute] = value
    }
    
    
    // see  User.java submitWrapUp()
    func complete(outcome: String, notes: String) {
        dictionary["completed_by_uid"] = user?.getUid()
        dictionary["completed_by_name"] = user?.getName()
        dictionary["accomplished"] = "complete"
        dictionary["active_and_accomplished"] = "false_complete"
        dictionary["active"] = false
        if let uid = dictionary["uid"] as? String {
            dictionary["uid_and_active"] = "\(uid)_false"
        }
        dictionary["outcome"] = outcome
        dictionary["notes"] = notes
        dictionary["mission_complete_date"] = Util.getDate_MMM_d_yyyy_hmm_am_z()
        
        // this is where we need to save this object to the database under the user's list of completed missions
        // which actually doesn't even exist yet
        
        guard let u = user else {
            return
        }
        Database.database().reference().child("users/\(u.getUid())/completed_missions").childByAutoId().setValue(dictionary)
    }
    
    
}
