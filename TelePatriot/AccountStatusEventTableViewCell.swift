//
//  AccountStatusEventTableViewCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/15/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class AccountStatusEventTableViewCell: UITableViewCell {
    
    
    //@IBOutlet weak var event: UITextView!
    //@IBOutlet weak var date: UILabel!
    
    let event : UITextView = {
        let t = UITextView()
        t.isEditable = false
        t.font = .systemFont(ofSize: 18)
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    let date : UILabel = {
        let t = UILabel()
        t.font = .systemFont(ofSize: 16)
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    /******
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     ******/

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(accountStatusEvent: AccountStatusEvent) {
        date.text = accountStatusEvent.thedate
        event.text = accountStatusEvent.event
        self.addSubview(date)
        self.addSubview(event)

        date.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        date.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        date.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        date.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
        event.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        event.topAnchor.constraint(equalTo: date.bottomAnchor).isActive = true
        event.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        event.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7).isActive = true
    }
    
}
