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
    
    var email_to_legislator_body: String?
    var email_to_legislator_body_unevaluated: String?
    var email_to_legislator_subject: String?
    var email_to_legislator_subject_unevaluated: String?
    var email_to_participant_body: String?
    var email_to_participant_body_unevaluated: String?
    var email_to_participant_subject: String?
    var email_to_participant_subject_unevaluated: String?
    var email_to_legislator_send_date: String?
    var email_to_legislator_send_date_ms: Int64?
    var email_to_participant_send_date: String?
    var email_to_participant_send_date_ms: Int64?
    var facebook_post_id: String?
    var room_id : String?
    var room_sid_record : String?
    var room_sid : String? // the twilio RoomSid
    
    var recording_requested : Bool? // See google-cloud:dockerRequest - for the spinner while the recorder is starting up
    var recording_started : String?
    var recording_started_ms : Int64?
    var recording_stopped : String?
    var recording_stopped_ms : Int64?
    var recording_completed = false
    var twitter_post_id: String?
    var video_type : String?
    var video_id : String?
    var video_title : String?
    var youtube_video_description : String?
    var youtube_video_description_unevaluated : String?
    var video_mission_description : String
    
    var legislator : Legislator?
    
    var video_invitation_key : String?
    var video_invitation_extended_to : String? // someone's name
    
    // The "What do you want to do with your video" fields...
    // all true by default and the user can set them to false in the VidyoChatFragment if he doesn't like them
    var email_to_legislator = true;
    var post_to_facebook = true;
    var post_to_twitter = true;
    
    // These attributes are sent back to us from twilio.  Twilio calls twilioCallback() in twilio-telepatriot.js
    // see video/video_events and /testViewVideoEvents
    var composition_PercentageDone : Int?
    var composition_SecondsRemaining : Int?
    var composition_MediaUri : String?
    var CompositionSid : String?
    var CompositionUri : String?
    var composition_Size : Int64?
    
    
    
    // custom init method
    init(creator: TPUser, type: VideoType?) {
        node_create_date = Util.getDate_Day_MMM_d_hmmss_am_z_yyyy()
        node_create_date_ms = Util.getDate_as_millis()
        video_participants[creator.getUid()] = VideoParticipant(user: creator)
        if let t = type {
            video_type = t.type
            
            email_to_legislator_body = t.email_to_legislator_body
            email_to_legislator_body_unevaluated = t.email_to_legislator_body
            email_to_legislator_subject = t.email_to_legislator_subject
            email_to_legislator_subject_unevaluated = t.email_to_legislator_subject
            email_to_participant_body = t.email_to_participant_body
            email_to_participant_body_unevaluated = t.email_to_participant_body
            email_to_participant_subject = t.email_to_participant_subject
            email_to_participant_subject_unevaluated = t.email_to_participant_subject
            
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
    
    // also have to update VideoChatInstructionsView.setVideoNode()
    // to actually make the new field data appear on the screen
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
            
            if let val = dictionary["recording_requested"] as? Bool {
                recording_requested = val
            }
            
            if let val = dictionary["room_id"] as? String {
                room_id = val
            }
            
            if let val = dictionary["room_sid_record"] as? String {
                room_sid_record = val
            }
            
            if let val = dictionary["room_sid"] as? String {
                room_sid = val
            }
            
            if let vrbd = dictionary["recording_started"] as? String {
                recording_started = vrbd
                //vc.recordingStarted()
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
            
            if let x = dictionary["recording_completed"] as? Bool {
                recording_completed = x
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
            
            if let x = dictionary["facebook_post_id"] as? String {
                facebook_post_id = x
            }
            
            if let x = dictionary["twitter_post_id"] as? String {
                twitter_post_id = x
            }
            
            if let x = dictionary["composition_PercentageDone"] as? String {
                composition_PercentageDone = Int(x)
            }
            
            if let x = dictionary["composition_SecondsRemaining"] as? String {
                composition_SecondsRemaining = Int(x)
            }
            
            if let x = dictionary["composition_MediaUri"] as? String {
                composition_MediaUri = x
            }
            
            if let x = dictionary["CompositionUri"] as? String {
                CompositionUri = x
            }
            
            if let x = dictionary["CompositionSid"] as? String {
                CompositionSid = x
            }
            
            if let x = dictionary["composition_Size"] as? Int64 {
                composition_Size = x
            }
            
            if let x = dictionary["email_to_legislator_body"] as? String {
                email_to_legislator_body = x
            }
            
            if let x = dictionary["email_to_legislator_subject"] as? String {
                email_to_legislator_subject = x
            }
            
            if let x = dictionary["email_to_legislator_subject_unevaluated"] as? String {
                email_to_legislator_subject_unevaluated = x
            }
            
            if let x = dictionary["email_to_legislator_body_unevaluated"] as? String {
                email_to_legislator_body_unevaluated = x
            }
            
            if let x = dictionary["email_to_participant_body"] as? String {
                email_to_participant_body = x
            }
            
            if let x = dictionary["email_to_participant_body_unevaluated"] as? String {
                email_to_participant_body_unevaluated = x
            }
            
            if let x = dictionary["email_to_participant_subject"] as? String {
                email_to_participant_subject = x
            }
            
            if let x = dictionary["email_to_participant_subject_unevaluated"] as? String {
                email_to_participant_subject_unevaluated = x
            }
            
            if let x = dictionary["email_to_legislator_send_date"] as? String {
                email_to_legislator_send_date = x
            }
            
            if let x = dictionary["email_to_legislator_send_date_ms"] as? Int64 {
                email_to_legislator_send_date_ms = x
            }
            
            if let x = dictionary["email_to_participant_send_date"] as? String {
                email_to_participant_send_date = x
            }
            
            if let x = dictionary["email_to_participant_send_date_ms"] as? Int64 {
                email_to_participant_send_date_ms = x
            }
            
            // also have to update VideoChatInstructionsView.setVideoNode()
            // to actually make the new field data appear on the screen
            
            
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
            key = reference.key
            room_id = key
            reference.setValue(dictionary())
            return key!
        }
    }
    
    // also have to update VideoChatInstructionsView.setVideoNode()
    // to actually make the new field data appear on the screen
    func dictionary() -> [String: Any] {
        return [
            "email_to_legislator_body": email_to_legislator_body,
            "email_to_legislator_body_unevaluated": email_to_legislator_body_unevaluated,
            "email_to_legislator_subject": email_to_legislator_subject,
            "email_to_legislator_subject_unevaluated": email_to_legislator_subject_unevaluated,
            "email_to_participant_body": email_to_participant_body,
            "email_to_participant_body_unevaluated": email_to_participant_body_unevaluated,
            "email_to_participant_subject": email_to_participant_subject,
            "email_to_participant_subject_unevaluated": email_to_participant_subject_unevaluated,
            "email_to_legislator_send_date": email_to_legislator_send_date,
            "email_to_legislator_send_date_ms": email_to_legislator_send_date_ms,
            "email_to_participant_send_date": email_to_participant_send_date,
            "email_to_participant_send_date_ms": email_to_participant_send_date_ms,
            "node_create_date": node_create_date,
            "node_create_date_ms": node_create_date_ms,
            "video_participants": dictionaries(list: video_participants) as Any,
            "video_type": video_type as Any,
            "video_id": video_id as Any,
            "youtube_video_description": youtube_video_description as Any,
            "youtube_video_description_unevaluated": youtube_video_description_unevaluated as Any,
            "video_mission_description": video_mission_description,
            "recording_started": recording_started as Any,
            "recording_started_ms": recording_started_ms as Any,
            "recording_stopped": recording_stopped as Any,
            "recording_stopped_ms": recording_stopped_ms as Any,
            "recording_completed": recording_completed as Any,
            "room_id": room_id as Any,
            "room_sid_record": room_sid_record as Any,
            "room_sid": room_sid as Any,
            "legislator_name" : legislator?.full_name as Any,
            //"legislator_title" : legislator_title as Any,
            "leg_id" : legislator?.leg_id as Any,
            "legislator_state" : legislator?.state as Any,
            "legislator_district" : legislator?.district as Any,
            "legislator_chamber" : legislator?.chamber as Any,
            "legislator_cos_position" : legislator?.legislator_cos_position as Any,
            "legislator_facebook" : legislator?.legislator_facebook as Any,
            "legislator_facebook_id" : legislator?.legislator_facebook_id as Any,
            "legislator_twitter" : legislator?.legislator_twitter as Any,
            "legislator_email" : legislator?.email as Any,
            "legislator_phone" : legislator?.phone as Any as Any,
            "video_invitation_key" : video_invitation_key as Any,
            "email_to_legislator" : email_to_legislator,
            "post_to_facebook" : post_to_facebook,
            "post_to_twitter" : post_to_twitter,
            "composition_PercentageDone" : composition_PercentageDone as Any,
            "composition_SecondsRemaining" : composition_SecondsRemaining as Any,
            "composition_MediaUri" : composition_MediaUri as Any,
            "CompositionSid" : CompositionSid as Any
        ]
    }
    
    func recordingHasNotStarted() -> Bool {
        return recording_started == nil
    }
    
    func recordingHasStarted() -> Bool {
        return recording_started != nil && recording_stopped == nil
    }
    
    func recordingHasStopped() -> Bool {
        return recording_started != nil && recording_stopped != nil
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
    
    func getParticipant(uid: String) -> VideoParticipant? {
        return video_participants[uid]
    }
    
}
