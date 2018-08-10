//
//  VideoInvitation.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 6/9/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

class VideoInvitation {
    
    // person being invited
    //var guest : TPUser
    var guest_id : String?
    var guest_name : String?
    var guest_email : String?
    var guest_photo_url : String?
    
    // person who sent the invitation
    //var initiator : TPUser
    var initiator_id : String?
    var initiator_name : String?
    var initiator_email : String?
    var initiator_photo_url : String?
    
    // time the invitation was sent
    // time_ms the invitation was sent
    var invitation_create_date : String?
    var invitation_create_date_ms : Int64?
    
    // room (the video_node_key)
    var room_id : String?
    
    // time room was entered by initiator
    var initiator_enter_room_date : String?
    
    // time_ms room was entered by initiator
    var initiator_enter_room_date_ms : Int64?
    
    // time room was entered by guest
    var guest_enter_room_date : String?
    
    // time_ms room was entered by guest
    var guest_enter_room_date_ms : Int64?
    
    var video_node_key : String?
    
    var key : String? // the key/primary key of the node
    
    init(creator: TPUser, guest: TPUser, video_node_key: String) {
        initiator_id = creator.getUid()
        initiator_name = creator.getName()
        initiator_email = creator.getEmail()
        initiator_photo_url = creator.getPhotoURL().absoluteString
        invitation_create_date = Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
        invitation_create_date_ms = Util.getDate_as_millis()
        room_id = video_node_key
        guest_id = guest.getUid()
        guest_name = guest.getName()
        guest_email = guest.getEmail()
        guest_photo_url = guest.getPhotoURL().absoluteString
        self.video_node_key = video_node_key
    }
    
    func updateWith(invitation: VideoInvitation) {
        guest_id = invitation.guest_id
        guest_name = invitation.guest_name
        guest_email = invitation.guest_email
        guest_photo_url = invitation.guest_photo_url
        initiator_id = invitation.initiator_id
        initiator_name = invitation.initiator_name
        initiator_email = invitation.initiator_email
        initiator_photo_url = invitation.initiator_photo_url
        invitation_create_date = invitation.invitation_create_date
        invitation_create_date_ms = invitation.invitation_create_date_ms
        room_id = invitation.room_id
        initiator_enter_room_date = invitation.initiator_enter_room_date
        initiator_enter_room_date_ms = invitation.initiator_enter_room_date_ms
        guest_enter_room_date = invitation.guest_enter_room_date
        guest_enter_room_date_ms = invitation.guest_enter_room_date_ms
        video_node_key = invitation.video_node_key
        key = invitation.key
        
    }
    
    init(snapshot: DataSnapshot) {
        guard let dictionary = snapshot.value as? [String : Any] else {
            return
        }
        key = snapshot.key
        if let val = dictionary["guest_id"] as? String {
            guest_id = val
        }
        if let val = dictionary["guest_name"] as? String {
            guest_name = val
        }
        if let val = dictionary["guest_email"] as? String {
            guest_email = val
        }
        if let val = dictionary["guest_photo_url"] as? String {
            guest_photo_url = val
        }
        if let val = dictionary["initiator_id"] as? String {
            initiator_id = val
        }
        if let val = dictionary["initiator_name"] as? String {
            initiator_name = val
        }
        if let val = dictionary["initiator_email"] as? String {
            initiator_email = val
        }
        if let val = dictionary["initiator_photo_url"] as? String {
            initiator_photo_url = val
        }
        if let val = dictionary["invitation_create_date"] as? String {
            invitation_create_date = val
        }
        if let val = dictionary["invitation_create_date_ms"] as? Int64 {
            invitation_create_date_ms = val
        }
        if let val = dictionary["room_id"] as? String {
            room_id = val
        }
        if let val = dictionary["initiator_enter_room_date"] as? String {
            initiator_enter_room_date = val
        }
        if let val = dictionary["initiator_enter_room_date_ms"] as? Int64 {
            initiator_enter_room_date_ms = val
        }
        if let val = dictionary["guest_enter_room_date"] as? String {
            guest_enter_room_date = val
        }
        if let val = dictionary["guest_enter_room_date_ms"] as? Int64 {
            guest_enter_room_date_ms = val
        }
        if let val = dictionary["video_node_key"] as? String {
            video_node_key = val
        }
    }
    
    static func createInvitations(snapshot: DataSnapshot) -> [VideoInvitation] {
        var invitations = [VideoInvitation]()
        let children = snapshot.children
        var counter = 0
        while let snap = children.nextObject() as? DataSnapshot {
            let invitation = VideoInvitation(snapshot: snap)
            invitations.append(invitation)
        }
        return invitations
    }
    
    func save() -> String? {
        if let initiator_id = initiator_id, let guest_id = guest_id {
            let key = "initiator\(initiator_id)guest\(guest_id)"
            Database.database().reference().child("video/invitations/\(key)").setValue(dictionary())
            return key
        }
        return nil
    }
    
    private func dictionary() -> [String: Any] {
        var dict : [String:Any] = [
            "invitation_create_date": invitation_create_date,
            "invitation_create_date_ms": invitation_create_date_ms,
            "initiator_id": initiator_id,
            "initiator_name": initiator_name,
            "initiator_photo_url": initiator_photo_url,
            "initiator_email": initiator_email,
            "guest_id": guest_id,
            "guest_name": guest_name,
            "guest_photo_url": guest_photo_url,
            "guest_email": guest_email,
            "room_id": room_id,
            "video_node_key": video_node_key
        ]
        
        if let ierd = initiator_enter_room_date {
            dict["initiator_enter_room_date"] = ierd
        }
        
        if let ierdm = initiator_enter_room_date_ms {
            dict["initiator_enter_room_date_ms"] = ierdm
        }
        
        if let gerd = guest_enter_room_date {
            dict["guest_enter_room_date"] = gerd
        }
        
        if let gerdm = guest_enter_room_date_ms {
            dict["guest_enter_room_date_ms"] = gerdm
        }
        
        return dict
        
    }
    
    func delete() {
        if let video_node_key = video_node_key,
            let guest_id = guest_id,
            let key = key {
            
            let updates = [
                "video/list/\(video_node_key)/video_invitation_key":  nil,
                "video/list/\(video_node_key)/video_invitation_extended_to":  nil,
                "video/list/\(video_node_key)/video_participants/\(guest_id)":  nil,
                "video/invitations/\(key)":  nil,
                "users/\(guest_id)/current_video_node_key":  nil,
            ] as [String : Any?]
            
            Database.database().reference().updateChildValues(updates)
        }
    }
    
    func decline() {
        delete()
    }
    
    func accept() {
        if let video_node_key = video_node_key {
            TPUser.sharedInstance.setCurrent_video_node_key(current_video_node_key: video_node_key)
            
            var updates : [String:Any] = [:]
            // if user already has a current video node, set 'present' on that node to false
            if let vk = TPUser.sharedInstance.current_video_node_key {
                updates["video/list/\(vk)/video_participants/\(TPUser.sharedInstance.getUid())/present"] = false
            }
            
            let vp = VideoParticipant(user: TPUser.sharedInstance)
            for (key, value) in vp.dictionary() {
                updates["video/list/\(video_node_key)/video_participants/\(TPUser.sharedInstance.getUid())/\(key)"] = value
            }
            // triggers creating of vidyo token...
            updates["video/list/\(video_node_key)/video_participants/\(TPUser.sharedInstance.getUid())/present"] = true
            updates["video/list/\(video_node_key)/video_participants/\(TPUser.sharedInstance.getUid())/vidyo_token_requested"] = true
            
            updates["video/list/\(video_node_key)/room_id"] = room_id
            Database.database().reference().updateChildValues(updates)
        }
    }
}
