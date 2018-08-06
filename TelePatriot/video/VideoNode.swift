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
    
    var video_participants = [String:VideoParticipant]()
    
    var video_type : String?
    var video_id : String?
    var video_title : String?
    var youtube_video_description : String?
    var youtube_video_description_unevaluated : String?
    
    var video_mission_description : String
    var recording_started : String?
    var recording_started_ms : Int64?
    var recording_stopped : String?
    var recording_stopped_ms : Int64?
    
    var legislator : Legislator?
    
    var video_invitation_key : String?
    var video_invitation_extended_to : String? // someone's name
    
    // The "What do you want to do with your video" fields...
    // all true by default and the user can set them to false in the VidyoChatFragment if he doesn't like them
    var email_to_legislator = true;
    var post_to_facebook = true;
    var post_to_twitter = true;
    
    // custom init method
    init(creator: TPUser, type: VideoType?) {
        node_create_date = Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
        node_create_date_ms = Util.getDate_as_millis()
        video_participants[creator.getUid()] = VideoParticipant(user: creator)
        if let t = type {
            video_type = t.type
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
    init(snapshot: DataSnapshot, vc: VideoChatVC /*refactor VideoChatVC into a delegate if we ever need some other 'listener'*/ ) {
        if let video_node_key = snapshot.key as? String {
            key = video_node_key
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
            
            if let vps = dictionary["video_participants"] as? [String:[String:Any]] {
                video_participants = VideoParticipant.parseParticipants(list: vps)
            }
            // no else required, the list is initialized not nil and empty
            
            if let vt = dictionary["video_type"] as? String {
                video_type = vt
            }
            
            if let yu = dictionary["video_id"] as? String {
                video_id = yu
                vc.publishingStarted()
            }
            
            /****
             Sample email subject: Video message from a constituent, Brent Dunklau
             Sample video title:  Video Petition to Rep Justin Holland (TX HD 33) from Constituent Brent Dunklau
                "Video Petition" = /video/types/{key}/type
                "Rep" - based on chamber
                "Justin Holland" - probably first + last because fullname is sometimes last, first
                "TX" - state_abbrev to upper case
                "HD" - based on chamber
                "33" - district_number
                "Brent Dunklau" - if there are 2 participants, assume the second one
            ****/
            if let yvt = dictionary["video_title"] as? String {
                video_title = yvt
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
            
            if let vrbd = dictionary["recording_started"] as? String {
                recording_started = vrbd
                vc.recordingStarted()
            }
            
            if let vrbdm = dictionary["recording_started_ms"] as? Int64 {
                recording_started_ms = vrbdm
            }
            
            if let vred = dictionary["recording_stopped"] as? String {
                recording_stopped = vred
            }
            
            if let vredm = dictionary["recording_stopped_ms"] as? Int64 {
                recording_stopped_ms = vredm
            }
            
            // don't create the legislator object if this attribute doesn't exist
            if let _ = dictionary["legislator_full_name"] as? String {
                legislator = Legislator(data: dictionary)
            }
            
            if let vik = dictionary["video_invitation_key"] as? String {
                video_invitation_key = vik
                
                if let vie = dictionary["video_invitation_extended_to"] as? String {
                    video_invitation_extended_to = vie
                    vc.videoInvitationExtended(name: vie)
                }
                else {
                    vc.videoInvitationExtended(name: "someone") // this doesn't make much sense and indicates an erroneous error state
                }
            }
            else {
                vc.videoInvitationNotExtended()
            }
            
            if let x = dictionary["email_to_legislator"] as? Bool {
                email_to_legislator = x
            }
            
            if let x = dictionary["post_to_facebook"] as? Bool {
                post_to_facebook = x
            }
            
            if let x = dictionary["post_to_twitter"] as? Bool {
                post_to_twitter = x
            }
            
            
         }
        else {
            node_create_date = "-"
            node_create_date_ms = 0
            video_mission_description = "-"
        }
    }
    
    
    func bothParticipantsPresent() -> Bool {
        var count = 0
        for vp in video_participants {
            if vp.value.present {
                count += 1
            }
        }
        return count == 2
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
            "video_type": video_type,
            "video_id": video_id,
            "youtube_video_description": youtube_video_description,
            "youtube_video_description_unevaluated": youtube_video_description_unevaluated,
            "video_mission_description": video_mission_description,
            "video_recording_begin_date": recording_started,
            "video_recording_begin_date_ms": recording_started_ms,
            "video_recording_end_date": recording_stopped,
            "video_recording_end_date_ms": recording_stopped_ms,
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
            "legislator_phone" : legislator?.phone,
            "video_invitation_key" : video_invitation_key,
            "email_to_legislator" : email_to_legislator,
            "post_to_facebook" : post_to_facebook,
            "post_to_twitter" : post_to_twitter
        ]
    }
    
    // returns an array/collection of dictionaries
    private func dictionaries(list: [String: VideoParticipant]) -> [String: Any] {
        var dictionaries = [String: Any]()
        for key in list.keys {
            if let vp = list[key] {
                dictionaries[vp.uid] = vp.dictionary()
            }
        }
        return dictionaries
    }
}
