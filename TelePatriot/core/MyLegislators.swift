//
//  MyLegislators.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/20/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

class MyLegislators: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let myLegislatorsHeading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "My Legislators"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    var senatorView : LegislatorUI?
    var houserepView : LegislatorUI?
    
    
    
    // #1
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // #2
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let w = self.frame.width
        let h = self.frame.height
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        scrollView.contentSize = CGSize(width: self.frame.width, height: 1450)
        
        scrollView.addSubview(myLegislatorsHeading)
        myLegislatorsHeading.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        myLegislatorsHeading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        //myAddressHeading.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        //myAddressHeading.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        
        let senatorViewY = myLegislatorsHeading.frame.origin.y + myLegislatorsHeading.frame.height + 8
        
        let rectSenator = CGRect(
            origin: CGPoint(x: myLegislatorsHeading.frame.origin.x, y: senatorViewY),
            size: CGSize(width: self.frame.width-16, height: 200)
        )
        
        
        senatorView = LegislatorUI(frame: rectSenator)
        scrollView.addSubview(senatorView!)
        senatorView?.topAnchor.constraint(equalTo: myLegislatorsHeading.bottomAnchor, constant: 16).isActive = true
        senatorView?.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        senatorView?.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
        /********/
        
        let houseRepViewY = (senatorView?.frame.origin.y)! + (senatorView?.frame.height)! + 8
        
        let rectHouseRep = CGRect(
            origin: CGPoint(x: myLegislatorsHeading.frame.origin.x, y: houseRepViewY),
            size: CGSize(width: self.frame.width-16, height: 200)
        )
        
        houserepView = LegislatorUI(frame: rectHouseRep)
        scrollView.addSubview(houserepView!)
        houserepView?.topAnchor.constraint(equalTo: (senatorView?.bottomAnchor)!, constant: 72).isActive = true
        houserepView?.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        houserepView?.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
    }
    
    
    func setLegislators(legislators: [Legislator]) {
        
        DispatchQueue.main.async {
            for legislator in legislators {
                if legislator.chamber == "upper" {
                    self.senatorView?.setLegislator(legislator: legislator)
                }
                else if legislator.chamber == "lower" {
                    self.houserepView?.setLegislator(legislator: legislator)
                }
            }
        }
    }
    
}
