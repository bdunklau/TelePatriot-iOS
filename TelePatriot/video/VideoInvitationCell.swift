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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // In Android, the class is MissionHolder
    func commonInit(invitation: [String:Any]) {
        
        if let name = invitation["initiator_name"] as? String {
            descr.text = "\(name) has invited you to participate in a video chat"
        }
        
        if let date = invitation["invitation_create_date"] as? String {
            invdate.text = date
        }
        
        self.addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        
        addSubview(invdate)
        invdate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:-8).isActive = true
        invdate.bottomAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant:0).isActive = true
        
        self.addSubview(descr)
        descr.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor, constant: -4).isActive = true
        descr.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8).isActive = true
        descr.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //descr.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
    }
    
}



