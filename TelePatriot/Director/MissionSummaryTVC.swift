//
//  MissionSummaryTVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class MissionSummaryTVC: BaseViewController, UITableViewDataSource {
    // your firebase reference as a property
    //var rootRef: DatabaseReference!
    //var ref: DatabaseReference!
    // your data source, you can replace this with your own model if you wish
    //var items = [DataSnapshot]()
    var missions = [MissionSummary]()
    
    let cellId = "cellId"
    
    var missionSummaryTableView: UITableView?
    
    var ref : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO won't always be this...
        var team = "The Cavalry"
        ref = Database.database().reference().child("teams/\(team)/missions")
        
        missionSummaryTableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        missionSummaryTableView?.dataSource = self
        missionSummaryTableView?.register(MissionSummaryCellTableViewCell.self, forCellReuseIdentifier: "cellId")
        missionSummaryTableView?.rowHeight = 150
        view.addSubview(missionSummaryTableView!)
        
        fetchMissions() // <-- need to figure something out here because viewDidLoad() doesn't get
        // called each time we come to this screen.  That's because we add this viewcontroller to the
        // CenterViewController once, and then after that, the view doesn't need to be loaded
    }
    
    func fetchMissions() {
        ref?.observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
                let mission = MissionSummary()  //(snap: snapshot)
                //print(dictionary)
                //mission.setValuesForKeys(dictionary)
                mission.mission_id = snapshot.key
                mission.active = dictionary["active"] as? Bool
                mission.descrip = dictionary["description"] as? String
                mission.mission_create_date = dictionary["mission_create_date"] as? String
                mission.mission_name = dictionary["mission_name"] as? String
                mission.name = dictionary["name"] as? String
                mission.script = dictionary["script"] as? String
                mission.uid = dictionary["uid"] as? String
                mission.uid_and_active = dictionary["uid_and_active"] as? String
                mission.url = dictionary["url"] as? String
                
                
                /****/
                self.missions.append(mission)
                DispatchQueue.main.async{
                    self.missionSummaryTableView?.reloadData()
                }
                /****/
            }
            
            
        }, withCancel: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = missionSummaryTableView?.dequeueReusableCell(withIdentifier: "cellId",
                                                 for: indexPath as IndexPath) as! MissionSummaryCellTableViewCell
        
        
        let mission = missions[indexPath.row]
        cell.commonInit(missionSummary: mission, ref: ref!)
        
        return cell
    }
    
    /********
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
     *********/
    
}

/********************* think this can be deleted
class MissionSummaryCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
**********************/
