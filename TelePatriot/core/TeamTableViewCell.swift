//
//  TeamTableViewCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/16/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class TeamTableViewCell: UITableViewCell {
    
    let teamNameLabel : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var ref : DatabaseReference?
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func commonInit(team: TeamIF, ref: DatabaseReference?) {
        
        self.ref = ref
        
        self.addSubview(teamNameLabel)
        
        teamNameLabel.text = team.getName()
        teamNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        teamNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //teamNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        teamNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        //teamNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25).isActive = true
        
    }
    
}
