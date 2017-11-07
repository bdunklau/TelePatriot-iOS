//
//  MissionSummaryTVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 11/5/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class MissionSummaryTVC: UITableViewController {
    // your firebase reference as a property
    //var rootRef: DatabaseReference!
    //var ref: DatabaseReference!
    // your data source, you can replace this with your own model if you wish
    //var items = [DataSnapshot]()
    var missions = [MissionSummary]()
    
    let cellId = "cellId"
    
    @IBOutlet var missionSummaryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MissionSummaryCell.self, forCellReuseIdentifier: cellId)
        fetchMissions()
    }
    
    func fetchMissions() {
        Database.database().reference().child("missions").observe(.childAdded, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String : Any] {
                let mission = MissionSummary()  //(snap: snapshot)
                print(dictionary)
                //mission.setValuesForKeys(dictionary)
                
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
                    self.tableView.reloadData()
                }
                /****/
            }
            
            
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId",
                                                 for: indexPath as IndexPath)
        
        
        
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        
        
        let mission = missions[indexPath.row]
        cell.textLabel?.text = mission.mission_name
        cell.detailTextLabel?.text = "Created by "+mission.name!
        
        return cell
    }
    
}

class MissionSummaryCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
