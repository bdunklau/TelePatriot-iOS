//
//  File.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 4/5/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

// models a node under /video/types
class VideoType {
    
    var type: String
    var video_mission_description: String
    
    init(type: String, video_mission_description: String) {
        self.type = type
        self.video_mission_description = video_mission_description
    }
    
    
    // modeled after MissionSummaryTVC.getMissionSummaryFromSnapshot()
    // called from AppDelegate
    static func getVideoTypeFrom(snapshot: DataSnapshot) -> VideoType? {
        
        guard let video_type_id = snapshot.key as? String else {
            return nil
        }
        
        guard let dictionary = snapshot.value as? [String : Any],
            let type = dictionary["type"] as? String,
            let video_mission_description = dictionary["video_mission_description"] as? String
                else {
                    return nil
        }
        
        return VideoType(type: type, video_mission_description: video_mission_description)
        
    }
}
