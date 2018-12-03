//
//  SwitchTeamsVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/16/17.
//  Copyright © 2017 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class SwitchTeamsVC: BaseViewController {
    
    var teams = [Team]()
    var cbTeams = [CBTeam]()
    var useCB = true // false means get team list from TelePatriot/Firebase database
    
    let cellId = "cellId"
    
    var teamTableView: UITableView?
    
    var ref : DatabaseReference?
    
    var switchTeamsDelegate : SwitchTeamsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let uid = TPUser.sharedInstance.getUid()
//        ref = Database.database().reference().child("users/\(uid)/teams")
        
        Database.database().reference().child("administration/configuration").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            if let vals = snapshot.value as? [String:Any],
                let get_teams_from = vals["get_teams_from"] as? String,
                let envName = vals["environment"] as? String,
                let environment = vals[envName] as? [String:Any],
                let apiKeyName = environment["citizen_builder_api_key_name"] as? String,
                let apiKeyValue = environment["citizen_builder_api_key_value"] as? String,
                let domain = environment["citizen_builder_domain"] as? String,
                let cbid = TPUser.sharedInstance.citizen_builder_id {
                
                if get_teams_from == "citizenbuilder" {
                    self.useCB = true
                    self.fromCitizenBuilder(cbid: cbid, apiKeyName: apiKeyName, apiKeyValue: apiKeyValue, domain: domain)
                }
                else {
                    self.useCB = false
                    // get from telepatriot/firebase database
                    self.fromTelePatriot(uid: uid)
                }
                
                self.teamTableView = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
                self.teamTableView?.dataSource = self
                self.teamTableView?.delegate = self
                self.teamTableView?.register(TeamTableViewCell.self, forCellReuseIdentifier: "cellId")
                
                // blank header view is the "Clayton Bink" fix.  For some reason, his phone wasn't showing the list of
                // teams properly under the gray nav bar.  So this header view is just for some padding.
                let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
                self.teamTableView?.tableHeaderView = headerView
                //teamTableView?.rowHeight = 150
                self.view.addSubview(self.teamTableView!)
                
                if self.useCB {
                    self.fetchData()
                }
            }
            
        })
        
        
    }
    
    private func fromCitizenBuilder(cbid: Int32, apiKeyName: String, apiKeyValue: String, domain: String) {
        
//        Ex:
//        https://api.qacos.com/api/ios/v1/teams/person_teams?person_id=1329
        
        guard let url = URL(string: "https://\(domain)/api/ios/v1/teams/person_teams?person_id=\(cbid)") else {
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKeyValue, forHTTPHeaderField: apiKeyName)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, responseError) in
            
            let decoder = JSONDecoder()
            let c = try! decoder.decode(CBTeams.self, from: data!)
            if let teamList = c.teams {
                self.cbTeams = teamList

                DispatchQueue.main.async {
                    self.teamTableView?.reloadData()
                }
            }
        }
        
        task.resume()
    }
    
    private func fromTelePatriot(uid: String) {
        ref = Database.database().reference().child("users/\(uid)/teams")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchData() {
        //teams.removeAll()
        
        Database.database().reference().queryOrdered(byChild: "team_name").observe(.childAdded, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {
                return
            }
            
            guard let team_name = dictionary["team_name"] as? String else {
                return
            }
            
            let team = Team(team_name: team_name)
            
            // you'll get duplicate/phantom team entries without this.  That's because we explicitly
            // call viewDidLoad() in CenterViewController.doView()
            guard self.findIndex(teams: self.teams, team: team) == nil else {
                return
            }
            
            self.teams.append(team)
            print(team)
            DispatchQueue.main.async {
                self.teamTableView?.reloadData()
            }
            
        }, withCancel: nil)
        
        
        Database.database().reference().observe(.childRemoved, with: {(snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else {
                return
            }
            
            guard let team_name = dictionary["team_name"] as? String else {
                return
            }
            
            let team = Team(team_name: team_name)
            
            // find the team in the array and remove it
            guard let index = self.findIndex(teams: self.teams, team: team) else {
                return
            }
            
            self.teams.remove(at: index)
            print(team)
            DispatchQueue.main.async {
                self.teamTableView?.reloadData()
            }
        })
    }
    
    func findIndex(teams: [Team], team: Team) -> Int? {
        var i = 0
        for t in self.teams {
            if t.team_name == team.team_name {
                return i
            }
            i = i + 1
        }
        return nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func getTeam(index: Int) -> TeamIF {
        if useCB {
            return cbTeams[index]
        }
        else {
            return teams[index]
        }
    }

}

extension SwitchTeamsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // transitional code - once TelePatriot is talking to CB permanently, this if/else won't be needed
        if useCB {
            return cbTeams.count // the new way, where team info is stored in CB
        }
        else {
            return teams.count // the old way, where we keep teams at /users/{uid}/teams
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = teamTableView?.dequeueReusableCell(withIdentifier: "cellId",
                                                      for: indexPath as IndexPath) as! TeamTableViewCell
        
        
//        let team = teams[indexPath.row]
        let team = getTeam(index: indexPath.row)
        cell.commonInit(team: team, ref: ref)
        
        return cell
    }
}

extension SwitchTeamsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the team on this row
//        let team = teams[indexPath.row]
        let team = getTeam(index: indexPath.row)
        switchTeamsDelegate?.teamSelected(team: team) // delegate set in ContainerViewController.viewDidLoad()
    }
}
