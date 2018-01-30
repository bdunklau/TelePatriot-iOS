//
//  AddressNeededView.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/26/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

class AddressNeededView: UIView {
    
    var addressUpdater : AddressUpdater? // set in MyLegislatorsVC
    
    
    let needAddressHeading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Address Needed"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let noAddressText : UITextView = {
        let textView = UITextView()
        textView.text = "This app needs your address in order to look up your state legislators.  You have two options for entering your address."
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
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
    
    
    let option1Heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Option #1 - Your Phone's GPS"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let option1Explanation : UITextView = {
        let textView = UITextView()
        textView.text = "If you're home now, you can use the GPS on your phone to get your address."
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
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
    
    
    let useLocationServicesButton : BaseButton = {
        let button = BaseButton(text: "Use My Phone's GPS")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(enterAddressUsingGPS(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let option2Heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Option #2 - Enter Manually"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let option2Explanation : UITextView = {
        let textView = UITextView()
        textView.text = "If you are not home, or do not want to use the GPS on your phone, you can enter your address the old fashioned way."
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
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
    
    
    let enterManuallyButton : BaseButton = {
        let button = BaseButton(text: "Enter My Address Manually")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(enterAddressManually(_:)), for: .touchUpInside)
        return button
    }()
    
    
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
        self.addSubview(needAddressHeading)
        needAddressHeading.topAnchor.constraint(equalTo: self.topAnchor, constant: 72).isActive = true
        needAddressHeading.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(noAddressText)
        noAddressText.topAnchor.constraint(equalTo: needAddressHeading.bottomAnchor, constant: 8).isActive = true
        noAddressText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noAddressText.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95).isActive = true
        
        self.addSubview(option1Heading)
        option1Heading.topAnchor.constraint(equalTo: noAddressText.bottomAnchor, constant: 32).isActive = true
        option1Heading.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(option1Explanation)
        option1Explanation.topAnchor.constraint(equalTo: option1Heading.bottomAnchor, constant: 8).isActive = true
        option1Explanation.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        option1Explanation.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95).isActive = true
        
        self.addSubview(useLocationServicesButton)
        useLocationServicesButton.topAnchor.constraint(equalTo: option1Explanation.bottomAnchor, constant: 16).isActive = true
        useLocationServicesButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(option2Heading)
        option2Heading.topAnchor.constraint(equalTo: useLocationServicesButton.bottomAnchor, constant: 32).isActive = true
        option2Heading.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(option2Explanation)
        option2Explanation.topAnchor.constraint(equalTo: option2Heading.bottomAnchor, constant: 8).isActive = true
        option2Explanation.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        option2Explanation.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95).isActive = true
        
        self.addSubview(enterManuallyButton)
        enterManuallyButton.topAnchor.constraint(equalTo: option2Explanation.bottomAnchor, constant: 16).isActive = true
        enterManuallyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    @objc private func enterAddressManually(_ sender: UIButton) {
        // send the user to MyProfileVC to update address based on lat/long location
        
        // addressUpdater is a "delegate"
        addressUpdater?.beginUpdatingAddressManually()
    }
    
    @objc private func enterAddressUsingGPS(_ sender: UIButton) {
        // send the user to MyProfileVC to update address based on lat/long location
        
        // addressUpdater is a "delegate"
        addressUpdater?.beginUpdatingAddressUsingGPS()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


protocol AddressNeededDelegate {
    func choosingManual()
    func choosingGPS()
}
