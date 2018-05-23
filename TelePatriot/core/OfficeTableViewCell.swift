//
//  OfficeTableViewCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/20/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class OfficeTableViewCell: UITableViewCell {
    
    let nameLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let phoneButton = CallButton(text: "")
    
    let addressView : UITextView = {
        let textView = UITextView()
        textView.text = "(address)"
        //textView.font = UIFont(name: "fontname", size: 18)
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: (textView.font?.pointSize)!) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        //var frame = textView.frame
        //frame.size.height = 200
        //textView.frame = frame
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let emailLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var ref : DatabaseReference?
    var legislator : Legislator?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Most other examples of this method pass a DatabaseReference object
    // to the commonInit() method.  In this case, we don't need to
    func commonInit(legislator: Legislator, office: Legislator.Office /*, ref: DatabaseReference*/ ) {
        
        //self.ref = ref
        
        self.legislator = legislator
        self.backgroundColor = .clear
        
        self.addSubview(phoneButton)
        
        // to test calling legislators without actually calling them, comment out office.phone and replace with 555-555-5555
        phoneButton.phone = office.phone
        phoneButton.setTitle(office.phone, for: .normal)
        phoneButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        phoneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        phoneButton.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
        
        self.addSubview(nameLabel)
        nameLabel.text = office.name
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: -8).isActive = true
        //teamNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        //teamNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //teamNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        self.addSubview(addressView)
        addressView.text = office.address
        addressView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -4).isActive = true
        addressView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        
        /**********
        self.addSubview(emailLabel)
        emailLabel.text = office.email // OpenStates returns "" for both Hall and Holland, so maybe it does for everyone
        emailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        emailLabel.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 8).isActive = true
         **********/
    }
    
    
    // call end is recorded in AppDelegate.onCallEnded()
    @objc func makeCall(_ sender: CallButton) {
        guard let ph = sender.phone as? String else {
                return }
        
        guard let number = URL(string: "tel://"+ph) else { return }
        
        guard let legislator = legislator,
            let legfirstname = legislator.first_name as? String,
            let leglastname = legislator.last_name as? String,
            let legstate = legislator.state as? String,
            let legchamber = legislator.chamber as? String,
            let legdistrict = legislator.district as? String else {
                return
        }
        
        // In Android, MyMissionFragment.call() creates a MissionItemEvent
        let m = CallLegislatorEvent(event_type: "is calling",
                                 volunteer_uid: TPUser.sharedInstance.getUid(),
                                 volunteer_name: TPUser.sharedInstance.getName(),
                                 mission_name: "no mission",
                                 phone: ph,
                                 volunteer_phone: "phone number not available", // <- this sucks https://stackoverflow.com/a/40719308
            legislator_name: legfirstname+" "+leglastname,
            legislator_state_abbrev: legstate.uppercased(),
            legislator_chamber: legchamber,
            legislator_district: legdistrict,
            event_date: Util.getDate_Day_MMM_d_hmmss_am_z_yyyy())
        
        
        let ref = Database.database().reference().child("users/\(TPUser.sharedInstance.getUid())/activity")
        ref.child("all").childByAutoId().setValue(m.dictionary())
        ref.child("by_phone_number").child(ph).childByAutoId().setValue(m.dictionary())
        
        var mi2 = MissionItem2()
        mi2.set(user: TPUser.sharedInstance)
        mi2.set(legislator: legislator)
        mi2.set(phone: ph)
        mi2.set(mission_type: "Call to Legislator")
        mi2.set(mission_name: "Call to \(legfirstname) \(leglastname)")
        TPUser.sharedInstance.currentMissionItem2 = mi2
        
        // now do the call
        UIApplication.shared.open(number)
    }
    
}
