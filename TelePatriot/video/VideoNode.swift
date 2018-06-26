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
    
    private var key : String? // private - use getKey() to get this
    var node_create_date : String
    var node_create_date_ms : Int64
    
    var video_participants = [VideoParticipant]()
    
    var youtube_url : String?
    var youtube_video_description : String?
    var youtube_video_description_unevaluated : String?
    
    var video_mission_description : String
    var video_recording_begin_date : String?
    var video_recording_begin_date_ms : Int64?
    var video_recording_end_date : String?
    var video_recording_end_date_ms : Int64?
    
    var legislator : Legislator?
    
    // custom init method
    init(creator: TPUser, type: VideoType?) {
        node_create_date = Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
        node_create_date_ms = Util.getDate_as_millis()
        video_participants.append(VideoParticipant(user: creator))
        if let t = type {
            video_mission_description = t.video_mission_description
            youtube_video_description = t.youtube_video_description
            youtube_video_description_unevaluated = t.youtube_video_description
        }
        else {
            video_mission_description = "Touch Edit to enter info about this video"
            youtube_video_description = "Touch Edit to enter the YouTube video description"
        }
        let data = [String:Any]()
        legislator = Legislator(data: data)
    }
    
    // See also EditLegislatorForVideoVC.legislatorSelected()
    init(snapshot: DataSnapshot) {
        if let video_node_id = snapshot.key as? String {
            key = video_node_id
        }
        
        if let dictionary = snapshot.value as? [String : Any] {
            if let ncd = dictionary["node_create_date"] as? String {
                node_create_date = ncd
            }
            else { node_create_date = "-" }
            
            if let ncdm = dictionary["node_create_date_ms"] as? Int64 {
                node_create_date_ms = ncdm
            }
            else { node_create_date_ms = 0 }
            
            if let vps = dictionary["video_participants"] as? [[String:Any]] {
                video_participants = VideoParticipant.parseParticipants(list: vps)
            }
            // no else required, the list is initialized not nil and empty
            
            if let yu = dictionary["youtube_url"] as? String {
                youtube_url = yu
            }
            
            if let yvd = dictionary["youtube_video_description"] as? String {
                youtube_video_description = yvd
            }
            
            if let yvdu = dictionary["youtube_video_description_unevaluated"] as? String {
                youtube_video_description_unevaluated = yvdu
            }
            
            if let vmd = dictionary["video_mission_description"] as? String {
                video_mission_description = vmd
            }
            else { video_mission_description = "-" }
            
            if let vrbd = dictionary["video_recording_begin_date"] as? String {
                video_recording_begin_date = vrbd
            }
            
            if let vrbdm = dictionary["video_recording_begin_date_ms"] as? Int64 {
                video_recording_begin_date_ms = vrbdm
            }
            
            if let vred = dictionary["video_recording_end_date"] as? String {
                video_recording_end_date = vred
            }
            
            if let vredm = dictionary["video_recording_end_date_ms"] as? Int64 {
                video_recording_end_date_ms = vredm
            }
            
            // don't create the legislator object if this attribute doesn't exist
            if let _ = dictionary["legislator_full_name"] as? String {
                legislator = Legislator(data: dictionary)
            }
            
         }
        else {
            node_create_date = "-"
            node_create_date_ms = 0
            video_mission_description = "-"
        }
    }
    
    
    func getKey() -> String {
        if let key = key {
            return key
        }
        else {
            // this is how you get the auto-generated key
            let reference = Database.database().reference().child("video/list").childByAutoId()
            reference.setValue(dictionary())
            key = reference.key
            return key!
        }
    }
    
    func dictionary() -> [String: Any] {
        return [
            "node_create_date": node_create_date,
            "node_create_date_ms": node_create_date_ms,
            "video_participants": dictionaries(list: video_participants),
            "youtube_url": youtube_url,
            "youtube_video_description": youtube_video_description,
            "youtube_video_description_unevaluated": youtube_video_description_unevaluated,
            "video_mission_description": video_mission_description,
            "video_recording_begin_date": video_recording_begin_date,
            "video_recording_begin_date_ms": video_recording_begin_date_ms,
            "video_recording_end_date": video_recording_end_date,
            "video_recording_end_date_ms": video_recording_end_date_ms,
            "legislator_name" : legislator?.full_name,
            //"legislator_title" : legislator_title,
            "leg_id" : legislator?.leg_id,
            "legislator_state" : legislator?.state,
            "legislator_district" : legislator?.district,
            "legislator_chamber" : legislator?.chamber,
            "legislator_cos_position" : legislator?.legislator_cos_position,
            "legislator_facebook" : legislator?.legislator_facebook,
            "legislator_facebook_id" : legislator?.legislator_facebook_id,
            "legislator_twitter" : legislator?.legislator_twitter,
            "legislator_email" : legislator?.email,
            "legislator_phone" : legislator?.phone
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
