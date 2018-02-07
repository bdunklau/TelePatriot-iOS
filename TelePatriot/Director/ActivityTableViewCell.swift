//
//  ActivityTableViewCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/12/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import Foundation
import Firebase

// modeled after MissionSummaryCellTableViewCell
class ActivityTableViewCell: UITableViewCell {

    
    var ref : DatabaseReference?
    
    let timestampLabel : UILabel = {
        let l = UILabel()
        l.textColor = UIColor.gray
        l.font = .systemFont(ofSize: 12)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let missionNameLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let volunteerNameLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let eventTypeLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let supporterNameLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let volunteerPhoneLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let phoneIcon : UIImageView = {
        let image = UIImage(named: "ic_phone_forwarded_black_24dp")!
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let supporterPhoneLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    func commonInit(missionItemEvent: MissionItemEvent, ref: DatabaseReference) {
        
        self.ref = ref
        
        timestampLabel.text = missionItemEvent.event_date
        eventTypeLabel.text = missionItemEvent.event_type
        volunteerNameLabel.text = missionItemEvent.volunteer_name
        missionNameLabel.text = missionItemEvent.mission_name
        supporterPhoneLabel.text = missionItemEvent.phone
        volunteerPhoneLabel.text = missionItemEvent.volunteer_phone
        supporterNameLabel.text = missionItemEvent.supporter_name
        
        self.addSubview(timestampLabel)
        timestampLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        timestampLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        //timestampLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(missionNameLabel)
        missionNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        missionNameLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 8).isActive = true
        missionNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(volunteerNameLabel)
        volunteerNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        volunteerNameLabel.topAnchor.constraint(equalTo: missionNameLabel.bottomAnchor, constant: 8).isActive = true
        //volunteerNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(eventTypeLabel)
        eventTypeLabel.leadingAnchor.constraint(equalTo: volunteerNameLabel.trailingAnchor, constant: 4).isActive = true
        eventTypeLabel.topAnchor.constraint(equalTo: volunteerNameLabel.topAnchor, constant: 0).isActive = true
        //eventTypeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(supporterNameLabel)
        supporterNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        supporterNameLabel.topAnchor.constraint(equalTo: eventTypeLabel.bottomAnchor, constant: 8).isActive = true
        //supporterNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        self.addSubview(volunteerPhoneLabel)
        volunteerPhoneLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        volunteerPhoneLabel.topAnchor.constraint(equalTo: supporterNameLabel.bottomAnchor, constant: 8).isActive = true
        
        self.addSubview(supporterPhoneLabel)
        /*****/
        supporterPhoneLabel.topAnchor.constraint(equalTo: volunteerPhoneLabel.bottomAnchor, constant: 8).isActive = true
        supporterPhoneLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
         /******
        supporterPhoneLabel.leadingAnchor.constraint(equalTo: volunteerPhoneLabel.trailingAnchor, constant: 4).isActive = true
        supporterPhoneLabel.topAnchor.constraint(equalTo: volunteerPhoneLabel.topAnchor, constant: 0).isActive = true
        *******/
        
        // this is actually to the left of the supporterPhoneLabel
        self.addSubview(phoneIcon)
        phoneIcon.topAnchor.constraint(equalTo: volunteerPhoneLabel.bottomAnchor, constant: 8).isActive = true
        phoneIcon.trailingAnchor.constraint(equalTo: supporterPhoneLabel.leadingAnchor, constant: -24).isActive = true
        
    }
    
}
