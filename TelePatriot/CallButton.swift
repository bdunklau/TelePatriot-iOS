//
//  CallButton.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/25/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import Foundation

class CallButton : BaseButton {
    
    var phone : String?
    
    override init(text: String) {
        super.init(frame: CGRect.init())
        //self.backgroundColor = UIColor.blue
        setTitle(text, for: .normal)
        let color = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        self.setTitleColor(color, for: UIControlState.normal)//.textColor = UIColor.blue
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}
