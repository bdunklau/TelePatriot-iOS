//
//  File.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 8/7/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

class VideoEvent {
    
    // don't need to know the key yet
    var uid : String
    var name : String
    var video_node_key : String
    var room_id : String?
    var RoomSid : String? // use same name as twilio
    var MediaUri : String? // use same name as twilio
    var video_invitation_key : String?
    var video_invitation_extended_to : String?
    var request_type : String
    // no need for date on the client side, let the server side handle that with a trigger - less code on the client

    init(/*user: TPUser,*/ uid: String, name: String, video_node_key: String, room_id: String, request_type: String, RoomSid: String?, MediaUri: String?) {
        self.uid = uid
        self.name = name
        self.video_node_key = video_node_key
        self.room_id = room_id
        self.request_type = request_type
        self.RoomSid = RoomSid
        self.MediaUri = MediaUri
    }
    
    func save() {
        let id:String = Database.database().reference().child("video/video_events").childByAutoId().key!
        print("video/video_events/\(id)")
        Database.database().reference().child("video/video_events").child(id).setValue(dictionary())
    }
    
    private func dictionary() -> [String:Any] {
        return [
            "uid": uid,
            "name": name,
            "video_node_key": video_node_key,
            "room_id": room_id as Any,
            "RoomSid": RoomSid as Any,
            "MediaUri": MediaUri as Any,
            "request_type": request_type,
            "video_invitation_key": video_invitation_key as Any,
            "video_invitation_extended_to": video_invitation_extended_to as Any
            // no need to pass date from the client side, let the server side handle that with a trigger - less code on the client
        ]
    }
}
