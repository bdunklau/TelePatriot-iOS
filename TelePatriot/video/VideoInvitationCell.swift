//
//  VideoInvitationCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 6/12/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase


// modeled after MissionSummaryCellTableViewCell
class VideoInvitationCell: UITableViewCell {
    
    
    let headerLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Invitation"
        return l
    }()
    
    
    let descr : UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    let invdate : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = ""
        return l
    }()
    
    
    let decline_invitation_button : BaseButton = {
        let button = BaseButton(text: "Decline")
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(declineInvitation(_:)), for: .touchUpInside)
        return button
    }()


    let accept_invitation_button : BaseButton = {
        let button = BaseButton(text: "Accept")
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(acceptInvitation(_:)), for: .touchUpInside)
        return button
    }()
    
    
    var invitation : VideoInvitation?
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // In Android, the class is MissionHolder
//    func commonInit(invitation: [String:Any]) {
    func commonInit(invitation: VideoInvitation) {
        
        self.invitation = invitation
        
        if let initiator_name = invitation.initiator_name {
            descr.text = "\(initiator_name) has invited you to participate in a video chat"
            invdate.text = invitation.invitation_create_date
        }
        
        self.addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        addSubview(invdate)
        invdate.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant:0).isActive = true
        invdate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:-16).isActive = true
        
        self.addSubview(descr)
        descr.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8).isActive = true
        descr.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor, constant: -4).isActive = true
        descr.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //descr.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        self.addSubview(decline_invitation_button)
        decline_invitation_button.topAnchor.constraint(equalTo: descr.bottomAnchor, constant: 8).isActive = true
        decline_invitation_button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32).isActive = true
        
        self.addSubview(accept_invitation_button)
        accept_invitation_button.topAnchor.constraint(equalTo: descr.bottomAnchor, constant: 8).isActive = true
        accept_invitation_button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
    }
    
}



