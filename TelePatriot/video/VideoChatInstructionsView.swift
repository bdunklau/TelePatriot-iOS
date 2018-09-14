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
    
    
    let videoTitleHeader : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "YouTube Video Title"
        return l
    }()
    
    
    let edit_video_title_button : BaseButton = {
        let button = BaseButton(text: "Edit")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editVideoTitle(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let video_title : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "(This will be the title of the video on YouTube)"
        return l
    }()
    
    
    let youtubeVideoDescriptionHeader : UILabel = {
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
    
    
    let youtube_video_description : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = "(This is what people will see in the video description field on YouTube)"
        return l
    }()
    
    
    let what_do_you_want_to_do_with_your_video : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "What do you want to do with your video?"
        return l
    }()
    
    
    let email_to_legislator_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Email to Legislator"
        return l
    }()
    
    let email_to_legislator : UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .touchUpInside)
        return s
    }()
    
    let post_to_facebook_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Post to Facebook"
        return l
    }()
    
    let post_to_facebook : UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .touchUpInside)
        return s
    }()
    
    let post_to_twitter_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Post to Twitter"
        return l
    }()
    
    let post_to_twitter : UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .touchUpInside)
        return s
    }()
    
    
    let video_status : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Video Status"
        return l
    }()
    
    let youtube_status : UIImageView = {
        let img = UIImage(named: "green_checkmark.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let posted_to_youtube : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Posted to YouTube"
        return l
    }()
    
    let facebook_status : UIImageView = {
        let img = UIImage(named: "gray_checkmark.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let posted_to_facebook : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Posted to Facebook"
        return l
    }()
    
    let twitter_status : UIImageView = {
        let img = UIImage(named: "gray_checkmark.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let posted_to_twitter : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Posted to Twitter"
        return l
    }()
    
    let emailed_to_legislator_status : UIImageView = {
        let img = UIImage(named: "gray_checkmark.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let emailed_to_legislator : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Emailed to Legislator"
        return l
    }()
    
    let emailed_to_participant_status : UIImageView = {
        let img = UIImage(named: "gray_checkmark.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    let emailed_to_participant : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "You've got Mail!"
        return l
    }()
    
    
    @objc func switchValueDidChange(_ sender:UISwitch!) {
        let m : [UISwitch : String] = [
            email_to_legislator: "email_to_legislator",
            post_to_facebook: "post_to_facebook",
            post_to_twitter: "post_to_twitter",
        ]
        if let videoNode = videoNode, let attribute = m[sender] {
            Database.database().reference().child("video/list/\(videoNode.getKey())/\(attribute)").setValue(sender.isOn)
        }
    }
    
    
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
        video_mission_description.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
        
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
        
        
        scrollView.addSubview(videoTitleHeader)
        videoTitleHeader.topAnchor.constraint(equalTo: twitterButton.bottomAnchor, constant: 16).isActive = true
        videoTitleHeader.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        
        
        scrollView.addSubview(edit_video_title_button)
        edit_video_title_button.centerYAnchor.constraint(equalTo: videoTitleHeader.centerYAnchor, constant: 0).isActive = true
        edit_video_title_button.leadingAnchor.constraint(equalTo: videoTitleHeader.trailingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(video_title)
        video_title.topAnchor.constraint(equalTo: videoTitleHeader.bottomAnchor, constant: 8).isActive = true
        video_title.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        // this constraint plus this attribute setting above: l.numberOfLines = 0
        // is how we achieve word wrapping inside the scrollview
        video_title.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
        
        
        scrollView.addSubview(youtubeVideoDescriptionHeader)
        youtubeVideoDescriptionHeader.topAnchor.constraint(equalTo: video_title.bottomAnchor, constant: 16).isActive = true
        youtubeVideoDescriptionHeader.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        
        
        scrollView.addSubview(edit_youtube_video_description_button)
        edit_youtube_video_description_button.centerYAnchor.constraint(equalTo: youtubeVideoDescriptionHeader.centerYAnchor, constant: 0).isActive = true
        edit_youtube_video_description_button.leadingAnchor.constraint(equalTo: youtubeVideoDescriptionHeader.trailingAnchor, constant: 8).isActive = true
        
        
        scrollView.addSubview(youtube_video_description)
        youtube_video_description.topAnchor.constraint(equalTo: youtubeVideoDescriptionHeader.bottomAnchor, constant: 8).isActive = true
        youtube_video_description.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 8).isActive = true
        // this constraint plus this attribute setting above: l.numberOfLines = 0
        // is how we achieve word wrapping inside the scrollview
        youtube_video_description.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
        
        scrollView.addSubview(what_do_you_want_to_do_with_your_video)
        what_do_you_want_to_do_with_your_video.topAnchor.constraint(equalTo: youtube_video_description.bottomAnchor, constant: 48).isActive = true
        what_do_you_want_to_do_with_your_video.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        // this constraint plus this attribute setting above: l.numberOfLines = 0
        // is how we achieve word wrapping inside the scrollview
        youtube_video_description.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0.95).isActive = true
        
        scrollView.addSubview(email_to_legislator_label)
        email_to_legislator_label.topAnchor.constraint(equalTo: what_do_you_want_to_do_with_your_video.bottomAnchor, constant: 16).isActive = true
        email_to_legislator_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(email_to_legislator)
        email_to_legislator.centerYAnchor.constraint(equalTo: email_to_legislator_label.centerYAnchor, constant: 0).isActive = true
        email_to_legislator.leadingAnchor.constraint(equalTo: email_to_legislator_label.trailingAnchor, constant: 24).isActive = true
        
        scrollView.addSubview(post_to_facebook_label)
        post_to_facebook_label.topAnchor.constraint(equalTo: email_to_legislator_label.bottomAnchor, constant: 16).isActive = true
        post_to_facebook_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(post_to_facebook)
        post_to_facebook.centerYAnchor.constraint(equalTo: post_to_facebook_label.centerYAnchor, constant: 0).isActive = true
        post_to_facebook.leadingAnchor.constraint(equalTo: email_to_legislator.leadingAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(post_to_twitter_label)
        post_to_twitter_label.topAnchor.constraint(equalTo: post_to_facebook_label.bottomAnchor, constant: 16).isActive = true
        post_to_twitter_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(post_to_twitter)
        post_to_twitter.centerYAnchor.constraint(equalTo: post_to_twitter_label.centerYAnchor, constant: 0).isActive = true
        post_to_twitter.leadingAnchor.constraint(equalTo: email_to_legislator.leadingAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(video_status)
        video_status.leadingAnchor.constraint(equalTo: post_to_twitter_label.leadingAnchor, constant: 0).isActive = true
        video_status.topAnchor.constraint(equalTo: post_to_twitter_label.bottomAnchor, constant: 32).isActive = true
        
        scrollView.addSubview(youtube_status)
        youtube_status.leadingAnchor.constraint(equalTo: video_status.leadingAnchor, constant: 0).isActive = true
        youtube_status.topAnchor.constraint(equalTo: video_status.bottomAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(posted_to_youtube)
        posted_to_youtube.leadingAnchor.constraint(equalTo: youtube_status.trailingAnchor, constant: 8).isActive = true
        posted_to_youtube.centerYAnchor.constraint(equalTo: youtube_status.centerYAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(facebook_status)
        facebook_status.leadingAnchor.constraint(equalTo: video_status.leadingAnchor, constant: 0).isActive = true
        facebook_status.topAnchor.constraint(equalTo: youtube_status.bottomAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(posted_to_facebook)
        posted_to_facebook.leadingAnchor.constraint(equalTo: facebook_status.trailingAnchor, constant: 8).isActive = true
        posted_to_facebook.centerYAnchor.constraint(equalTo: facebook_status.centerYAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(twitter_status)
        twitter_status.leadingAnchor.constraint(equalTo: video_status.leadingAnchor, constant: 0).isActive = true
        twitter_status.topAnchor.constraint(equalTo: facebook_status.bottomAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(posted_to_twitter)
        posted_to_twitter.leadingAnchor.constraint(equalTo: twitter_status.trailingAnchor, constant: 8).isActive = true
        posted_to_twitter.centerYAnchor.constraint(equalTo: twitter_status.centerYAnchor, constant: 0).isActive = true

        scrollView.addSubview(emailed_to_legislator_status)
        emailed_to_legislator_status.leadingAnchor.constraint(equalTo: video_status.leadingAnchor, constant: 0).isActive = true
        emailed_to_legislator_status.topAnchor.constraint(equalTo: twitter_status.bottomAnchor, constant: 8).isActive = true

        scrollView.addSubview(emailed_to_legislator)
        emailed_to_legislator.leadingAnchor.constraint(equalTo: emailed_to_legislator_status.trailingAnchor, constant: 8).isActive = true
        emailed_to_legislator.centerYAnchor.constraint(equalTo: emailed_to_legislator_status.centerYAnchor, constant: 0).isActive = true
        
        scrollView.addSubview(emailed_to_participant_status)
        emailed_to_participant_status.leadingAnchor.constraint(equalTo: video_status.leadingAnchor, constant: 0).isActive = true
        emailed_to_participant_status.topAnchor.constraint(equalTo: emailed_to_legislator_status.bottomAnchor, constant: 8).isActive = true
        
        scrollView.addSubview(emailed_to_participant)
        emailed_to_participant.leadingAnchor.constraint(equalTo: emailed_to_participant_status.trailingAnchor, constant: 8).isActive = true
        emailed_to_participant.centerYAnchor.constraint(equalTo: emailed_to_participant_status.centerYAnchor, constant: 0).isActive = true
        
        addSubview(scrollView)
        
        if let videoNode = videoNode {
            setVideoNode(videoNode: videoNode)
        }
    }
    
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    func setVideoNode(videoNode: VideoNode) {
        self.videoNode = videoNode
        self.video_mission_description.text = videoNode.video_mission_description
        if let legislator = videoNode.legislator {
            self.editFacebookButton.isHidden = false
            self.editFacebookButton.setImage(UIImage(named: "baseline_edit_black_18dp"), for: .normal)
            self.editTwitterButton.isHidden = false
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
            self.video_title.text = self.videoNode?.video_title
            self.youtube_video_description.text = self.videoNode?.youtube_video_description
        }
        else {
            self.editFacebookButton.isHidden = true
            self.editTwitterButton.isHidden = true
            self.legislator = nil
            self.legislatorName.text = ""
            self.state.text = ""
            self.chamber.text = ""
            self.district.text = ""
            self.facebookButton.setTitle("", for: .normal)
            self.fbId = ""
            self.twitterButton.setTitle("", for: .normal)
            self.video_title.text = "(Choose a legislator first)"
            self.youtube_video_description.text = "(Choose a legislator first)"
        }
        if let email_to_legislator = self.videoNode?.email_to_legislator {
            self.email_to_legislator.isOn = email_to_legislator
        }
        if let post_to_facebook = self.videoNode?.post_to_facebook {
            self.post_to_facebook.isOn = post_to_facebook
        }
        if let post_to_twitter = self.videoNode?.post_to_twitter {
            self.post_to_twitter.isOn = post_to_twitter
        }
        if self.videoNode?.facebook_post_id != nil {
            DispatchQueue.main.async { self.facebook_status.image = UIImage(named: "green_checkmark.png") }
        }
        else {
            DispatchQueue.main.async { self.facebook_status.image = UIImage(named: "gray_checkmark.png") }
        }
        if self.videoNode?.twitter_post_id != nil {
            DispatchQueue.main.async { self.twitter_status.image = UIImage(named: "green_checkmark.png") }
        }
        else {
            DispatchQueue.main.async { self.twitter_status.image = UIImage(named: "gray_checkmark.png") }
        }
        if self.videoNode?.video_id != nil {
            DispatchQueue.main.async { self.youtube_status.image = UIImage(named: "green_checkmark.png") }
        }
        else {
            DispatchQueue.main.async { self.youtube_status.image = UIImage(named: "gray_checkmark.png") }
        }
        if self.videoNode?.email_to_legislator_send_date != nil {
            DispatchQueue.main.async { self.emailed_to_legislator_status.image = UIImage(named: "green_checkmark.png") }
        }
        else {
            DispatchQueue.main.async { self.emailed_to_legislator_status.image = UIImage(named: "gray_checkmark.png") }
        }
        if self.videoNode?.email_to_participant_send_date != nil {
            DispatchQueue.main.async { self.emailed_to_participant_status.image = UIImage(named: "green_checkmark.png") }
        }
        else {
            DispatchQueue.main.async { self.emailed_to_participant_status.image = UIImage(named: "gray_checkmark.png") }
        }
    }
    

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
    
    
    // MARK: - VCIConnect delegate methods
    
    func onSuccess() {
        print("Connection Successful")
    }
    
//    func onFailure(_ reason: VCConnectorFailReason) {
//        print("Connection failed \(reason)")
//    }
//    
//    func onDisconnected(_ reason: VCConnectorDisconnectReason) {
//        print("Call Disconnected")
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
    
    
    @objc private func editVideoTitle(_ sender: UIButton) {
        let data: [String:Any] = ["videoNode": videoNode,
                                  "heading": "YouTube Video Title",
                                  "video_title": videoNode?.video_title,
                                  "database_attribute": "video_title"]
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
    
    
}
