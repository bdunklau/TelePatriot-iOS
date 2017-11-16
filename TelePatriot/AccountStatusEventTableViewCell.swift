//
//  AccountStatusEventTableViewCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/15/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class AccountStatusEventTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var event: UITextView!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(accountStatusEvent: AccountStatusEvent) {
        date.text = accountStatusEvent.thedate
        event.text = accountStatusEvent.event
    }
    
}
