//
//  NevermindView.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 3/18/19.
//  Copyright © 2019 Brent Dunklau. All rights reserved.
//

import UIKit

class NevermindView: UIView {

    var nevermindDelegate : NevermindDelegate?
    
    var scrollView : UIScrollView?
    
    let reregister_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Re-register ?"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let reregister_text : UITextView = {
        let textView = UITextView()
        textView.text = "Wanna come back? Touch \"Re-register\" to create an account using a different email address"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        textView.translatesAutoresizingMaskIntoConstraints = false
        //        var frame = textView.frame
        //        frame.size.height = 24
        //        textView.frame = frame
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let reregister_button : BaseButton = {
        let button = BaseButton(text: "Re-register")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickReregister(_:)), for: .touchUpInside)
        return button
    }()
    
    let quit_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Quit ...for real"
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let quit_text : UITextView = {
        let textView = UITextView()
        textView.text = "Touch \"Quit\" to close out of this app"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        textView.translatesAutoresizingMaskIntoConstraints = false
        //        var frame = textView.frame
        //        frame.size.height = 24
        //        textView.frame = frame
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let quit_button : BaseButton = {
        let button = BaseButton(text: "Quit")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickQuit(_:)), for: .touchUpInside)
        return button
    }()
    
    // #1
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // #2
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setupView() {
    
        self.addSubview(reregister_heading)
        reregister_heading.topAnchor.constraint(equalTo: self.topAnchor, constant: 48).isActive = true
        reregister_heading.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(reregister_text)
        reregister_text.topAnchor.constraint(equalTo: reregister_heading.bottomAnchor, constant: 16).isActive = true
        reregister_text.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        reregister_text.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.95).isActive = true
        
        self.addSubview(reregister_button)
        reregister_button.topAnchor.constraint(equalTo: reregister_text.bottomAnchor, constant: 16).isActive = true
        reregister_button.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        self.addSubview(quit_heading)
        quit_heading.topAnchor.constraint(equalTo: reregister_button.bottomAnchor, constant: 32).isActive = true
        quit_heading.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(quit_text)
        quit_text.topAnchor.constraint(equalTo: quit_heading.bottomAnchor, constant: 16).isActive = true
        quit_text.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        
        self.addSubview(quit_button)
        quit_button.topAnchor.constraint(equalTo: quit_text.bottomAnchor, constant: 16).isActive = true
        quit_button.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    }

    
    @objc private func clickReregister(_ sender:UIButton) {
        nevermindDelegate?.clickReregister() // LimboViewController
    }
    
    
    @objc private func clickQuit(_ sender:UIButton) {
        nevermindDelegate?.clickQuit()
    }
}

protocol NevermindDelegate {
    func clickReregister()
    func clickQuit()
}
