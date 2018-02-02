//
//  TPUser.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/13/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

// Adapted from "Simplify Singletons" here -> https://savvyapps.com/blog/swift-tips-for-developers
class TPUser {
    static let sharedInstance = TPUser()
    var user : User?
    
    // IF YOU ADD FIELDS, ADD THEM ALSO TO clearFields() BELOW
    private var uid : String? // this is the key of the user's node
    var created : String? // MMM d, yyyy h:mm a z
    var current_latitude : Double?
    var current_longitude : Double?
    private var currentTeam : Team?
    private var email : String?
    var has_signed_confidentiality_agreement : Bool?
    var has_signed_petition : Bool?
    var is_banned : Bool?
    var legislative_house_district : String?
    var legislative_senate_district : String?
    private var name : String?
    private var photoUrl : URL? // the FirebaseUser attribute is actually this: photoURL
    var residential_address_city : String?
    var residential_address_line1 : String?
    var residential_address_line2 : String?
    var residential_address_state_abbrev : String?
    var residential_address_zip : String?
    
    var isAdmin = false
    var isDirector = false
    var isVolunteer = false
    
    // IF YOU ADD FIELDS, ADD THEM ALSO TO clearFields() BELOW
    var accountStatusEventListeners = [AccountStatusEventListener]()
    var ref : DatabaseReference?
    var rolesAlreadyFetched = false
    var noRoleAssignedDelegate : NoRoleAssignedDelegate?
    
    // IF YOU ADD FIELDS, ADD THEM ALSO TO clearFields() BELOW
    // both are reset to nil in WrapUpViewController.submitWrapUp()
    var currentMissionItem : MissionItem?
    var currentMissionItem2 : MissionItem2?
    
    private let appDelegate : AppDelegate
    
    private init() {
        // Is this going to be a problem when working with really large users sets?
        // WILL an admin ever be working be really large users sets?  dunno
        ref = Database.database().reference()
        
        appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    }
    
    func setUser(u: User?) {
        // only set the user object if it's not set already
        // If you want to logout/login as someone else, we need to UN-set this user first
        //  ...just my rule
        guard let usr = user else {
            user = u
            // This is where I have to notify the SidePanelViewController that the user changed
            appDelegate.leftViewController?.putTheCorrectStuffInThisView(user: self)
            fetchRoles(uid: getUid())
            fetchCurrentTeam(uid: getUid())
            
            fetchUser(uid: getUid()) // this should replace the other fetches above at some point
            return
        }
    }
    
    static func create(uid: String, dictionary: [String:Any]) -> TPUser? {
        let someuser = TPUser()
        someuser.uid = uid
        
        guard let created = dictionary["created"] as? String,
            let email = dictionary["email"] as? String,
            let name = dictionary["name"] as? String,
            let photoUrl = dictionary["photoUrl"] as? String else {
                return nil
        }
        
        someuser.created = created
        someuser.email = email
        someuser.name = name
        someuser.photoUrl = URL(string: photoUrl)
        
        if let lat = dictionary["current_latitude"] as? Double {
            someuser.current_latitude = lat
        }
        
        if let lng = dictionary["current_longitude"] as? Double {
            someuser.current_longitude = lng
        }
        
        if let conf = dictionary["has_signed_confidentiality_agreement"] as? Bool {
            someuser.has_signed_confidentiality_agreement = conf
        }
        
        if let pet = dictionary["has_signed_petition"] as? Bool {
            someuser.has_signed_petition = pet
        }
        
        if let ban = dictionary["is_banned"] as? Bool {
            someuser.is_banned = ban
        }
        
        if let hd = dictionary["legislative_house_district"] as? String {
            someuser.legislative_house_district = hd
        }
        
        if let sd = dictionary["legislative_senate_district"] as? String {
            someuser.legislative_senate_district = sd
        }
        
        if let city = dictionary["residential_address_city"] as? String {
            someuser.residential_address_city = city
        }
        
        if let line1 = dictionary["residential_address_line1"] as? String {
            someuser.residential_address_line1 = line1
        }
        
        if let line2 = dictionary["residential_address_line2"] as? String {
            someuser.residential_address_line2 = line2
        }
        
        if let st = dictionary["residential_address_state_abbrev"] as? String {
            someuser.residential_address_state_abbrev = st.uppercased()
        }
        
        if let zip = dictionary["residential_address_zip"] as? String {
            someuser.residential_address_zip = zip
        }
        
        if let roles = dictionary["roles"] as? [String:String] {
            if let adm = roles["Admin"] as? String, adm == "true" {
                someuser.isAdmin = true
            }
            if let dir = roles["Director"] as? String, dir == "true" {
                someuser.isDirector = true
            }
            if let vol = roles["Volunteer"] as? String, vol == "true" {
                someuser.isVolunteer = true
            }
        }
        /*************
         private var currentTeam : Team?
         probably should get the user's list of teams also
         *************/
        
        
        return someuser
    }
    
    func signOut() {
        try! Auth.auth().signOut()
        unassignCurrentMissionItem()
        user = nil
        rolesAlreadyFetched = false
        fireSignedOutEvent()
        clearFields()
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    func getName() -> String {
        if let usr = user, let displayName = usr.displayName {
            return displayName
        }
        else if let nm = name {
            return nm
        }
        else {
            return "name not available"
        }
    }
    
    func getEmail() -> String {
        if let usr = user, let em = usr.email {
            return em
        }
        else if let em = email {
            return em
        }
        else {
            return "email not available"
        }
    }
    
    func getUid() -> String {
        if let usr = user {
            return usr.uid
        }
        else if let id = uid {
            return id
        }
        else {
            return "uid not available"
        }
    }
    
    func getPhotoURL() -> URL {
        if let usr = user, let p = usr.photoURL {
            return p
        }
        else if let p = photoUrl {
            return p
        }
        else {
            return URL(string: "https://i.stack.imgur.com/34AD2.jpg")!
        }
    }
    
    func hasAnyRole() -> Bool {
        return isAdmin || isDirector || isVolunteer;
    }
    
    // Note, it's possible that the user has sinced turned off location services
    // This method just returns true if the user has EVER turned on location services
    func hasStoredLocation() -> Bool {
        
        // Even this criteria
        let notNil = current_latitude != nil
        return notNil
    }
    
    // right now, we are only updating residential address fields and lat/long fields
    // At some point, we should use this to update all fields
    func update(callback: @escaping (_ err: NSError?) -> Void) {
        
        guard let theref = ref else { return }
        let uid = getUid()
        // Create the data we want to update
        var updatedUserData = ["users/\(uid)/residential_address_line1": residential_address_line1,
                               "users/\(uid)/residential_address_line2": residential_address_line2,
                               "users/\(uid)/residential_address_city": residential_address_city,
                               "users/\(uid)/residential_address_state_abbrev": residential_address_state_abbrev,
                               "users/\(uid)/residential_address_zip": residential_address_zip,
                               "users/\(uid)/legislative_house_district": legislative_house_district,
                               "users/\(uid)/legislative_senate_district": legislative_senate_district,
                               "users/\(uid)/current_latitude": current_latitude,
                               "users/\(uid)/current_longitude": current_longitude,
                               "users/\(uid)/has_signed_confidentiality_agreement": has_signed_confidentiality_agreement,
                               "users/\(uid)/has_signed_petition": has_signed_petition,
                               "users/\(uid)/is_banned": is_banned] as [String : Any]
        
        if isAdmin {
            updatedUserData["users/\(uid)/roles/Admin"] = "true"
        } else {
            updatedUserData["users/\(uid)/roles/Admin"] = nil
        }
        
        if isDirector {
            updatedUserData["users/\(uid)/roles/Director"] = "true"
        } else {
            updatedUserData["users/\(uid)/roles/Director"] = nil
        }
        
        if isVolunteer {
            updatedUserData["users/\(uid)/roles/Volunteer"] = "true"
        } else {
            updatedUserData["users/\(uid)/roles/Volunteer"] = nil
        }
        
        // Do a multi-path update
        theref.updateChildValues(updatedUserData, withCompletionBlock: { (error, ref) -> Void in
            callback(error as NSError?)
        })
        
    }
    
    // this should replace the other fetchXxxx() functions at some point
    // Right now, all we're getting are the residential address fields
    private func fetchUser(uid: String) {
        
        guard let theref = ref else { return }
        
        theref.child("users").child(uid).observe(.value, with: {(snapshot) in
            guard let userNode = snapshot.value as? [String: Any] else {
                return
            }
            if let rad1 = userNode["residential_address_line1"] as? String {
                self.residential_address_line1 = rad1
            }
            if let rad2 = userNode["residential_address_line2"] as? String {
                self.residential_address_line2 = rad2
            }
            if let rac = userNode["residential_address_city"] as? String {
                self.residential_address_city = rac
            }
            if let ras = userNode["residential_address_state_abbrev"] as? String {
                self.residential_address_state_abbrev = ras
            }
            if let raz = userNode["residential_address_zip"] as? String {
                self.residential_address_zip = raz
            }
            if let hd = userNode["legislative_house_district"] as? String {
                self.legislative_house_district = hd
            }
            if let sd = userNode["legislative_senate_district"] as? String {
                self.legislative_senate_district = sd
            }
            if let lat = userNode["current_latitude"] as? Double {
                self.current_latitude = lat
            }
            if let lng = userNode["current_longitude"] as? Double {
                self.current_longitude = lng
            }
        })
    }
    
    func fetchCurrentTeam(uid: String) {
        
        guard let theref = ref else { return }
        
        theref.child("users").child(uid).child("current_team").queryLimited(toFirst: 1).observe(.value, with: {(snapshot) in
            guard let teamNode = snapshot.value as? [String: [String:String]] else {
                print(snapshot.value)
                print("snapshot.value above")
                return
            }
            
            for (team_name_as_key, teamAttributes) in teamNode {
                guard let team_name = teamAttributes["team_name"] else {
                    return
                }
                let team = Team(team_name: team_name)
                self.setCurrentTeamAndNotify(team: team, whileLoggingIn: true)
            }
            
        })
        
    }
    
    func fetchRoles(uid: String) {
        if(rolesAlreadyFetched) {
            return }
        
        rolesAlreadyFetched = true
    
        guard let theref = ref else {
            return }
        
        theref.child("no_roles").child(uid).observe(.value, with: {(snapshot) in
            guard let val = snapshot.value as? [String: Any] else {
                return
            }
            guard let name = val["name"] as! String? else {
                return
            }
            // If we get past the guard, it means there IS a node under /no_roles corresponding to
            // the current user.  So in this case, we want to send them to the Limbo screen...
            print("This user was found under the /no_roles node: name = \(name)") // <--- just FYI
            print("This user was found under the /no_roles node: val = \(val)")
            self.noRoleAssignedDelegate?.theUserHasNoRoles()
        })
        
        theref.child("users").child(uid).child("roles").observe(.childAdded, with: {(snapshot) in
            
            if let role = snapshot.key as? String {
                print(snapshot)
                let val = snapshot.value as? String
                if (role == "Admin" && val?.lowercased() == "true") {
                    self.isAdmin = true
                    self.roleAssigned(role: role)
                }
                
                if (role == "Director" && val?.lowercased() == "true") {
                    self.isDirector = true
                    self.roleAssigned(role: role)
                }
                
                if (role == "Volunteer" && val?.lowercased() == "true") {
                    self.isVolunteer = true
                    self.roleAssigned(role: role)
                }
            }
            
        }, withCancel: nil) // not sure what withCancel:nil does.  I know it's saying "no callback".  But when would we cancel this action?
        
        
        // To remove a permission, we don't set Admin=false or Director=false, etc
        // Instead, we remove the node altogether
        theref.child("users").child(uid).child("roles").observe(.childRemoved, with: {(snapshot) in
            
            print("==============================")
            print("snapshot is...")
            print(snapshot)
            print("snapshot.value is...")
            print(snapshot.value)
            
            if let role = snapshot.key as? String {
                print("success 1")
                if (role == "Admin") {
                    self.isAdmin = false
                    self.roleRemoved(role: role)
                }
                
                if (role == "Director") {
                    self.isDirector = false
                    self.roleRemoved(role: role)
                }
                
                if (role == "Volunteer") {
                    self.isVolunteer = false
                    self.roleRemoved(role: role)
                }
                
            }
            print("did we see success")
            
        }, withCancel: nil)
        
        
    }
    
    func roleAssigned(role: String) {
        // tell all the listeners that a role was assigned.  This is for LimboViewController, to tell it that
        // we can now send the user back to HomeViewController.  Also now for HomeViewController because on
        // that screen we have Volunteer, Director and Admin labels that we need to conditional show/hide
        for l in accountStatusEventListeners {
            l.roleAssigned(role: role)
        }
    }
    
    func roleRemoved(role: String) {
        // tell all the listeners that a role was remove.  This is for HomeViewController, to tell it that
        // we can now hide whatever role label corresponds to the role that was just removed
        for l in accountStatusEventListeners {
            l.roleRemoved(role: role)
        }
    }
    
    private func fireSignedOutEvent() {
        for l in self.accountStatusEventListeners {
            l.userSignedOut()
        }
    }
    
    func setCurrentTeam(team: Team) {
        // this needs to go back to the database
        guard let theref = ref else { return }
        
        // LESSON LEARNED: Do not try to unassign the "current mission item" from here
        // The "current team" has already been changed.  So if you try to unassign the current
        // mission item from here, you will write a partial mission_item record to the wrong team
        
        let current_team = [team.team_name : team.dictionary()]
        theref.child("users").child(getUid()).child("current_team").setValue(current_team) {(error, ref) -> Void in // completion block
            self.setCurrentTeamAndNotify(team: team, whileLoggingIn: false)
        }
    }
    
    
    func unassignCurrentMissionItem() {
        guard let team = getCurrentTeam(),
            let missionItem = currentMissionItem,
            let mission_item_id = missionItem.mission_item_id as? String else {
                return
        }
        
        // better way than this would be to do multi-path updates.  There are examples somewhere in xcode
        // and/or Android studio
        Database.database().reference().child("teams/\(team.team_name)/mission_items/"+mission_item_id+"/accomplished").setValue("new")
        Database.database().reference().child("teams/\(team.team_name)/mission_items/"+mission_item_id+"/active_and_accomplished").setValue("true_new")
        Database.database().reference().child("teams/\(team.team_name)/mission_items/"+mission_item_id+"/group_number").setValue(missionItem.group_number_was)
        
        // works, but ugly.  We're actually passing in the currentMissionItem and operating on that function arg
        // Then here at the end, we set this instance var to nil - ugh
        currentMissionItem = nil
    }
    
    
    private func setCurrentTeamAndNotify(team: Team, whileLoggingIn: Bool) {
        self.currentTeam = team
        // where are these listeners set?...
        // Ans:  CenterViewController.checkLoggedIn()
        // We also want MissionSummaryTVC to be a listener also so that we can clear out its 'missions' list
        // from the previously selected team
        for l in self.accountStatusEventListeners {
            l.teamSelected(team: team, whileLoggingIn: whileLoggingIn)
        }
    }
    
    func getCurrentTeam() -> Team? {
        return currentTeam
    }
    
    
    private func clearFields() {
        
        user = nil
        uid = nil // this is the key of the user's node
        created = nil
        current_latitude  = nil
        current_longitude = nil
        currentTeam = nil
        email = nil
        has_signed_confidentiality_agreement  = nil
        has_signed_petition  = nil
        is_banned  = nil
        legislative_house_district = nil
        legislative_senate_district = nil
        name = nil
        photoUrl = nil // the FirebaseUser attribute is actually this: photoURL
        residential_address_city = nil
        residential_address_line1 = nil
        residential_address_line2  = nil
        residential_address_state_abbrev = nil
        residential_address_zip = nil
        
        // Not sure why these prevent their menu items from showing up.  I thought they
        // would re-appear whenever the user logs in.  But for some reason, they don't
        //isAdmin = false
        //isDirector = false
        //isVolunteer = false
        
        accountStatusEventListeners = [AccountStatusEventListener]()
        //ref = nil
        rolesAlreadyFetched = false
        noRoleAssignedDelegate = nil
        
        // both are reset to nil in WrapUpViewController.submitWrapUp()
        currentMissionItem = nil
        currentMissionItem2 = nil
    }
    
    
}
