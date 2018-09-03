//
//  VideoOfferCell.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 8/31/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit

class VideoOfferCell: UITableViewCell {

    var offer : VideoOffer?
    
    let offer_to_go_on_video_heading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .black
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Offer to Go on Video"
        return l
    }()
    
    let date : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .gray
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = ""
        return l
    }()
    
//    let profilePic : UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    let name : UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 16) //UIFont(name: (textView.font?.fontName)!, size: 16)
        //textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
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
    
    let phone_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .black
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Phone: "
        return l
    }()
    
    let phone = CallButton(text: "")
    
    let senate_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .black
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Senate: "
        return l
    }()
    
    let senate_state : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .black
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = ""
        return l
    }()
    
    let state_upper_district : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .black
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = ""
        return l
    }()
    
    let house_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .black
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "House: "
        return l
    }()
    
    let house_state : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .black
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = ""
        return l
    }()
    
    let state_lower_district : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .black
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = ""
        return l
    }()
    
    let address_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        l.textColor = .black
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Address"
        return l
    }()
    
    let residential_address_line1 : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = ""
        return l
    }()
    
    let residential_address_city : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = ""
        return l
    }()
    
    let residential_address_state_abbrev : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 16)
        //l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = ""
        return l
    }()
    
    
    // CallButton is poorly named.  It just creates a button with the color of a link
    let email = CallButton(text: "email")
    
    
    let delete_button : BaseButton = {
        let button = BaseButton(text: "Delete")
        button.titleLabel?.font = button.titleLabel?.font.withSize(16)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    
    func commonInit(offer: VideoOffer) {
        
        self.offer = offer
        
        self.addSubview(offer_to_go_on_video_heading)
        offer_to_go_on_video_heading.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        offer_to_go_on_video_heading.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        
        self.addSubview(date)
        date.topAnchor.constraint(equalTo: offer_to_go_on_video_heading.bottomAnchor, constant: 16).isActive = true
        date.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(name)
        name.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 16).isActive = true
        name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        name.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        
        self.addSubview(phone_label)
        phone_label.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 16).isActive = true
        phone_label.leadingAnchor.constraint(equalTo: name.leadingAnchor, constant: 0).isActive = true
        
        self.addSubview(phone)
        phone.centerYAnchor.constraint(equalTo: phone_label.centerYAnchor, constant: 0).isActive = true
        phone.leadingAnchor.constraint(equalTo: phone_label.trailingAnchor, constant: 8).isActive = true
        phone.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
        
        self.addSubview(senate_label)
        senate_label.topAnchor.constraint(equalTo: phone_label.bottomAnchor, constant: 8).isActive = true
        senate_label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(senate_state)
        senate_state.bottomAnchor.constraint(equalTo: senate_label.bottomAnchor, constant: 0).isActive = true
        senate_state.leadingAnchor.constraint(equalTo: senate_label.trailingAnchor, constant: 8).isActive = true
        
        self.addSubview(state_upper_district)
        state_upper_district.bottomAnchor.constraint(equalTo: senate_label.bottomAnchor, constant: 0).isActive = true
        state_upper_district.leadingAnchor.constraint(equalTo: senate_state.trailingAnchor, constant: 2).isActive = true
        
        self.addSubview(house_label)
        house_label.topAnchor.constraint(equalTo: senate_label.bottomAnchor, constant: 8).isActive = true
        house_label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(house_state)
        house_state.bottomAnchor.constraint(equalTo: house_label.bottomAnchor, constant: 0).isActive = true
        house_state.leadingAnchor.constraint(equalTo: house_label.trailingAnchor, constant: 8).isActive = true
        
        self.addSubview(state_lower_district)
        state_lower_district.bottomAnchor.constraint(equalTo: house_label.bottomAnchor, constant: 0).isActive = true
        state_lower_district.leadingAnchor.constraint(equalTo: house_state.trailingAnchor, constant: 2).isActive = true
        
        self.addSubview(address_label)
        address_label.topAnchor.constraint(equalTo: house_label.bottomAnchor, constant: 8).isActive = true
        address_label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(residential_address_line1)
        residential_address_line1.topAnchor.constraint(equalTo: address_label.bottomAnchor, constant: 4).isActive = true
        residential_address_line1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(residential_address_city)
        residential_address_city.topAnchor.constraint(equalTo: residential_address_line1.bottomAnchor, constant: 4).isActive = true
        residential_address_city.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        self.addSubview(residential_address_state_abbrev)
        residential_address_state_abbrev.bottomAnchor.constraint(equalTo: residential_address_city.bottomAnchor, constant: 0).isActive = true
        residential_address_state_abbrev.leadingAnchor.constraint(equalTo: residential_address_city.trailingAnchor, constant: 16).isActive = true
        
        self.addSubview(email)
        email.topAnchor.constraint(equalTo: residential_address_city.bottomAnchor, constant: 8).isActive = true
        email.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        email.addTarget(self, action: #selector(clickEmail(_:)), for: .touchUpInside)
        
        self.addSubview(delete_button)
        delete_button.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 32).isActive = true
        delete_button.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        
        
        
        if let thename = offer.name {
            if let thedate = offer.date {
                date.text = thedate
            }
            name.text = "\(thename) has offered to go on camera and shoot a video for COS.  Call \(thename) at the number below and set a time that you two can get together for a video call."
            if let ph = offer.phone {
                phone.setTitle(ph, for: .normal)
            }
            if let thestate = offer.residential_address_state_abbrev {
                senate_state.text = thestate.uppercased()+" SD "
                house_state.text = thestate.uppercased()+" HD "
                residential_address_state_abbrev.text = thestate.uppercased()
                if thestate.uppercased() == "NE" {
                    house_label.removeFromSuperview()
                    house_state.removeFromSuperview()
                    state_lower_district.removeFromSuperview()
                }
            }
            if let hd = offer.state_lower_district {
                state_lower_district.text = hd
            }
            if let sd = offer.state_upper_district {
                state_upper_district.text = sd
            }
            if let line1 = offer.residential_address_line1 {
                residential_address_line1.text = line1
            }
            if let val = offer.residential_address_city {
                residential_address_city.text = val
            }
            if let val = offer.email {
                email.setTitle(val, for: .normal)
            }
        }
    }
    
    @objc private func makeCall(_ sender:UIButton) {
        if let label = sender.titleLabel, let phoneNum = label.text, let url = URL(string: "tel://"+phoneNum) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func clickEmail(_ sender:UIButton) {
        if let label = sender.titleLabel, let email = label.text, let url = URL(string: "mailto:"+email) {
            UIApplication.shared.open(url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
