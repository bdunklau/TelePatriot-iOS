//
//  VideoNode.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 4/4/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

// represents an actual node under /videos
class VideoNode {
    
    var node_create_date : String
    var node_create_date_ms : Int64
    
    var video_participants = [VideoParticipant]()
    
    var youtube_url : String?
    var youtube_video_description : String?
    
    var video_mission_description : String
    var video_recording_begin_date : String?
    var video_recording_begin_date_ms : Int64?
    var video_recording_end_date : String?
    var video_recording_end_date_ms : Int64?
    
    var legislator_name : String?
    var legislator_title : String? // Rep, Sen
    var legislator_state : String? // state abbrev
    var legislator_district_type: String? // HD, SD
    var legislator_district: String? // usually just a number
    var legislator_cos_position : String?
    var legislator_facebook : String?
    var legislator_twitter : String?
    var legislator_email : String?
    var legislator_phone : String?
    
    // custom init method
    init(creator: TPUser, type: VideoType) {
        node_create_date = Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
        node_create_date_ms = Util.getDate_as_millis()
        video_participants.append(VideoParticipant(user: creator))
        video_mission_description = type.video_mission_description
    }
    
    func save() {
        Database.database().reference().child("video/list").childByAutoId().setValue(dictionary())
    }
    
    
    func dictionary() -> [String: Any] {
        return [
            "node_create_date": node_create_date,
            "node_create_date_ms": node_create_date_ms,
            "video_participants": dictionaries(list: video_participants),
            "youtube_url": youtube_url,
            "youtube_video_description": youtube_video_description,
            "video_mission_description": video_mission_description,
            "video_recording_begin_date": video_recording_begin_date,
            "video_recording_begin_date_ms": video_recording_begin_date_ms,
            "video_recording_end_date": video_recording_end_date,
            "video_recording_end_date_ms": video_recording_end_date_ms,
            "legislator_name" : legislator_name,
            "legislator_title" : legislator_title,
            "legislator_state" : legislator_state,
            "legislator_district" : legislator_district,
            "legislator_district_type" : legislator_district_type, // HD, SD
            "legislator_cos_position" : legislator_cos_position,
            "legislator_facebook" : legislator_facebook,
            "legislator_twitter" : legislator_twitter,
            "legislator_email" : legislator_email,
            "legislator_phone" : legislator_phone
        ]
    }
    
    // returns an array/collection of dictionaries
    private func dictionaries(list: [VideoParticipant]) -> [[String: Any]] {
        var dictionaries = [Dictionary<String, Any>]()
        for item in list {
            dictionaries.append(item.dictionary())
        }
        return dictionaries
    }
}
