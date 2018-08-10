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
    var user : TPUser
    var video_node_key : String
    var room_id : String
    var request_type : String
    // no need for date on the client side, let the server side handle that with a trigger - less code on the client

    init(user: TPUser, video_node_key: String, room_id: String, request_type: String) {
        self.user = user
        self.video_node_key = video_node_key
        self.room_id = room_id
        self.request_type = request_type
    }
    
    func save() {
        Database.database().reference().child("video/video_events").childByAutoId().setValue(dictionary())
    }
    
    private func dictionary() -> [String:Any] {
        return [
            "uid": user.getUid(),
            "name": user.getName(),
            "video_node_key": video_node_key,
            "room_id": room_id,
            "request_type": request_type
            // no need to pass date from the client side, let the server side handle that with a trigger - less code on the client
        ]
    }
}
