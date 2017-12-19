//
//  MenuCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/22/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    //var menuItemImageView = UIImageView()
    var label = UILabel()
    
    func configureCell(_ menuItem: MenuItem) {
        //menuItemImageView.image = menuItem.image
        
        // How do we make this "user aware"?  reload the tableview?
        label.text = menuItem.title
        
        let maxSize = CGSize(width: 150, height: 50)
        let size = label.sizeThatFits(maxSize)
        label.frame = CGRect(origin: CGPoint(x: 50, y: 10), size: size)
        
        addSubview(label)
    }
}


