//
//  LegislatorUI.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/20/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class LegislatorUI: UIView, UITableViewDataSource {
    

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
    
    
    let legislatorDistrict : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        return l
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
        /**********/
        // Create, add and layout the children views ..
        addSubview(legislatorType)
        legislatorType.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        legislatorType.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        addSubview(legislatorName)
        legislatorName.topAnchor.constraint(equalTo: legislatorType.topAnchor, constant: 0).isActive = true
        legislatorName.leadingAnchor.constraint(equalTo: legislatorType.trailingAnchor, constant: 4).isActive = true
        
        addSubview(legislatorParty)
        legislatorParty.topAnchor.constraint(equalTo: legislatorName.topAnchor, constant: 0).isActive = true
        legislatorParty.leadingAnchor.constraint(equalTo: legislatorName.trailingAnchor, constant: 4).isActive = true
        
        addSubview(legislatorDistrict)
        legislatorDistrict.topAnchor.constraint(equalTo: legislatorName.topAnchor, constant: 0).isActive = true
        legislatorDistrict.leadingAnchor.constraint(equalTo: legislatorParty.trailingAnchor, constant: 4).isActive = true
         /*******/
        
        
        let yOfficeList = legislatorDistrict.frame.origin.y + legislatorDistrict.frame.height + 16
        
        let rectOfficeList = CGRect(
            origin: CGPoint(x: legislatorName.frame.origin.x, y: yOfficeList),
            size: CGSize(width: self.frame.width-16, height: 300)
        )
        
        officesTable = UITableView(frame: rectOfficeList, style: .plain) // <--- this turned out to be key
        officesTable?.backgroundColor = .clear
        officesTable?.isScrollEnabled = false
        officesTable?.dataSource = self
        //officesTable?.delegate = self
        officesTable?.rowHeight = 125
        officesTable?.register(OfficeTableViewCell.self, forCellReuseIdentifier: "cellId")
        /*****/
        addSubview(officesTable!)
        //officesTable!.topAnchor.constraint(equalTo: legislatorName.bottomAnchor, constant: 8).isActive = true
        officesTable!.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        officesTable!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        officesTable!.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0.25).isActive = true
        officesTable!.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.95).isActive = true
         /******/
    }
    
    
    func setLegislator(legislator: Legislator) {
        self.legislator = legislator
        legislatorType.text = legislator.chamber == "lower" ?  "Rep" : "Sen"
        legislatorName.text = legislator.first_name + " " + legislator.last_name
        let firstChar = legislator.party.prefix(1)
        legislatorParty.text = "(\(firstChar))"
        let distAbbrev = legislator.chamber == "lower" ?  "HD" : "SD"
        legislatorDistrict.text = distAbbrev + " " + legislator.district
        
        offices.removeAll()
        offices.append(contentsOf: legislator.offices)
        
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
    

}
