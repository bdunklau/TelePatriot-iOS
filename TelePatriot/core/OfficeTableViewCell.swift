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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Most other examples of this method pass a DatabaseReference object
    // to the commonInit() method.  In this case, we don't need to
    func commonInit(office: Legislator.Office /*, ref: DatabaseReference*/ ) {
        
        //self.ref = ref
        
        self.backgroundColor = .clear
        
        self.addSubview(nameLabel)
        nameLabel.text = office.name
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        //teamNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        //teamNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //teamNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        
        self.addSubview(phoneButton)
        phoneButton.phone = office.phone
        phoneButton.setTitle(office.phone, for: .normal)
        phoneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        phoneButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor, constant: 0).isActive = true
        phoneButton.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
        
        self.addSubview(addressView)
        addressView.text = office.address
        addressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -4).isActive = true
        addressView.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: -8).isActive = true
        
        /**********
        self.addSubview(emailLabel)
        emailLabel.text = office.email // OpenStates returns "" for both Hall and Holland, so maybe it does for everyone
        emailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        emailLabel.topAnchor.constraint(equalTo: addressView.bottomAnchor, constant: 8).isActive = true
         **********/
    }
    
    
    // call end is recorded in AppDelegate.onCallEnded()
    @objc func makeCall(_ sender: CallButton) {
        guard let ph = sender.phone else { return }
        guard let number = URL(string: "tel://"+ph) else { return }
        
        // we should record that a call was made - we'll add this later
        
        // now do the call
        UIApplication.shared.open(number)
    }
    
}
