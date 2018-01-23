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
    var isAdmin = false
    var isDirector = false
    var isVolunteer = false
    var accountStatusEventListeners = [AccountStatusEventListener]()
    var ref : DatabaseReference?
    var rolesAlreadyFetched = false
    var noRoleAssignedDelegate : NoRoleAssignedDelegate?
    var currentMissionItem : MissionItem?
    var residential_address_line1 : String?
    var residential_address_line2 : String?
    var residential_address_city : String?
    var residential_address_state_abbrev : String?
    var residential_address_zip : String?
    var legislative_house_district : String?
    var legislative_senate_district : String?
    var current_latitude : Double?
    var current_longitude : Double?
    private var currentTeam : Team?
    private let appDelegate : AppDelegate
    
    private init() {
        ref = Database.database().reference()
        // Need to put the AppDelegate or SidePanelViewController in here
        
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
    
    func signOut() {
        try! Auth.auth().signOut()
        unassignCurrentMissionItem()
        user = nil
        rolesAlreadyFetched = false
        fireSignedOutEvent()
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
    func getName() -> String {
        guard let name = user!.displayName else {
            return "name not available"
        }
        return name
    }
    
    func getEmail() -> String {
        guard let email = user!.email else {
            return "email not available"
        }
        return email
    }
    
    func getUid() -> String {
        guard let u = user else {
            return "uid not available"
        }
        return u.uid
    }
    
    func getPhotoURL() -> URL {
        guard let photoURL = user!.photoURL else {
            return URL(string: "https://i.stack.imgur.com/34AD2.jpg")!
        }
        return photoURL
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
        let updatedUserData = ["users/\(uid)/residential_address_line1": residential_address_line1,
                               "users/\(uid)/residential_address_line2": residential_address_line2,
                               "users/\(uid)/residential_address_city": residential_address_city,
                               "users/\(uid)/residential_address_state_abbrev": residential_address_state_abbrev,
                               "users/\(uid)/residential_address_zip": residential_address_zip,
                               "users/\(uid)/legislative_house_district": legislative_house_district,
                               "users/\(uid)/legislative_senate_district": legislative_senate_district,
                               "users/\(uid)/current_latitude": current_latitude,
                               "users/\(uid)/current_longitude": current_longitude] as [String : Any]
        
        // Do a deep-path update
        theref.updateChildValues(updatedUserData, withCompletionBlock: { (error, ref) -> Void in
            callback(error as? NSError)
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
    
        guard let theref = ref else { return }
        
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
    
    
}
