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
    
    private init() {
        ref = Database.database().reference()
    }
    
    func setUser(u: User?) {
        // only set the user object if it's not set already
        // If you want to logout/login as someone else, we need to UN-set this user first
        //  ...just my rule
        guard let usr = user else {
            user = u
            fetchRoles(uid: getUid())
            return
        }
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
    
    func fetchRoles(uid: String) {
        if(rolesAlreadyFetched) { return }
        
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
            print("name = \(name)") // <--- just FYI
            print("val = \(val)")
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
    
    /**
    public getPhotoURL() {
        guard let photoURL =
    }
    ****/
}
