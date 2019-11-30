//
//  LegislatorUI.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/20/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class LegislatorUI: UIView, UITableViewDataSource, UITableViewDelegate {
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var legislator : Legislator?
    var officesTable : UITableView?
    var offices = [Legislator.Office]()
    var ref : DatabaseReference?
    var legislatorDelegate : LegislatorDelegate? // defined at bottom
    
    
    let profilePic : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let legislatorType : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    
    let legislatorName : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    
    let legislatorParty : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    
    let selectLegislatorButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectLegislator(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let legislatorDistrict : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
    }()
    
    
    let facebookButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("FB: -", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openFacebook(_:)), for: .touchUpInside)
        return button
    }()

    let editFacebookButton : UIButton = {
        let button = UIButton(type: .system)
        //icons come from material.io/icons
        button.setImage(UIImage(named: "baseline_edit_black_18dp"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editFacebook(_:)), for: .touchUpInside)
        return button
    }()
    
    
    let twitterButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Twitter: -", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openTwitter(_:)), for: .touchUpInside)
        return button
    }()
    
    let editTwitterButton : UIButton = {
        let button = UIButton(type: .system)
        //icons come from material.io/icons
        button.setImage(UIImage(named: "baseline_edit_black_18dp"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editTwitter(_:)), for: .touchUpInside)
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
    
    // #3
    /*********
    public convenience init(image: UIImage, title: String) {
        self.init(frame: .zero)
        setupView()
    }
     *********/
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        // Create, add and layout to the children views ...
        
        addSubview(legislatorType)
        legislatorType.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        legislatorType.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        addSubview(legislatorName)
        legislatorName.bottomAnchor.constraint(equalTo: legislatorType.bottomAnchor, constant: 0).isActive = true
        legislatorName.leadingAnchor.constraint(equalTo: legislatorType.trailingAnchor, constant: 4).isActive = true
        
        addSubview(legislatorParty)
        legislatorParty.bottomAnchor.constraint(equalTo: legislatorName.bottomAnchor, constant: 0).isActive = true
        legislatorParty.leadingAnchor.constraint(equalTo: legislatorName.trailingAnchor, constant: 4).isActive = true
        
        addSubview(selectLegislatorButton)
        selectLegislatorButton.centerYAnchor.constraint(equalTo: legislatorName.centerYAnchor, constant: 0).isActive = true
        selectLegislatorButton.leadingAnchor.constraint(equalTo: legislatorParty.trailingAnchor, constant: 4).isActive = true
        
        addSubview(legislatorDistrict)
        legislatorDistrict.topAnchor.constraint(equalTo: legislatorType.bottomAnchor, constant: 8).isActive = true
        legislatorDistrict.leadingAnchor.constraint(equalTo: legislatorType.leadingAnchor, constant: 0).isActive = true
        
        // See SidePanelViewController at the bottom for 3 extensions to UIImage and UIImageView that allow us to
        // display profile pics as cool circular images
        addSubview(profilePic)
        if let leg = legislator {
            let picUrl = leg.getPhotoURL().absoluteString
            profilePic.image(fromUrl: picUrl)
        }
        profilePic.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profilePic.topAnchor.constraint(equalTo: legislatorDistrict.bottomAnchor, constant: 8).isActive = true
        
        addSubview(facebookButton)
        facebookButton.topAnchor.constraint(equalTo: legislatorDistrict.bottomAnchor, constant: 8).isActive = true
        facebookButton.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 16).isActive = true
        
        addSubview(editFacebookButton)
        editFacebookButton.centerYAnchor.constraint(equalTo: facebookButton.centerYAnchor, constant: 0).isActive = true
        editFacebookButton.leadingAnchor.constraint(equalTo: facebookButton.trailingAnchor, constant: 16).isActive = true
        
        addSubview(twitterButton)
        twitterButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 8).isActive = true
        twitterButton.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 16).isActive = true
        
        addSubview(editTwitterButton)
        editTwitterButton.centerYAnchor.constraint(equalTo: twitterButton.centerYAnchor, constant: 0).isActive = true
        editTwitterButton.leadingAnchor.constraint(equalTo: twitterButton.trailingAnchor, constant: 16).isActive = true
        
        // doesn't seem to do anything
        officesTable?.estimatedRowHeight = 144.0
        officesTable?.rowHeight = UITableView.automaticDimension
    }
    
    
    @objc func openFacebook(_ sender: Any) {
        Util.openFacebook(legislator: legislator)
    }
    
    
    @objc func openTwitter(_ sender: Any) {
        Util.openTwitter(legislator: legislator)
    }
    
    
    // legislatorDelegate is EditLegislatorForVideoVC
    @objc func selectLegislator(_ sender: Any) {
        if let legislator = legislator {
            legislatorDelegate?.legislatorSelected(legislator: legislator)
        }
    }
    
    
    func setLegislator(legislator: Legislator) {
        self.legislator = legislator
        legislatorType.text = legislator.chamber == "lower" ?  "Rep" : "Sen"
        legislatorName.text = legislator.first_name + " " + legislator.last_name
        let firstChar = legislator.party.prefix(1)
        legislatorParty.text = "(\(firstChar))"
        let distAbbrev = legislator.chamber == "lower" ?  "HD" : "SD"
        legislatorDistrict.text = distAbbrev + " " + legislator.district
        
        // See SidePanelViewController at the bottom for 3 extensions to UIImage and UIImageView that allow us to
        // display profile pics as cool circular images
        profilePic.legislatorImage(fromUrl: legislator.getPhotoURL().absoluteString)
        
        if let legislator_facebook = legislator.legislator_facebook {
            facebookButton.setTitle("FB: @\(legislator_facebook)", for: .normal)
        }
        else {
            facebookButton.setTitle("FB: -", for: .normal)
        }
        
        if let legislator_twitter = legislator.legislator_twitter {
            twitterButton.setTitle("TW: @\(legislator_twitter)", for: .normal)
        }
        else {
            twitterButton.setTitle("TW: -", for: .normal)
        }
        
        offices.removeAll()
        offices.append(contentsOf: legislator.offices)
        
        // why do coordinates come back 0 for the labels and buttons?  I could figure out the y value for
        // the office list if these values weren't 0
        let yOfficeList = 135
        
        // remove if one exists already...
        if let ot = officesTable {
            ot.removeFromSuperview()
        }
        
        let rectOfficeList = CGRect(
            origin: CGPoint(x: 0, y: yOfficeList),
            size: CGSize(width: self.frame.width-16, height: CGFloat(legislator.offices.count * 125))
        )
        
        officesTable = UITableView(frame: rectOfficeList, style: .plain) // <--- this turned out to be key
        officesTable?.backgroundColor = .clear
        officesTable?.isScrollEnabled = false
        officesTable?.dataSource = self
        officesTable?.delegate = self
        officesTable?.rowHeight = 100
        officesTable?.register(OfficeTableViewCell.self, forCellReuseIdentifier: "cellId")
        /*****/
        addSubview(officesTable!)
        //officesTable!.topAnchor.constraint(equalTo: legislatorName.bottomAnchor, constant: 8).isActive = true
        officesTable!.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        officesTable!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        officesTable!.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0.25).isActive = true
        officesTable!.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.95).isActive = true
        /******/
        
        DispatchQueue.main.async {
            self.officesTable?.reloadData()
        }
    }
     
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offices.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = officesTable?.dequeueReusableCell(withIdentifier: "cellId",
                                                      for: indexPath as IndexPath) as! OfficeTableViewCell
        
        if let legislator = legislator {
            
            let office = offices[indexPath.row]
            
            // Most other examples of this method pass a DatabaseReference object
            // to the commonInit() method.  In this case, we don't need to
            cell.commonInit(legislator: legislator, office: office /*, ref: ref!*/)
            
        }
        
        return cell
     }
    
    
    /************ can't get dynamic row heights to work ***/
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // optionally, return an calculated estimate for the cell heights
        return 200
    }
    /************/
    
    
    // search for legislatorDelegate to see what classes act as the legislatorDelegate
    @objc func editFacebook(_ sender: Any) {
        if let del = legislatorDelegate, let legislator = legislator {
            del.editSocialMedia(legislator: legislator, handle: legislator.legislator_facebook, handleType: "Facebook")
        }
    }
    
    
    // search for legislatorDelegate to see what classes act as the legislatorDelegate
    @objc func editTwitter(_ sender: Any) {
        if let del = legislatorDelegate, let legislator = legislator {
            del.editSocialMedia(legislator: legislator, handle: legislator.legislator_twitter, handleType: "Twitter")
        }
    }

}

// so far (5/19/18) EditLegislatorForVideoVC is the only class that implements this
protocol LegislatorDelegate {
    func legislatorSelected(legislator: Legislator)
    func editSocialMedia(legislator: Legislator, handle: String?, handleType: String?)
}
