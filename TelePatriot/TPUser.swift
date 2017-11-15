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
    /****
    var name : String
    var email : String
    var uid : String
   ****/
    
    private init() {
    }
    
    func setUser(u: User?) {
        user = u
        fetchRoles(uid: getUid())
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
        Database.database().reference().child("users").child(uid).child("roles").observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String : String] {
                // ref:  https://stackoverflow.com/a/28129484
                if let adm = dictionary["Admin"] {
                    // now adm is not nil and the Optional has been unwrapped, so use it
                    if adm.lowercased() == "true" { self.isAdmin = true }
                }
                else if let dir = dictionary["Director"] {
                    if dir.lowercased() == "true" { self.isDirector = true }
                }
                else if let vol = dictionary["Volunteer"] {
                    if vol.lowercased() == "true" { self.isVolunteer = true }
                }
            }
            
        }, withCancel: nil) // not sure what withCancel:nil does.  I know it's saying "no callback".  But when would we cancel this action?
    }
    
    /**
    public getPhotoURL() {
        guard let photoURL =
    }
    ****/
}
