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
    
    
    var email_to_legislator_body: String
    var email_to_legislator_subject: String
    var email_to_participant_body: String
    var email_to_participant_subject: String
    var type: String
    var video_mission_description: String
    var youtube_video_description: String
    
    init(
        email_to_legislator_body: String,
        email_to_legislator_subject: String,
        email_to_participant_body: String,
        email_to_participant_subject: String,
        type: String,
        video_mission_description: String,
        youtube_video_description: String) {
        
        self.email_to_legislator_body = email_to_legislator_body
        self.email_to_legislator_subject = email_to_legislator_subject
        self.email_to_participant_body = email_to_participant_body
        self.email_to_participant_subject = email_to_participant_subject
        self.type = type
        self.video_mission_description = video_mission_description
        self.youtube_video_description = youtube_video_description
    }
    
    
    // modeled after MissionSummaryTVC.getMissionSummaryFromSnapshot()
    // called from AppDelegate
    static func getVideoTypeFrom(snapshot: DataSnapshot) -> VideoType? {
        
        guard let video_type_id = snapshot.key as? String else {
            return nil
        }
        
        guard let dictionary = snapshot.value as? [String : Any],
            let email_to_legislator_body = dictionary["email_to_legislator_body"] as? String,
            let email_to_legislator_subject = dictionary["email_to_legislator_subject"] as? String,
            let email_to_participant_body = dictionary["email_to_participant_body"] as? String,
            let email_to_participant_subject = dictionary["email_to_participant_subject"] as? String,
            let type = dictionary["type"] as? String,
            let video_mission_description = dictionary["video_mission_description"] as? String,
            let youtube_video_description = dictionary["youtube_video_description"] as? String
                else {
                    return nil
        }
        
        return VideoType(
                         email_to_legislator_body: email_to_legislator_body,
                         email_to_legislator_subject: email_to_legislator_subject,
                         email_to_participant_body: email_to_participant_body,
                         email_to_participant_subject: email_to_participant_subject,
                         type: type,
                         video_mission_description: video_mission_description,
                         youtube_video_description: youtube_video_description)
        
    }
}
