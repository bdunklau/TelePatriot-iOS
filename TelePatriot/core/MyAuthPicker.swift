//
//  MyAuthPicker.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/12/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import FirebaseAuthUI

class MyAuthPicker: FUIAuthPickerViewController {
    
    
    let logo : UIImageView = {
        let img = UIImage(named: "splashscreen_image.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This class inspired by Brian Caldwell YouTube "iOS Firebase Login Customization via Subclassing"
        
        
        // hides the Cancel button in the upper left, because there's no need for it.  It's just confusing
        // having it there
        self.navigationItem.leftBarButtonItem = nil
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(logo)
        
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        logo.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
        logo.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    
    
    // from:  https://stackoverflow.com/a/41274376
    override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
        super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
    }
    
    // from:  https://stackoverflow.com/a/41274376
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "TelePatriot" // what the user sees (across the top) when they first login
    }
}
