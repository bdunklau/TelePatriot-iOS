//
//  CenterViewController.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/22/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
    
    /********
    @IBOutlet weak fileprivate var imageView: UIImageView!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var creatorLabel: UILabel!
    *******/
    
    var delegate: CenterViewControllerDelegate?
    
    // MARK: Button actions
    
    @IBAction func leftMenuTapped(_ sender: Any) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func rightMenuTapped(_ sender: Any) {
        delegate?.toggleRightPanel?()
    }
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "CenterVC"
    }
}

extension CenterViewController: SidePanelViewControllerDelegate {
    
    func didSelectSomething(menuItem: MenuItem) {
        /*******
        imageView.image = animal.image
        titleLabel.text = animal.title
        creatorLabel.text = animal.creator
        ********/
        delegate?.collapseSidePanels?()
    }
}

