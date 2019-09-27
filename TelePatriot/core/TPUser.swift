//
//  TPUser.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/13/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuthUI

// Adapted from "Simplify Singletons" here -> https://savvyapps.com/blog/swift-tips-for-developers
class TPUser {
    static let sharedInstance = TPUser()
    var user : User?
    
    // IF YOU ADD FIELDS, ADD THEM ALSO TO clearFields() BELOW
    var uid : String? // this is the key of the user's node
    var account_disposition : String?
    var account_dispositioned_by : String?
    var account_dispositioned_by_uid : String?
    var account_dispositioned_on : String?
    var account_dispositioned_on_ms : Int64?
    
    var citizen_builder_id : Int32?
    var created : String? // MMM d, yyyy h:mm a z
    var current_latitude : Double?
    var current_longitude : Double?
    private var currentTeam : TeamIF?
    private var email : String?
    var has_signed_confidentiality_agreement : Bool?
    var has_signed_petition : Bool?
    var is_banned : Bool?
    var legislative_house_district : String?   // WHY ARE SOME OF THESE PRIVATE AND OTHERS AREN'T
    var legislative_senate_district : String?  // I DON'T THINK THERE'S A GOOD REASON
    var name : String?
    var phone : String?
    var photoUrl : URL? // the FirebaseUser attribute is actually this: photoURL
    var recruiter_id : String?
    var residential_address_city : String?
    var residential_address_line1 : String?
    var residential_address_line2 : String?
    var residential_address_state_abbrev : String?
    var residential_address_zip : String?
    var state_upper_district: String?
    var state_lower_district: String?
    var video_invitation_from: String?
    var video_invitation_from_name: String?
    var teams : [TeamIF]?
    
    var isVolunteer = false
    var isDirector = false
    var isVideoCreator = false
    var isAdmin = false
    
    // IF YOU ADD FIELDS, ADD THEM ALSO TO clearFields() BELOW
    var accountStatusEventListeners = [AccountStatusEventListener]()
    
    // don't set this to nil unless you know what you're doing.  See LESSON LEARNED at the very bottom
    var databaseRef : DatabaseReference?
    var rolesAlreadyFetched = false
//    var noRoleAssignedDelegate : NoRoleAssignedDelegate?
    
    // IF YOU ADD FIELDS, ADD THEM ALSO TO clearFields() BELOW
    // both are reset to nil in WrapUpViewController.submitWrapUp()
    var currentMissionItem : MissionItem?
    var currentMissionItem2 : MissionItem2? // see class def comment header
    var currentCBMissionItem : CBMissionDetail?
    
    var current_video_node_key : String?
    
    
    private let appDelegate : AppDelegate
    
    
    // We don't want this class to be a singleton
    private init() {
        // Is this going to be a problem when working with really large users sets?
        // WILL an admin ever be working be really large users sets?  dunno
        //ref = Database.database().reference()
        
        appDelegate = (UIApplication.shared.delegate as? AppDelegate)!
    }
    
    // See CenterViewController.checkLoggedIn()
    func setUser(u: User?) {
        // only set the user object if it's not set already
        // If you want to logout/login as someone else, we need to UN-set this user first
        //  ...just my rule
        guard user != nil else {
            user = u
            // This is where I have to notify the SidePanelViewController that the user changed
            appDelegate.leftViewController?.putTheCorrectStuffInThisView(user: self)
            //setUserId(uid: (user?.uid)!) // fix/refactor
            queryForUserData(uid: (user?.uid)!, callback: {(tpuser) in /* do nothing */  })
            return
        }
    }
    
    private func queryForUserData(uid: String, callback: @escaping (TPUser) -> Void ) {
        if databaseRef == nil {
            databaseRef = Database.database().reference()
        }

        databaseRef?.child("users").child(uid).observe(.value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                self.populate(uid: uid, dictionary: dictionary)
                self.redirectIfNotAllowed()
            }
        })
    }
    
    //    private func queryForUserData(uid: String, callback: @escaping (TPUser) -> Void ) {
    //        if databaseRef == nil {
    //            databaseRef = Database.database().reference()
    //        }
    //
    //        databaseRef?.child("users").child(uid).observe(.value, with: {(snapshot) in
    ////        databaseRef?.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
    //            guard let dictionary = snapshot.value as? [String: Any] else {
    //                return
    //            }
    //            // TODO this is really bad form to be doing additional queries here...
    //            self.fetchRoles(uid: uid, citizen_builder_id: dictionary["citizen_builder_id"] as? Int)
    //            self.fetchCurrentTeam(uid: uid)
    //            self.populate(uid: uid, dictionary: dictionary)
    //            self.redirectIfNotAllowed()
    //            callback(self) // search for "callback" above - does nothing
    //        })
    //    }
    
    // doesn't consider account_disposition:enabled/disabled
    func isAllowed() -> Bool {
        // make sure the user should be allowed in
        if let has_signed_petition = self.has_signed_petition,
            has_signed_petition,
            let has_signed_confidentiality_agreement = self.has_signed_confidentiality_agreement,
            has_signed_confidentiality_agreement,
            let is_banned = self.is_banned,
            !is_banned {
            
            return true
        }
        else {
            return false
        }
    }
    
    private func redirectIfNotAllowed() {
        // make sure the user should be allowed in
        if isAllowed() {
            // good - let them in
            fireAllowed()
        }
        else {
            // bad - send them to the limbo screen
            fireNotAllowed()
        }
        
        if let account_disposition = self.account_disposition,
            account_disposition == "enabled" {
            fireAccountEnabled()
        }
        else {
            fireAccountDisabled()
        }
    }
    
    static func create(uid: String, callback: @escaping (TPUser) -> Void ) {
        let someuser = TPUser()
//        someuser.queryForUserData(uid: uid, callback: callback)
    }
    
    func set(name: String) {
        self.name = name
        // Added primarily to dismiss the MissingInformationView that gets displayed when new
        // users sign up via email.  The user.displayName attribute finally becomes available in
        // CenterViewController.authUI().  At that point, we call this function and then update
        // the database.  We would like for user.displayName to be available as soon as the auth
        // event fires in CenterViewController.checkLoggedIn() at Auth.auth().addStateDidChangeListener
        // but alas, displayName is not available there.
        fireChange(name: name)
    }
    
    func set(email: String) {
        self.email = email
    }
    
    private func populate(uid: String, dictionary: [String:Any]) {
        
        self.uid = uid
        
        if let account_disposition = dictionary["account_disposition"] as? String {
            self.account_disposition = account_disposition
        }
        if let account_dispositioned_by_uid = dictionary["account_dispositioned_by_uid"] as? String {
            self.account_dispositioned_by_uid = account_dispositioned_by_uid
        }
        if let account_dispositioned_on = dictionary["account_dispositioned_on"] as? String {
            self.account_dispositioned_on = account_dispositioned_on
        }
        if let account_dispositioned_on_ms = dictionary["account_dispositioned_on_ms"] as? Int64 {
            self.account_dispositioned_on_ms = account_dispositioned_on_ms
        }
        
        if let created = dictionary["created"] as? String {
            self.created = created
        }
        if let citizen_builder_id = dictionary["citizen_builder_id"] as? Int32 {
            self.citizen_builder_id = citizen_builder_id
        }
        if let lat = dictionary["current_latitude"] as? Double {
            self.current_latitude = lat
        }
        if let lng = dictionary["current_longitude"] as? Double {
            self.current_longitude = lng
        }
        
        if let current_team_node = dictionary["current_team"] as? [String:[String:Any]],
            let current_team = current_team_node.keys.first,
            let team_data = current_team_node[current_team] as? [String:Any]
        {
            let tm = CBTeam(data: team_data)
            self.setCurrentTeamAndNotify(team: tm, whileLoggingIn: false)
        }
        
        if let email = dictionary["email"] as? String {
            self.email = email
            fireChange(email: email)
        }
        
        if let has_signed_confidentiality_agreement = dictionary["has_signed_confidentiality_agreement"] as? Bool {
            self.has_signed_confidentiality_agreement = has_signed_confidentiality_agreement
        }
        else {
            self.has_signed_confidentiality_agreement = nil
        }
        
        if let has_signed_petition = dictionary["has_signed_petition"] as? Bool {
            self.has_signed_petition = has_signed_petition
        }
        else {
            self.has_signed_petition = nil
        }
        
        if let is_banned = dictionary["is_banned"] as? Bool {
            self.is_banned = is_banned
        }
        else {
            self.is_banned = nil
        }
        
        if let hd = dictionary["legislative_house_district"] as? String {
            self.legislative_house_district = hd
        }
        if let sd = dictionary["legislative_senate_district"] as? String {
            self.legislative_senate_district = sd
        }
        if let name = dictionary["name"] as? String {
            self.name = name
            fireChange(name: name)
        }
        if let phone = dictionary["phone"] as? String {
            self.phone = phone
        }
        if let photoUrl = dictionary["photoUrl"] as? URL {
            self.photoUrl = photoUrl
        }
        if let recruiter_id = dictionary["recruiter_id"] as? String {
            self.recruiter_id = recruiter_id
        }
        if let rac = dictionary["residential_address_city"] as? String {
            self.residential_address_city = rac
        }
        if let rad1 = dictionary["residential_address_line1"] as? String {
            self.residential_address_line1 = rad1
        }
        if let rad2 = dictionary["residential_address_line2"] as? String {
            self.residential_address_line2 = rad2
        }
        if let ras = dictionary["residential_address_state_abbrev"] as? String {
            self.residential_address_state_abbrev = ras
        }
        if let raz = dictionary["residential_address_zip"] as? String {
            self.residential_address_zip = raz
        }
        if let val = dictionary["state_upper_district"] as? String {
            self.state_upper_district = val
        }
        if let val = dictionary["state_lower_district"] as? String {
            self.state_lower_district = val
        }
        if let roles = dictionary["roles"] as? [String:String] {
            if let adm = roles["Admin"], adm == "true" {
                self.isAdmin = true
                roleAssigned(role: "Admin")
            }
            else {
                self.isAdmin = false
                roleRemoved(role: "Admin")
            }
            if let dir = roles["Director"], dir == "true" {
                self.isDirector = true
                roleAssigned(role: "Director")
            }
            else {
                self.isDirector = false
                roleRemoved(role: "Director")
            }
            if let vol = roles["Volunteer"], vol == "true" {
                self.isVolunteer = true
                roleAssigned(role: "Volunteer")
            }
            else {
                self.isVolunteer = false
                roleRemoved(role: "Volunteer")
            }
            if let r = roles["Video Creator"], r == "true" {
                self.isVideoCreator = true
                roleAssigned(role: "Video Creator")
            }
            else {
                self.isVideoCreator = false
                roleRemoved(role: "Video Creator")
            }
        }
        if let cvk = dictionary["current_video_node_key"] as? String {
            self.current_video_node_key = cvk
        }
        else {
            // keeps the TPUser object in sync with the database.  We don't want the user object
            // on the iPhone to think it has a current_video_node_key when that node has actually been deleted
            self.current_video_node_key = nil
        }
        
        if let val = dictionary["video_invitation_from_name"] as? String {
            video_invitation_from_name = val
        }
        else {
            video_invitation_from_name = nil
        }
        
        if let val = dictionary["video_invitation_from"] as? String, video_invitation_from == nil {
            // means an invitation was just extended
            video_invitation_from = val
            let video_invitation_key = VideoInvitation.createKey(initiator: val, guest: TPUser.sharedInstance.getUid())
            Database.database().reference().child("video/invitations/\(video_invitation_key)")
                .observeSingleEvent(of: .value, with: {(snapshot) in
                    let vi = VideoInvitation(snapshot: snapshot)
                    self.fireVideoInvitationExtended(vi: vi)
                })
        }
        
        // means an invitation was just revoked
        if dictionary["video_invitation_from"] == nil, let video_invitation_from = video_invitation_from {
            let video_invitation_key = VideoInvitation.createKey(initiator: video_invitation_from, guest: TPUser.sharedInstance.getUid())
            Database.database().reference().child("video/invitations/\(video_invitation_key)")
                .observeSingleEvent(of: .value, with: {(snapshot) in
                    self.video_invitation_from = nil
                    self.video_invitation_from_name = nil
                    self.fireVideoInvitationRevoked()
                })
        }
        
        
        // teams?
        // topics?
        
    }
    
    // Called from SearchUsersVC, UnassignedUsersVC
    static func create(uid: String, dictionary: [String:Any]) -> TPUser? {
        let someuser = TPUser()
        someuser.uid = uid
        
        someuser.populate(uid: uid, dictionary: dictionary)
        
        return someuser
        
    }
    
    func signOut() {
        try! Auth.auth().signOut()
        setCurrent_video_node_key(current_video_node_key: nil)
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
    func update(callback: @escaping (_ err: NSError?) -> Void ) {
        
        if databaseRef == nil {
            databaseRef = Database.database().reference()
        }
        
        
        let uid = getUid()
        // Create the data we want to update
        var updatedUserData = [
            "users/\(uid)/account_disposition": account_disposition as Any,
            "users/\(uid)/account_dispositioned_by": account_dispositioned_by as Any,
            "users/\(uid)/account_dispositioned_by_uid": account_dispositioned_by_uid as Any,
            "users/\(uid)/account_dispositioned_on": account_dispositioned_on as Any,
            "users/\(uid)/account_dispositioned_on_ms": account_dispositioned_on_ms as Any,
            "users/\(uid)/residential_address_line1": residential_address_line1 as Any,
            "users/\(uid)/residential_address_line2": residential_address_line2 as Any,
            "users/\(uid)/residential_address_city": residential_address_city as Any,
            "users/\(uid)/residential_address_state_abbrev": residential_address_state_abbrev as Any,
            "users/\(uid)/residential_address_zip": residential_address_zip as Any,
            "users/\(uid)/legislative_house_district": legislative_house_district as Any,
            "users/\(uid)/legislative_senate_district": legislative_senate_district as Any,
            "users/\(uid)/name": name as Any,
            "users/\(uid)/name_lower": name?.lowercased() as Any,
            "users/\(uid)/state_upper_district": state_upper_district as Any,
            "users/\(uid)/state_lower_district": state_lower_district as Any,
            "users/\(uid)/current_latitude": current_latitude as Any,
            "users/\(uid)/current_longitude": current_longitude as Any,
            "users/\(uid)/current_video_node_key": current_video_node_key as Any,
            "users/\(uid)/has_signed_confidentiality_agreement": has_signed_confidentiality_agreement as Any,
            "users/\(uid)/has_signed_petition": has_signed_petition as Any,
            "users/\(uid)/is_banned": is_banned as Any] as [String : Any]
        
        if isAdmin {
            updatedUserData["users/\(uid)/roles/Admin"] = "true"
        } else {
            updatedUserData["users/\(uid)/roles/Admin"] = NSNull()
        }
        
        if isDirector {
            updatedUserData["users/\(uid)/roles/Director"] = "true"
        } else {
            updatedUserData["users/\(uid)/roles/Director"] = NSNull()
        }
        
        if isVolunteer {
            updatedUserData["users/\(uid)/roles/Volunteer"] = "true"
        } else {
            updatedUserData["users/\(uid)/roles/Volunteer"] = NSNull()
        }
        
        if isVideoCreator {
            updatedUserData["users/\(uid)/roles/Video Creator"] = "true"
        } else {
            updatedUserData["users/\(uid)/roles/Video Creator"] = NSNull()
        }
        
        if let teams = teams, teams.isEmpty {
            // very specific case of deactivating users...
            updatedUserData["users/\(uid)/teams"] = NSNull()
        }
        
        // Do a multi-path update
        databaseRef?.updateChildValues(updatedUserData, withCompletionBlock: { (error, ref) -> Void in
            callback(error as NSError?)
        })
        
    }
    
    func setEnabled(_ enabled: Bool) {
        account_disposition = enabled ? "enabled" : "disabled"
        account_dispositioned_by = TPUser.sharedInstance.getName()
        account_dispositioned_by_uid = TPUser.sharedInstance.getUid()
        account_dispositioned_on = Util.getDate_MMM_d_yyyy_hmm_am_z()
        account_dispositioned_on_ms = Util.getDate_as_millis()
    }
    
    func isDisabled() -> Bool {
        if let disp = account_disposition {
            return disp == "disabled"
        }
        else {
            return false
        }
    }
    
    
    func setCurrent_video_node_key(current_video_node_key: String?) {
        if let uid = uid {
            // TODO this is a hack I added so the the video_node_key would be immediately available when the user
            // accepts a video invitation from VideoInvitationsVC.  If this field isn't set immediately, there's a possibility
            // that a new video node will be created in VideoChatVC.getVideoNodeKey()
            self.current_video_node_key = current_video_node_key
            
            let data = ["users/\(uid)/current_video_node_key": current_video_node_key] as [String : String?]
            // Do a multi-path update even though just one path
            databaseRef?.updateChildValues(data, withCompletionBlock: { (error, ref) -> Void in
                if error == nil {
                    self.current_video_node_key = current_video_node_key // unnecessary given the hack above
                }
            })
        }
    }
    
    
    private func fetchCurrentTeam(uid: String) {
        
        if databaseRef == nil {
            databaseRef = Database.database().reference()
        }
        
        databaseRef?.child("users").child(uid).child("current_team").queryLimited(toFirst: 1).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let teamNode = snapshot.value as? [String: [String:Any]] else {
                print(snapshot.value as Any)
                print("snapshot.value above")
                return
            }
            
            for (_, teamAttributes) in teamNode {
                guard let team_name = teamAttributes["team_name"] as? String else {
                    return
                }
                let team = self.createTeam(team_name: team_name, data: teamAttributes)
                self.setCurrentTeamAndNotify(team: team, whileLoggingIn: true)
            }
            
        })
        
    }
    
    private func createTeam(team_name: String, data: [String:Any]) -> TeamIF {
        if let _ = data["id"] as? Int32 {
            let team = CBTeam(data: data)
            return team
        }
        else {
            return Team(team_name: team_name)
        }
    }
    
    private func fetchRoles(uid: String, citizen_builder_id: Int?) {
        Database.database().reference().child("administration/configuration").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            if let vals = snapshot.value as? [String:Any] {
                let conf = Configuration(data: vals)
                if let citizen_builder_id = citizen_builder_id, conf.getRolesFromCB() {
                    self.fetchRoles_fromCB(citizen_builder_id: citizen_builder_id)
                }
                else {
                    self.fetchRoles_fromFirebase(uid: uid)
                }
            }
        })
    }
    
    private func fetchRoles_fromCB(citizen_builder_id: Int) {
    }
    
    // The "old way" is by getting role information from the TelePatriot/Firebase database
    // The "new way" is by making an API call to CB to figure out what roles the user has
    private func fetchRoles_fromFirebase(uid: String) {
        if(rolesAlreadyFetched) {
            return }
        
        rolesAlreadyFetched = true
        
        if databaseRef == nil {
            databaseRef = Database.database().reference()
        }
        
//        databaseRef?.child("no_roles").child(uid).observe(.value, with: {(snapshot) in
//            guard let val = snapshot.value as? [String: Any] else {
//                return
//            }
//            guard let name = val["name"] as! String? else {
//                return
//            }
//            // If we get past the guard, it means there IS a node under /no_roles corresponding to
//            // the current user.  So in this case, we want to send them to the Limbo screen...
//            print("This user was found under the /no_roles node: name = \(name)") // <--- just FYI
//            print("This user was found under the /no_roles node: val = \(val)")
//            self.noRoleAssignedDelegate?.theUserHasNoRoles()
//        })
        
        databaseRef?.child("users").child(uid).child("roles").observe(.childAdded, with: {(snapshot) in
            
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
                
                if (role == "Video Creator" && val?.lowercased() == "true") {
                    self.isVideoCreator = true
                    self.roleAssigned(role: role)
                }
            }
            
        }, withCancel: nil) // not sure what withCancel:nil does.  I know it's saying "no callback".  But when would we cancel this action?
        
        
        // To remove a permission, we don't set Admin=false or Director=false, etc
        // Instead, we remove the node altogether
        databaseRef?.child("users").child(uid).child("roles").observe(.childRemoved, with: {(snapshot) in
            
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
                
                if (role == "Video Creator") {
                    self.isVideoCreator = false
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
    
    private func fireChange(name: String) {
        for l in self.accountStatusEventListeners {
            l.changed(name: name)
        }
    }
    
    private func fireChange(email: String) {
        for l in self.accountStatusEventListeners {
            l.changed(email: email)
        }
    }
    
    private func fireAllowed() {
        print("==========================================================")
        print("TPUser.fireAllowed()")
        // get rid of the limbo screen if it's currently being displayed
        for l in self.accountStatusEventListeners {
            print("accountStatusEventListener:  \(String(describing: l))")
            l.allowed()
        }
    }
    
    private func fireNotAllowed() {
        print("==========================================================")
        print("fireNotAllowed()")
        // send the user to the limbo screen because they are not allowed in
        for l in self.accountStatusEventListeners {
            print("accountStatusEventListener:  \(String(describing: l))")
            l.notAllowed()
        }
    }
    
    private func fireAccountEnabled() {
        print("==========================================================")
        print("fireAccountEnabled()")
        // make sure the DisabledVC isn't showing if their account goes from account_disposition:disabled to :enabled
        for l in self.accountStatusEventListeners {
            print("accountStatusEventListener:  \(String(describing: l))")
            l.accountEnabled()
        }
    }
    
    private func fireAccountDisabled() {
        print("==========================================================")
        print("fireAccountDisabled()")
        // make sure the DisabledVC is showing if their account is account_disposition:disabled
        for l in self.accountStatusEventListeners {
            print("accountStatusEventListener:  \(String(describing: l))")
            l.accountDisabled()
        }
    }
    
    private func fireSignedOutEvent() {
        print("==========================================================")
        print("fireSignedOutEvent()")
        for l in self.accountStatusEventListeners {
            print("accountStatusEventListener:  \(String(describing: l))")
            l.userSignedOut()
        }
    }
    
    private func fireVideoInvitationExtended(vi: VideoInvitation) {
        print("==========================================================")
        print("fireVideoInvitationExtended()")
        for l in self.accountStatusEventListeners {
            l.videoInvitationExtended(vi: vi)
        }
    }
    
    private func fireVideoInvitationRevoked() {
        print("==========================================================")
        print("fireVideoInvitationRevoked()")
        for l in self.accountStatusEventListeners {
            l.videoInvitationRevoked()
        }
    }
    
    func setCurrentTeam(team: TeamIF) {
        if databaseRef == nil {
            databaseRef = Database.database().reference()
        }
        
        
        // LESSON LEARNED: Do not try to unassign the "current mission item" from here
        // The "current team" has already been changed.  So if you try to unassign the current
        // mission item from here, you will write a partial mission_item record to the wrong team
        if let team_name = team.getName() {
            //self.setCurrentTeamAndNotify(team: team, whileLoggingIn: false)
            
            let current_team = [team_name : team.dictionary()]
            databaseRef?.child("users").child(getUid()).child("current_team").setValue(current_team) {(error, ref) -> Void in
                // do nothing
                // We used to have the self.setCurrentTeamAndNotify() call in here but on the very first time to
                // the switch teams screen, it would take forever to actually switch teams and make the app slide
                // the menu out with the newly selected team.  So I moved self.setCurrentTeamAndNotify() up above and
                // out of this callback func
                
            }
        }
    }
    
    
    func unassignCurrentMissionItem() {
        // We have some "transitional" code in here that will go away once the integration with CB is complete
        // We're going to see what kind of "current" mission we have - do we have the original kind of mission
        // that is stored in the TelePatriot/Firebase database?
        // Or do we have the new style mission that comes from CB?
        unassignLegacyMissionItem()
        unassignCBMissionItem()
    }
    
    
    private func unassignLegacyMissionItem() {
        
        guard let team = getCurrentTeam(),
            let missionItem = currentMissionItem,
            let mission_item_id = missionItem.mission_item_id as? String else {
                return
        }
        
        // TODO better way than this would be to do multi-path updates.  There are examples somewhere in xcode
        // and/or Android studio
        if let team_name = team.getName() {
            let updates : [String:Any] = ["teams/\(team_name)/mission_items/"+mission_item_id+"/accomplished": "new",
                           "teams/\(team_name)/mission_items/"+mission_item_id+"/active_and_accomplished": "true_new",
                           "teams/\(team_name)/mission_items/"+mission_item_id+"/group_number": missionItem.group_number_was]
            Database.database().reference().updateChildValues(updates)
//            Database.database().reference().child("teams/\(team.team_name)/mission_items/"+mission_item_id+"/accomplished").setValue("new")
//            Database.database().reference().child("teams/\(team.team_name)/mission_items/"+mission_item_id+"/active_and_accomplished").setValue("true_new")
//            Database.database().reference().child("teams/\(team.team_name)/mission_items/"+mission_item_id+"/group_number").setValue(missionItem.group_number_was)
        }
        // works, but ugly.  We're actually passing in the currentMissionItem and operating on that function arg
        // Then here at the end, we set this instance var to nil - ugh
        currentMissionItem = nil
    }
    
    private func unassignCBMissionItem() {
        guard let currentCBMissionItem = currentCBMissionItem else {
            return }
        
        // TODO is there a way to encapsulate this call that gets us the Configuration object?
        Database.database().reference().child("administration/configuration").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            if let vals = snapshot.value as? [String:Any] {
                let conf = Configuration(data: vals)
                if conf.getMissionsFromCB() {
                    guard let domain = conf.getCitizenBuilderDomain(),
                        let mission_id = currentCBMissionItem.mission_id,
                        let person_id = currentCBMissionItem.person_id,
                        let url = URL(string: "https://\(domain)/api/ios/v1/volunteers/revoke_person_call?person_id=\(person_id)&mission_id=\(mission_id)"),
                        let apiKeyName = conf.getCitizenBuilderApiKeyName(),
                        let apiKeyValue = conf.getCitizenBuilderApiKeyValue()
                    else {
                        return
                    }
                    print("url = \(url)")
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.setValue(apiKeyValue, forHTTPHeaderField: apiKeyName)
                    
                    let config = URLSessionConfiguration.default
                    let session = URLSession(configuration: config)
                    let task = session.dataTask(with: request) { (data, response, responseError) in
                        
                        print("Unassigned CB Mission:  person_id=\(person_id)  mission_id=\(mission_id)")
                        
                        // revoking/unassigning a mission gives you this response back
                        /***
                         {
                         "info": "Success",
                         "total": null,
                         "calls_made": null,
                         "percent_complete": null
                         }
                        ***/
                        
                        // not sure if we care to process the response though.  It's always "success" from CB
                        // even when we pass obviously erroneous data
                        //let decoder = JSONDecoder()
                    }
                    task.resume()
                }
                // don't care about 'else'
            }
        })
    }
    
    
    func currentlyBeingReviewed(by: TPUser) {
        let evt = ["date": Util.getDate_MMM_d_yyyy_hmm_am_z(), "event": "Admin (\(by.getName())) is reviewing your account..."]
        Database.database().reference().child("users/\(getUid())/account_status_events/").childByAutoId().setValue(evt)
    }
    
    
    private func setCurrentTeamAndNotify(team: TeamIF, whileLoggingIn: Bool) {
        self.currentTeam = team
        // where are these listeners set?...
        // Ans:  CenterViewController.checkLoggedIn()
        for l in self.accountStatusEventListeners {
            l.teamSelected(team: team, whileLoggingIn: whileLoggingIn)
        }
    }
    
    func getCurrentTeam() -> TeamIF? {
        return currentTeam
    }
    
    
    func addAccountStatusEventListener(listener: AccountStatusEventListener) {
        
        if(self.accountStatusEventListeners.count == 0
            || !self.accountStatusEventListeners.contains(where: { String(describing: type(of: $0)) == String(describing: type(of: listener)) })) {
            self.accountStatusEventListeners.append(listener)
        } else { print("TPUser: NOT adding \(String(describing: type(of: listener))) to list of accountStatusEventListeners") }
    }
    
    private func clearFields() {
        
        user = nil
        uid = nil // this is the key of the user's node
        created = nil
        citizen_builder_id = nil
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
        state_upper_district = nil
        state_lower_district = nil
        video_invitation_from = nil
        video_invitation_from_name = nil
        
        // Not sure why these prevent their menu items from showing up.  I thought they
        // would re-appear whenever the user logs in.  But for some reason, they don't
        //isAdmin = false
        //isDirector = false
        //isVolunteer = false
        
        // LET'S LEAVE THESE IN PLACE  If you sign out and back in, CenterViewController.viewDidLoad() doesn't get
        // called again.  And that's where we add CenterViewController as a listener on the TPUser object.
        // And we always need CenterViewController to be an AccountStatusEventListener because that's how we communicate
        // user events to the UI
        //accountStatusEventListeners = [AccountStatusEventListener]()
        
        //ref = nil // LESSON LEARNED - don't set this to nil unless you see where we're using this in this class
        // Setting this to nil created a bug on signout that was only apparent when they tried to sign back in.
        // The user wouldn't see "My Mission" or "Directors" or "Admins" and they couldn't switch teams because this
        // DatabaseReference object was not being re-instantiated.  The user would have to swipe the app out of the
        // background AFTER logging out in order for this init() in this class to be called again.
        
        rolesAlreadyFetched = false
//        noRoleAssignedDelegate = nil
        
        // both are reset to nil in WrapUpViewController.submitWrapUp()
        currentMissionItem = nil
        currentMissionItem2 = nil
        
        current_video_node_key = nil
    }
    
    
}
