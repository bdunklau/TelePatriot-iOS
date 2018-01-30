//
//  WrapUpViewControllerDelegate.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/2/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import Foundation

protocol WrapUpViewControllerDelegate {
    
    // leave this overload for the default cases
    func missionAccomplished()
    
    
    // Not sure if I like this idea...  Let's put a viewcontroller inside the mission_item
    // object so the mission_item can direct us to the next screen, either back to My Mission
    // or to My Legislators or to ... ?
    func missionAccomplished(vc: UIViewController)
}
