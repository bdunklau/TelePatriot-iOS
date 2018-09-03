//
//  VideoOfferVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 9/1/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

class VideoOfferVC: BaseViewController {
    
    var scrollView : UIScrollView?
    var offer : VideoOffer?
    
    let name : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "x"
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let senate_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Senate: "
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let senate_state : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let state_upper_district : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let house_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "House: "
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let house_state : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let state_lower_district : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let address_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Address"
        //l.font = l.font.withSize(18)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    let address : UITextView = {
        let textView = UITextView()
        textView.text = "-"
        textView.font = textView.font?.withSize(16)
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
    
    // Is email address actually useful here?
//    let email : UILabel = {
//        let l = UILabel()
//        l.translatesAutoresizingMaskIntoConstraints = false
//        l.text = "x"
//        //l.font = l.font.withSize(18)
//        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
//        return l
//    }()
    
    let phone : BaseButton = {
        let button = BaseButton(text: "Phone")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickPhone(_:)), for: .touchUpInside)
        return button
    }()
    
    
                
    let offer_instructions : UITextView = {
        let textView = UITextView()
        textView.text = "Call this person and set up time for the two of you to do a video call"
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        var frame = textView.frame
        frame.size.height = 24
        textView.frame = frame
        textView.backgroundColor = .clear
        
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 32, width: self.view.frame.width, height: self.view.frame.height))
        if let scrollView = scrollView, let offer = offer {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
            
            scrollView.addSubview(name)
            name.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
            name.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(phone)
            phone.bottomAnchor.constraint(equalTo: name.bottomAnchor, constant: 8).isActive = true
            phone.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 96).isActive = true
            
            scrollView.addSubview(senate_label)
            senate_label.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8).isActive = true
            senate_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(senate_state)
            senate_state.bottomAnchor.constraint(equalTo: senate_label.bottomAnchor, constant: 0).isActive = true
            senate_state.leadingAnchor.constraint(equalTo: senate_label.trailingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(state_upper_district)
            state_upper_district.bottomAnchor.constraint(equalTo: senate_state.bottomAnchor, constant: 0).isActive = true
            state_upper_district.leadingAnchor.constraint(equalTo: senate_state.trailingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(house_label)
            house_label.topAnchor.constraint(equalTo: senate_label.bottomAnchor, constant: 8).isActive = true
            house_label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(house_state)
            house_state.bottomAnchor.constraint(equalTo: house_label.bottomAnchor, constant: 0).isActive = true
            house_state.leadingAnchor.constraint(equalTo: house_label.trailingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(state_lower_district)
            state_lower_district.bottomAnchor.constraint(equalTo: house_state.bottomAnchor, constant: 0).isActive = true
            state_lower_district.leadingAnchor.constraint(equalTo: house_state.trailingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(address_heading)
            address_heading.topAnchor.constraint(equalTo: house_label.bottomAnchor, constant: 8).isActive = true
            address_heading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
            
            scrollView.addSubview(address)
            address.topAnchor.constraint(equalTo: address_heading.bottomAnchor, constant: 8).isActive = true
            address.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4).isActive = true
            
            name.text = offer.name
            DispatchQueue.main.async {
                self.phone.setTitle(offer.phone, for: .normal)
            }
            
            if let residential_address_state_abbrev = offer.residential_address_state_abbrev {
                senate_state.text = residential_address_state_abbrev.uppercased()
                house_state.text = residential_address_state_abbrev.uppercased()
            }
            if let val = offer.state_upper_district {
                state_upper_district.text = val
            }
            if let val = offer.state_lower_district {
                state_lower_district.text = val
            }
            if let val = offer.residential_address_line1 {
                address.text = val
            }
            if let val = offer.residential_address_city {
                address.text = address.text+"\n"+val
            }
            if let val = offer.residential_address_state_abbrev {
                address.text = address.text+", "+val.uppercased()
            }
            
            view.addSubview(scrollView)
        }
    }
    
    @objc private func clickPhone(_ sender:UIButton) {
        print(sender.titleLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
