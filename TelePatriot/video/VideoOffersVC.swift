//
//  VideoOfferVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 8/31/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

/**
 View controller for looking at offers others have made to shoot a video
 This is people saying "Hey I'll go on camera - call me"
 **/
class VideoOffersVC: BaseViewController {

    var offers = [VideoOffer]()
    var offerTable: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("video/offers").queryOrdered(byChild: "date_ms")
            .observeSingleEvent(of: .value, with: {(snapshot) in
                let t = type(of: snapshot.value)
                print("snapshot.value is a \(t)")
                guard let /*dictionary*/ _ = snapshot.value as? [String : Any] else {
                    self.offers = [VideoOffer]()
                    DispatchQueue.main.async { self.offerTable?.reloadData() }
                    return
                }
                // dictionary is a collection of key value pairs.  The keys are the really long video invitation key
                // The value mapped to each key is the itself a collection of key/value pairs - they are the attribute names
                // and values of each invitation
                self.offers = VideoOffer.createOffers(snapshot: snapshot)
                
                DispatchQueue.main.async {
                    self.offerTable?.reloadData()
                }
                
            }, withCancel: nil)
        
        offerTable = UITableView(frame: self.view.bounds, style: .plain) // <--- this turned out to be key
        offerTable?.dataSource = self
        offerTable?.delegate = self
        offerTable?.register(VideoOfferCell.self, forCellReuseIdentifier: "cellId")
        offerTable?.rowHeight = 450
        view.addSubview(offerTable!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func deleteOffer(_ sender:UIButton) {
        let thetag = sender.tag
        let offer = offers[thetag]
        if let thename = offer.name {

            let title = "Delete Offer?"
            let message = "Delete this offer once \(thename) has completed the video, lost interest, or can't be reached"
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            let dontDelete = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }
            })

            let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    offer.delete()
                }
            })

            alert.addAction(dontDelete)
            alert.addAction(delete)

            self.present(alert, animated: true, completion: nil)
            
        }
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

extension VideoOffersVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = offerTable?.dequeueReusableCell(withIdentifier: "cellId",
                                                        for: indexPath as IndexPath) as! VideoOfferCell
        
        let offer = offers[indexPath.row]
        cell.commonInit(offer: offer)
//        cell.accessoryType = .disclosureIndicator  // this is how you get the little chevron pointing to the right
        cell.delete_button.tag = indexPath.row
        cell.delete_button.addTarget(self, action: #selector(deleteOffer(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the team on this row
        let offer = offers[indexPath.row]
        
        // this is where you WOULD do something with the selected row.  But in this case,
        // we already present all the data required to act.  The table view in this view controller has
        // really rows
    }
}

extension VideoOffersVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
}

