//
//  VideoChatVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 3/27/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class VideoChatInstructionsView: UIView, UIPopoverPresentationControllerDelegate, EditSocialMediaDelegate
//    , SearchUsersDelegate
{
    
    var databaseRef : DatabaseReference?
    
    var videoNode : VideoNode?
    var legislator : Legislator?
    var editSocialMediaVC : EditSocialMediaVC?
    var videoChatVC : VideoChatVC?
    var editVideoMissionDescriptionVC : EditVideoMissionDescriptionVC?
    var editLegislatorForVideoVC : EditLegislatorForVideoVC?
    
    
    
//    let close_button : BaseButton = {
//        let button = BaseButton(text: "Close")
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(dismissThisScreen(_:)), for: .touchUpInside)
//        return button
//    }()
    
    
    let descriptionLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Description"
        return l
    }()
    
    
    let video_mission_description : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "This is where we describe what kind of video we're shooting.  Is it a Video Petition or something else?  The people shooting the video are going to be reading this to find out."
        return l
    }()
    
    
    let edit_video_mission_description_button : BaseButton = {
        let button = BaseButton(text: "Edit")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editVideoMissionDescription(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let legislatorLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Legislator"
        return l
    }()
    
    
    let edit_legislator_button : BaseButton = {
        let button = BaseButton(text: "Choose")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editLegislator(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let legislatorName : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        // l.text = "Rep Noncommittal Fence Sitter"
        return l
    }()
    
    
    let state : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        //l.text = "TX"
        return l
    }()
    
    
    let chamber : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        //l.text = "HD"
        return l
    }()
    
    
    let district : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        //l.text = "200"
        return l
    }()
    
    
    let facebookButton : UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("FB: -", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openFacebook(_:)), for: .touchUpInside)
        return button
    }()
    
    let editFacebookButton : UIButton = {
        let button = UIButton(type: .system)
        //icons come from material.io/icons
        //button.setImage(UIImage(named: "baseline_edit_black_18dp"), for: .normal)   // set below if legislator exists
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editFacebook(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let twitterButton : UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("TW: -", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openTwitter(_:)), for: .touchUpInside)
        return button
    }()
    
    let editTwitterButton : UIButton = {
        let button = UIButton(type: .system)
        //icons come from material.io/icons
        //button.setImage(UIImage(named: "baseline_edit_black_18dp"), for: .normal) // set below if legislator exists
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editTwitter(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let fbLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        //l.text = "FB:"
        return l
    }()
    
    
    let fbHandle : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        //l.text = "@RepHaventMadeUpMyMind"
        return l
    }()
    
    var fbId : String? // legislator's FB ID
    
    
    let twLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "TW:"
        return l
    }()
    
    
    let twHandle : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "@RepFenceSitter"
        return l
    }()
    
    
    let youtubeVideoDescriptionLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "YouTube Video Description"
        return l
    }()
    
    
    let edit_youtube_video_description_button : BaseButton = {
        let button = BaseButton(text: "Edit")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editYoutubeDescription(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let youtubeVideoDescriptionSubtitle : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "(This is what people will see in the video description field on YouTube)"
        return l
    }()
    
    
    let youtubeVideoDescription : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "A conversation with Xxxxx Xxxxx, a constituent of Rep Fence Sitter, asking the Rep Fence Sitter to support the Convention of States resolution.\n\nSign the petition here: https://www.conventionofstates.com and become part of the solution that's as big as the problem"
        return l
    }()
    
    
    func buildView(editSocialMediaVC: EditSocialMediaVC, videoChatVC: VideoChatVC, editVideoMissionDescriptionVC : EditVideoMissionDescriptionVC,
                   editLegislatorForVideoVC: EditLegislatorForVideoVC) {
    //override func viewDidLoad() {
        //super.viewDidLoad()
        
        self.editSocialMediaVC = editSocialMediaVC
        self.videoChatVC = videoChatVC
        self.editVideoMissionDescriptionVC = editVideoMissionDescriptionVC
        self.editLegislatorForVideoVC = editLegislatorForVideoVC
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView.contentSize = CGSize(width: self.frame.width, height: 1450)
        
        
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(edit_video_mission_description_button)
        edit_video_mission_description_button.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        edit_video_mission_description_button.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 16).isActive = true
        
//        scrollView.addSubview(close_button)
//        close_button.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
//        // the 650 value makes no sense but it works - bug?...
//        close_button.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 650).isActive = true
        
        
        scrollView.addSubview(video_mission_description)
        video_mission_description.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        video_mission_description.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        // this constraint plus this attribute setting above: l.numberOfLines = 0
        // is how we achieve word wrapping inside the scrollview
        video_mission_description.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0.95).isActive = true
        
        scrollView.addSubview(legislatorLabel)
        legislatorLabel.topAnchor.constraint(equalTo: video_mission_description.bottomAnchor, constant: 16).isActive = true
        legislatorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(edit_legislator_button)
        edit_legislator_button.centerYAnchor.constraint(equalTo: legislatorLabel.centerYAnchor, constant: 0).isActive = true
        edit_legislator_button.leadingAnchor.constraint(equalTo: legislatorLabel.trailingAnchor, constant: 16).isActive = true
        
        scrollView.addSubview(legislatorName)
        legislatorName.topAnchor.constraint(equalTo: legislatorLabel.bottomAnchor, constant: 8).isActive = true
        legislatorName.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(state)
        state.bottomAnchor.constraint(equalTo: legislatorName.bottomAnchor, constant: 0).isActive = true
        state.leadingAnchor.constraint(equalTo: legislatorName.trailingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(chamber)
        chamber.bottomAnchor.constraint(equalTo: legislatorName.bottomAnchor, constant: 0).isActive = true
        chamber.leadingAnchor.constraint(equalTo: state.trailingAnchor, constant: 4).isActive = true
        
        scrollView.addSubview(district)
        district.bottomAnchor.constraint(equalTo: legislatorName.bottomAnchor, constant: 0).isActive = true
        district.leadingAnchor.constraint(equalTo: chamber.trailingAnchor, constant: 4).isActive = true
        
        scrollView.addSubview(facebookButton)
        facebookButton.topAnchor.constraint(equalTo: legislatorName.bottomAnchor, constant: 8).isActive = true
        facebookButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(editFacebookButton)
        editFacebookButton.centerYAnchor.constraint(equalTo: facebookButton.centerYAnchor, constant: 0).isActive = true
        editFacebookButton.leadingAnchor.constraint(equalTo: facebookButton.trailingAnchor, constant: 16).isActive = true
        
        scrollView.addSubview(twitterButton)
        twitterButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 8).isActive = true
        twitterButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(editTwitterButton)
        editTwitterButton.centerYAnchor.constraint(equalTo: twitterButton.centerYAnchor, constant: 0).isActive = true
        editTwitterButton.leadingAnchor.constraint(equalTo: twitterButton.trailingAnchor, constant: 16).isActive = true
        
        
        scrollView.addSubview(youtubeVideoDescriptionLabel)
        youtubeVideoDescriptionLabel.topAnchor.constraint(equalTo: twitterButton.bottomAnchor, constant: 16).isActive = true
        youtubeVideoDescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        
        
        scrollView.addSubview(edit_youtube_video_description_button)
        edit_youtube_video_description_button.centerYAnchor.constraint(equalTo: youtubeVideoDescriptionLabel.centerYAnchor, constant: 0).isActive = true
        edit_youtube_video_description_button.leadingAnchor.constraint(equalTo: youtubeVideoDescriptionLabel.trailingAnchor, constant: 8).isActive = true
        
        
        scrollView.addSubview(youtubeVideoDescriptionSubtitle)
        youtubeVideoDescriptionSubtitle.topAnchor.constraint(equalTo: youtubeVideoDescriptionLabel.bottomAnchor, constant: 8).isActive = true
        youtubeVideoDescriptionSubtitle.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        // this constraint plus this attribute setting above: l.numberOfLines = 0
        // is how we achieve word wrapping inside the scrollview
        youtubeVideoDescriptionSubtitle.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0.95).isActive = true
        
        scrollView.addSubview(youtubeVideoDescription)
        youtubeVideoDescription.topAnchor.constraint(equalTo: youtubeVideoDescriptionSubtitle.bottomAnchor, constant: 8).isActive = true
        youtubeVideoDescription.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        // this constraint plus this attribute setting above: l.numberOfLines = 0
        // is how we achieve word wrapping inside the scrollview
        youtubeVideoDescription.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0.95).isActive = true
        
        addSubview(scrollView)
        
        if let videoNode = videoNode {
            setVideoNode(videoNode: videoNode)
        }
        
        /**
         what we need is the key of the video node so that we can do a realtime query using that key
         **/
        
//        let videoNodeKey = getVideoNodeKey()
        
        // TODO left the outer part of the query in VideoChatVC, but inside the query, there's a TODO that says
        // pass the video node object to this class
//        // the initial query...
//        Database.database().reference().child("video/list").child(videoNodeKey).observe(.value, with: {(snapshot) in
//            self.videoNode = VideoNode(snapshot: snapshot)
//            if let vmd = self.videoNode?.video_mission_description { self.video_mission_description.text = vmd }
//            if let legislator = self.videoNode?.legislator {
//                self.editFacebookButton.setImage(UIImage(named: "baseline_edit_black_18dp"), for: .normal)
//                self.editTwitterButton.setImage(UIImage(named: "baseline_edit_black_18dp"), for: .normal)
//                self.legislator = legislator
//                self.legislatorName.text = legislator.full_name
//                self.state.text = legislator.state.uppercased()
//                self.chamber.text = legislator.chamber == "lower" ? "HD" : (legislator.chamber == "upper" ? "SD" : "")
//                self.district.text = legislator.district
//                let fbButtonText = legislator.legislator_facebook=="" ? "FB: -" : "FB: @\(legislator.legislator_facebook)"
//                self.facebookButton.setTitle(fbButtonText, for: .normal)
//                self.fbId = legislator.legislator_facebook_id
//                let twButtonText = legislator.legislator_twitter=="" ? "TW: -" : "TW: @\(legislator.legislator_twitter)"
//                self.twitterButton.setTitle(twButtonText, for: .normal)
//                self.youtubeVideoDescription.text = self.videoNode?.youtube_video_description
//            }
//        })
    }
    
    
    func setVideoNode(videoNode: VideoNode) {
        self.videoNode = videoNode
        self.video_mission_description.text = videoNode.video_mission_description
        if let legislator = videoNode.legislator {
            self.editFacebookButton.setImage(UIImage(named: "baseline_edit_black_18dp"), for: .normal)
            self.editTwitterButton.setImage(UIImage(named: "baseline_edit_black_18dp"), for: .normal)
            self.legislator = legislator
            self.legislatorName.text = legislator.full_name
            self.state.text = legislator.state.uppercased()
            self.chamber.text = legislator.chamber == "lower" ? "HD" : (legislator.chamber == "upper" ? "SD" : "")
            self.district.text = legislator.district
            let fbButtonText = legislator.legislator_facebook=="" ? "FB: -" : "FB: @\(legislator.legislator_facebook)"
            self.facebookButton.setTitle(fbButtonText, for: .normal)
            self.fbId = legislator.legislator_facebook_id
            let twButtonText = legislator.legislator_twitter=="" ? "TW: -" : "TW: @\(legislator.legislator_twitter)"
            self.twitterButton.setTitle(twButtonText, for: .normal)
            self.youtubeVideoDescription.text = self.videoNode?.youtube_video_description
        }
    }
    
    
//    @objc private func dismissThisScreen(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//    }
    
//    private func rid() {
//        searchIcon.removeFromSuperview()
//        find_someone_btn.removeFromSuperview()
//        guest_name.removeFromSuperview()
//    }
//
//    // the opposite of rid()  LOL
//    private func unrid() {
//        remoteViews?.addSubview(searchIcon)
//        searchIcon.trailingAnchor.constraint(equalTo: (remoteViews?.trailingAnchor)!, constant:-16).isActive = true
//        searchIcon.topAnchor.constraint(equalTo: (remoteViews?.topAnchor)!, constant:16).isActive = true
//
//        remoteViews?.addSubview(find_someone_btn)
//        find_someone_btn.centerYAnchor.constraint(equalTo: searchIcon.centerYAnchor, constant:0).isActive = true
//        find_someone_btn.trailingAnchor.constraint(equalTo: searchIcon.leadingAnchor, constant:-8).isActive = true
//
//        // guest_name is filled in at very bottom in userSelected()
//        remoteViews?.addSubview(guest_name)
//        guest_name.leadingAnchor.constraint(equalTo: find_someone_btn.leadingAnchor, constant:-8).isActive = true
//        //guest_name.trailingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant:0).isActive = true
//        guest_name.widthAnchor.constraint(equalTo: (remoteViews?.widthAnchor)!, constant:0.85).isActive = true
//        guest_name.heightAnchor.constraint(equalTo: (remoteViews?.heightAnchor)!, constant:0.5).isActive = true
//        guest_name.topAnchor.constraint(equalTo: find_someone_btn.bottomAnchor, constant:24).isActive = true
//    }
//
//    private func getVideoNodeKey() -> String {
//        if let key = TPUser.sharedInstance.current_video_node_key {
//            return key
//        }
//        else {
//            let vn = createVideoNode()
//            TPUser.sharedInstance.setCurrent_video_node_key(current_video_node_key: vn.getKey())
//            return vn.getKey()
//        }
//    }
//
//    private func createVideoNode() -> VideoNode {
//        let appDelegate = getAppDelegate()
//
//        // hardcode for now...
//        let theType = "Video Petition"
//        // appDelegate.videoTypes is created in AppDelegate: func application(_ application: UIApplication, didFinishLaunchingWithOptions...)
//        let videoType = appDelegate.videoTypes.filter{ $0.type == theType }.first
//
//        return VideoNode(creator: TPUser.sharedInstance, type: videoType)
//    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    
    @objc func editFacebook(_ sender: Any) {
        editSocialMedia(legislator: legislator, handle: legislator?.legislator_facebook, handleType: "Facebook")
    }
    
    private func editSocialMedia(legislator: Legislator?, handle: String?, handleType: String?) {
        if let handle = handle,
            let vc = editSocialMediaVC,
            let legislator = legislator
        {
            vc.modalPresentationStyle = .popover
            vc.socialMediaDelegate = self
            vc.handle = handle
            vc.handleType = handleType
            vc.legislator = legislator
            videoChatVC?.present(vc, animated: true, completion:nil)
        }
    }
    
    
    @objc func editTwitter(_ sender: Any) {
        editSocialMedia(legislator: legislator, handle: legislator?.legislator_twitter, handleType: "Twitter")
    }
    
    
    @objc func openFacebook(_ sender: Any) {
        Util.openFacebook(legislator: legislator)
    }
    
    
    @objc func openTwitter(_ sender: Any) {
        Util.openTwitter(legislator: legislator)
    }
    
    // required by EditSocialMediaDelegate
    // probably going to have a lot of code that looks really similar in LegislatorUI because
    // that view also has edit buttons/pencils for facebook and twitter handles
    func socialMediaSaved(data: [String : Any]) {
        guard let type = data["type"] as? String,
            let id = data["id"] as? String,
            var legislator = data["legislator"] as? Legislator
            else { return }
        
        // See the triggers in legislators.js:
        // updateLegislatorSocialMedia, updateVideoNodeSocialMedia, overwriteBadWithGoodData
        
        let userUpdate : [String:Any] = [
            "leg_id": legislator.leg_id,
            "type": type,
            "id": id, // This is the @handle, not some numeric Facebook ID
            "legislator_full_name": legislator.full_name,
            "state_abbrev": legislator.state,
            "state_chamber": "\(legislator.state)-\(legislator.chamber)",
            "state_chamber_district": "\(legislator.state)-\(legislator.chamber)-\(legislator.district)",
            "updating_user_id": TPUser.sharedInstance.getUid(),
            "updating_user_name": TPUser.sharedInstance.getName(),
            "updating_user_email": TPUser.sharedInstance.getEmail(),
            "updated_date": Util.getDate_MMM_d_yyyy_hmm_am_z(),
            "updated_date_ms": Util.getDate_as_millis()
        ]
        
        Database.database().reference().child("social_media/user_updates").childByAutoId().setValue(userUpdate)
        
        // should this be in a callback/completion block of the setValue() call above?
        //self.dismiss(animated: true, completion: nil)
    }
    
//    @objc func recordClicked(_ sender: Any) {
//        if recording {
//            stopRecording()
//        }
//        else {
//            startRecording()
//        }
//    }
//
//    @objc func publishClicked(_ sender: Any) {
//        // write to /video/video_events.  There's a trigger listening for writes to that node
//        // When a "start publishing" record is written, the trigger will call the virtual machine
//        // which in turn calls the appropriate docker instance and executes the python script in
//        // that docker instance
//
//        let startPublishingRequest : [String:Any] = [
//            "request_type": "start publishing",
//            "video_node_key": TPUser.sharedInstance.current_video_node_key,
//            // not sure if we need room_id here - it's the same as the video_node_key anyway
//            "uid": TPUser.sharedInstance.getUid(),
//            "date": Util.getDate_MMM_d_yyyy_hmm_am_z(),
//            "date_ms": Util.getDate_as_millis()
//        ]
//        Database.database().reference().child("video/video_events").childByAutoId().setValue(startPublishingRequest)
//    }
//
//
//    @objc func connectionClicked(_ sender: Any) {
//        publishButton.isHidden = true
//        if connected {
//            if recording {
//                stopRecording()
//            }
//            // hide the record button
//            self.recordButton.isHidden = true
//
//            connector?.disconnect()
//            connect_button.setImage(UIImage(named: "callStart.png"), for: UIControlState.normal)
//            connected = false
//            unrid()
//        }
//        else {
//            connectClicked(sender)
//            connected = true
//            // show the record button
//            self.recordButton.isHidden = false
//        }
//    }
//
//    private func startRecording() {
//        recording = true
//        recordButton.setImage(UIImage(named: "recordstop.png"), for: UIControlState.normal)
//        createRecordingEvent(request_type: "start recording")
//        publishButton.isHidden = true
//    }
//
//    private func stopRecording() {
//        recording = false
//        recordButton.setImage(UIImage(named: "record.png"), for: UIControlState.normal)
//        createRecordingEvent(request_type: "stop recording")
//        publishButton.isHidden = false
//    }
//
//    private func createRecordingEvent(request_type: String) {
//        // write at least this much to /video/video_events
//        let recording_request : [String:Any] = [
//            "request_type": request_type,
//            "video_node_key": TPUser.sharedInstance.current_video_node_key,
//            "room_id": TPUser.sharedInstance.current_video_node_key,
//            "uid": TPUser.sharedInstance.getUid(),
//            "date": Util.getDate_MMM_d_yyyy_hmm_am_z(),
//            "date_ms": Util.getDate_as_millis()]
//        // might also want to capture who made the request and when
//
//        // There's a trigger function: exports.dockerRequest that listens for writes to this node
//        // and selects a docker instance that can serve as "recording secretary" for the call
//        Database.database().reference().child("video/video_events").childByAutoId().setValue(recording_request)
//    }
//
//
//    // TROUBLESHOOTING...
//    // https://support.vidyocloud.com/hc/en-us/sections/115000596414-Testing-and-Troubleshooting
//    // https://support.vidyocloud.com/hc/en-us/articles/218309687-I-see-no-video-just-a-black-window-or-receive-a-DirectX-error
//    @objc func connectClicked(_ sender: Any) {
//        doConnect()
//    }
//
//    private func doConnect() {
//        rid()
//        // The room_id will NOT be nil if the user is coming to this screen from accepting a video invitation
//        // See extension CenterViewController : VideoInvitationDelegate
//        if room_id == nil {
//            room_id = TPUser.sharedInstance.current_video_node_key
//        }
//        let name = TPUser.sharedInstance.getUid()
//        guard let escapedString = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
//            return }
//        let urlString = "https://us-central1-telepatriot-bd737.cloudfunctions.net/generateVidyoToken?userName=\(escapedString)"
//        guard let url = URL(string: urlString) else {
//            return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        // TODO need to handle errors.  If there's an error, we want the green call button back
//        // We don't want the UI to show the red hang up button if we aren't actually connected
//        let task = session.dataTask(with: request) { (data, response, responseError) in
//
//            let str = String(describing: type(of: data))
//            print( "data is: \(str)"  )
//
//            let decoder = JSONDecoder()
//            guard let tokenResponse = try? decoder.decode([String:String].self, from: data!) else {
//                return }
//
//            DispatchQueue.main.async {
//                guard let token = tokenResponse["token"] else { return }
//
//                self.connector?.connect("prod.vidyo.io",
//                                        token: token,
//                                        displayName: name,
//                                        resourceId: self.room_id,
//                                        connectorIConnect: self)
//
//                self.connect_button.setImage(UIImage(named: "callEnd.png"), for: UIControlState.normal)
//            }
//        }
//
//        task.resume()
//    }
    
    // MARK: - VCIConnect delegate methods
    
    func onSuccess() {
        print("Connection Successful")
    }
    
    func onFailure(_ reason: VCConnectorFailReason) {
        print("Connection failed \(reason)")
    }
    
    func onDisconnected(_ reason: VCConnectorDisconnectReason) {
        print("Call Disconnected")
    }
    
    
//    func refreshUI() {
//        DispatchQueue.main.async {
//
//            guard let w = self.selfView?.frame.size.width,
//                let h = self.selfView?.frame.size.height else {
//                    return
//            }
//
//            // Updating remote views
//            let refFrames   = RemoteViewLayout.getTileFrames(numberOfTiles: self.numberOfRemoteViews)
//            var index       = 0
//
//            for var remoteView in self.remoteViewsMap.values {
//                let refFrame        = refFrames[index] as! CGRect
//                remoteView.frame    = refFrame
//                self.connector?.showView(at: UnsafeMutableRawPointer(&remoteView),
//                                         x: 0,
//                                         y: 0,
//                                         width: UInt32(w),
//                                         height: UInt32(h))
//
//                // updating label location
//                for subview in remoteView.subviews
//                {
//                    if let item = subview as? UILabel
//                    {
//                        item.frame = CGRect(x: 0,
//                                            y: 10,
//                                            width: remoteView.frame.width,
//                                            height: 20)
//                    }
//                }
//                index += 1
//                if index >= 4 {
//                    // Showing max 4 remote participants
//                    break
//                }
//            }
//        }
//    }
//
//
//    // MARK: - IRegisterRemoteCameraEventListener delegate methods
//
//    func onRemoteCameraAdded(_ remoteCamera: VCRemoteCamera!, participant: VCParticipant!) {
//
//        numberOfRemoteViews += 1
//        DispatchQueue.main.async {
//            let rec = self.remoteViews.bounds
//            var newRemoteView = UIView(frame: rec)
//            newRemoteView.layer.borderColor = UIColor.black.cgColor
//            newRemoteView.layer.borderWidth = 0.0
//            self.remoteViews.addSubview(newRemoteView)
//            self.remoteViewsMap[participant.getId()] = newRemoteView
//            self.connector?.assignView(toRemoteCamera: UnsafeMutableRawPointer(&newRemoteView),
//                                       remoteCamera: remoteCamera,
//                                       displayCropped: true,
//                                       allowZoom: /*true*/false)
//            self.connector?.showViewLabel(UnsafeMutableRawPointer(&newRemoteView),
//                                          showLabel: false)
//
//            // Adding custom UILabel to show the participant name
//            let newParticipantNameLabel = UILabel()
//            newParticipantNameLabel.text = participant.getName()
//            newParticipantNameLabel.textColor = UIColor.white
//            newParticipantNameLabel.textAlignment = .center
//            newParticipantNameLabel.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//            newParticipantNameLabel.shadowOffset = CGSize(width: 1, height: 1)
//            newParticipantNameLabel.font = newParticipantNameLabel.font.withSize(14)
//            newRemoteView.addSubview(newParticipantNameLabel)
//
//            self.refreshUI()
//        }
//    }
//
//    func onRemoteCameraRemoved(_ remoteCamera: VCRemoteCamera!, participant: VCParticipant!) {
//        numberOfRemoteViews -= 1
//        DispatchQueue.main.async {
//            let remoteView = self.remoteViewsMap.removeValue(forKey: participant.getId())
//            for view in (remoteView?.subviews)!{
//                view.removeFromSuperview()
//            }
//            remoteView?.removeFromSuperview()
//
//            self.refreshUI()
//        }
//    }
//
//    func onRemoteCameraStateUpdated(_ remoteCamera: VCRemoteCamera!, participant: VCParticipant!, state: VCDeviceState) {
//
//    }
//
//
//    // MARK: - IRegisterLocalCameraEventListener delegate methods
//
//    func onLocalCameraRemoved(_ localCamera: VCLocalCamera!) {
//        self.selfView?.isHidden = true
//    }
//
//    // Equiv in Android is VidyoChatFragment.onLocalCameraAdded()
//    func onLocalCameraAdded(_ localCamera: VCLocalCamera!) {
//        if ((localCamera) != nil) {
//            self.selfView?.isHidden = false
//            DispatchQueue.main.async {
//
//                if let w = self.selfView?.frame.size.width, let h = self.selfView?.frame.size.height {
//                    self.connector?.assignView(toLocalCamera: UnsafeMutableRawPointer(&self.selfView),
//                                               localCamera: localCamera,
//                                               displayCropped: true,
//                                               allowZoom: false)
//                    self.connector?.showViewLabel(UnsafeMutableRawPointer(&self.selfView),
//                                                  showLabel: false)
//                    self.connector?.showView(at: UnsafeMutableRawPointer(&self.selfView),
//                                             x: 0,
//                                             y: 0,
//                                             width: UInt32(w),
//                                             height: UInt32(h))
//                }
//
//            }
//        }
//    }
//
//    func onLocalCameraSelected(_ localCamera: VCLocalCamera!) {
//
//    }
//
//    func onLocalCameraStateUpdated(_ localCamera: VCLocalCamera!, state: VCDeviceState) {
//
//    }
//
//    // MARK: - IRegisterParticipantEventListener delegate methods
//
//    func onParticipantLeft(_ participant: VCParticipant!) {
//
//    }
//
//    func onParticipantJoined(_ participant: VCParticipant!) {
//
//    }
//
//    func onLoudestParticipantChanged(_ participant: VCParticipant!, audioOnly: Bool) {
//
//    }
//
//    func onDynamicParticipantChanged(_ participants: NSMutableArray!, remoteCameras: NSMutableArray!) {
//
//    }
//
//    // MARK: - IRegisterLocalSpeakerEventListener delegate methods
//
//    func onLocalSpeakerAdded(_ localSpeaker: VCLocalSpeaker!) {
//
//    }
//
//    func onLocalSpeakerRemoved(_ localSpeaker: VCLocalSpeaker!) {
//
//    }
//
//    func onLocalSpeakerSelected(_ localSpeaker: VCLocalSpeaker!) {
//
//    }
//
//    func onLocalSpeakerStateUpdated(_ localSpeaker: VCLocalSpeaker!, state: VCDeviceState) {
//
//    }
//
//    // MARK: - IRegisterLocalMicrophoneEventListener delegate methods
//
//    func onLocalMicrophoneAdded(_ localMicrophone: VCLocalMicrophone!) {
//
//    }
//
//    func onLocalMicrophoneRemoved(_ localMicrophone: VCLocalMicrophone!) {
//
//    }
//
//    func onLocalMicrophoneSelected(_ localMicrophone: VCLocalMicrophone!) {
//
//    }
//
//    func onLocalMicrophoneStateUpdated(_ localMicrophone: VCLocalMicrophone!, state: VCDeviceState) {
//
//    }
//
//    // MARK: - IRegisterRemoteMicrophoneEventListener delegate methods
//
//    func onRemoteMicrophoneAdded(_ remoteMicrophone: VCRemoteMicrophone!, participant: VCParticipant!) {
//
//    }
//
//    func onRemoteMicrophoneRemoved(_ remoteMicrophone: VCRemoteMicrophone!, participant: VCParticipant!) {
//
//    }
//
//    func onRemoteMicrophoneStateUpdated(_ remoteMicrophone: VCRemoteMicrophone!, participant: VCParticipant!, state: VCDeviceState) {
//
//    }
    
    
    @objc private func editVideoMissionDescription(_ sender: UIButton) {
        let data: [String:Any] = ["videoNode": videoNode,
                                  "heading": "Video Mission Description",
                                  "video_mission_description": videoNode?.video_mission_description,
                                  "database_attribute": "video_mission_description"]
        // pop up a dialog with a text field showing the video mission description
        // and save, cancel buttons
        if let vc = editVideoMissionDescriptionVC {
            vc.modalPresentationStyle = .popover
            vc.data = data
            videoChatVC?.present(vc, animated: true, completion:nil)
        }
    }
    
    
    @objc private func editYoutubeDescription(_ sender: UIButton) {
        let data: [String:Any] = ["videoNode": videoNode,
                                  "heading": "YouTube Video Description",
                                  "youtube_video_description": videoNode?.youtube_video_description,
                                  "database_attribute": "youtube_video_description"]
        // pop up a dialog with a text field showing the video mission description
        // and save, cancel buttons
        if let vc = editVideoMissionDescriptionVC {
            vc.modalPresentationStyle = .popover
            vc.data = data
            videoChatVC?.present(vc, animated: true, completion:nil)
        }
    }
    
    
    @objc private func editLegislator(_ sender: UIButton) {
        // pop up a dialog with a text field showing the legislator's information
        // and save, cancel buttons
        if let vc = editLegislatorForVideoVC {
            vc.modalPresentationStyle = .popover
            vc.videoNode = videoNode
            videoChatVC?.present(vc, animated: true, completion:nil)
        }
    }
    
    
//    @objc private func showInstructions(_ sender: UIButton) {
//        // pop up a dialog with a text field showing the legislator's information
//        // and save, cancel buttons
//        if let vc = getAppDelegate().videoChatInstructionsVC {
//            vc.modalPresentationStyle = .popover
//            vc.videoNode = videoNode
//            present(vc, animated: true, completion:nil)
//        }
//    }
    
    
//    @objc func micClicked(_ sender: Any) {
//        if micMuted {
//            micMuted = !micMuted
//            self.micButton.setImage(UIImage(named: "microphoneOnWhite.png"), for: .normal)
//            connector?.setMicrophonePrivacy(micMuted)
//        } else {
//            micMuted = !micMuted
//            self.micButton.setImage(UIImage(named: "microphoneOff.png"), for: .normal)
//            connector?.setMicrophonePrivacy(micMuted)
//        }
//    }
//
//    @objc func cameraClicked(_ sender: Any) {
//        if cameraMuted {
//            cameraMuted = !cameraMuted
//            self.cameraButton.setImage(UIImage(named: "cameraOn.png"), for: .normal)
//            connector?.setCameraPrivacy(cameraMuted)
//            self.selfView?.isHidden = cameraMuted
//        } else {
//            cameraMuted = !cameraMuted
//            self.cameraButton.setImage(UIImage(named: "cameraOff.png"), for: .normal)
//            connector?.setCameraPrivacy(cameraMuted)
//            self.selfView?.isHidden = cameraMuted
//        }
//    }
    
    
//    // These next two functions kinda go together.  This first one pops up the Search Users screen
//    @objc private func findSomeone(_ sender: UIButton) {
//        // pop up the same Search Users screen that Admins see
//        if let vc = getAppDelegate().searchUsersVC {
//            vc.modalPresentationStyle = .popover
//            vc.searchUsersDelegate = self
//            centerViewController?.doView(vc: vc)
//        }
//    }
//
//    // This second function is what gets called when you choose a user from SearchUsersVC
//    // Notice in the method above that we made 'self' the delegate of SearchUsersVC
//    // per SearchUsersDelegate
//    func userSelected(user: TPUser) {
//        // We want to write this user and the current user to /video/invitations
//        if let vid = TPUser.sharedInstance.current_video_node_key {
//            let videoInvitation = VideoInvitation(creator: TPUser.sharedInstance, guest: user, video_node_key: vid)
//            videoInvitation.save()
//            centerViewController?.doView(vc: self)
//            guest_name.text = "You have invited \(user.getName()) to participate in a video chat"
//        }
//    }
    
}
