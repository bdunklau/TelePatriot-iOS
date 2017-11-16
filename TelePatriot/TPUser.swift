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
    
    private init() {
        ref = Database.database().reference().child("users")
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
        theref.child(uid).child("roles").observe(.childAdded, with: {(snapshot) in
            
            print("==============================")
            print("snapshot is...")
            print(snapshot)
            print("snapshot.value is...")
            print(snapshot.value)
            
            print("check for success 1")
            if let role = snapshot.key as? String {
                print("success 1")
                let val = snapshot.value as? String
                if (role == "Admin" && val?.lowercased() == "true") {
                    self.isAdmin = true
                    self.roleAssigned(role: "Admin")
                }
                
                if (role == "Director" && val?.lowercased() == "true") {
                    self.isDirector = true
                    self.roleAssigned(role: "Director")
                }
                
                if (role == "Volunteer" && val?.lowercased() == "true") {
                    self.isVolunteer = true
                    self.roleAssigned(role: "Volunteer")
                }
            
            }
            print("did we see success")
            
            
            
            
            
        }, withCancel: nil) // not sure what withCancel:nil does.  I know it's saying "no callback".  But when would we cancel this action?
    }
    
    func roleAssigned(role: String) {
        // tell all the listeners that a role was assigned.  This is for LimboViewController, to tell it that
        // we can now send the user back to HomeViewController
        for l in accountStatusEventListeners {
            l.roleAssigned(role: role)
        }
    }
    
    /**
    public getPhotoURL() {
        guard let photoURL =
    }
    ****/
}
