//
//  MyProfileVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/18/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

// In this class, Foundation makes the compiler recognize that NSDictionary and Dictionary
// objects are basically the same thing
import Foundation
import UIKit
import CoreLocation
import MapKit


class MyLegislatorsVC: BaseViewController, CLLocationManagerDelegate {
    
    
    var locationManager:CLLocationManager!
    var latitude : Double?
    var longitude : Double?
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    // not your residential address, just wherever you are at the moment
    var currentStreetAddress : String?
    var currentCity : String?
    var currentState : String?
    var currentZip : String?
    
    var addressUpdater : AddressUpdater? // defined at bottom
    
    var senatorView : LegislatorUI?
    var houserepView : LegislatorUI?
    
    let lat : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let lng : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var addressNeededView : AddressNeededView?
    
    
    var scrollView : UIScrollView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        if TPUser.sharedInstance.hasStoredLocation() {
            createViewWhenAddressIsKnown()
        }
        else {
            createViewWhenAddressIsUnknown()
        }
    }
    
    private func initView() {
        if scrollView != nil {
            scrollView?.removeFromSuperview()
        }
        
        if addressNeededView != nil {
            addressNeededView?.removeFromSuperview()
        }
    }
    
    private func createViewWhenAddressIsUnknown() {
        
        addressNeededView = AddressNeededView(frame: self.view.frame)
        addressNeededView?.addressUpdater = self
        view.addSubview(addressNeededView!)
    }
    
    private func createViewWhenAddressIsKnown() {
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView?.contentSize = CGSize(width: self.view.frame.width, height: 1450)
        
        view.addSubview(scrollView!)
        
        /*******/
        let senatorViewY = /*myLegislatorsHeading.frame.origin.y + myLegislatorsHeading.frame.height + */ 8
        
        let rectSenator = CGRect(
            origin: CGPoint(x: 0/*myLegislatorsHeading.frame.origin.x*/, y: senatorViewY),
            size: CGSize(width: (scrollView?.frame.width)!-16, height: 200)
        )
        
        
        senatorView = LegislatorUI(frame: rectSenator)
        scrollView?.addSubview(senatorView!)
        senatorView?.topAnchor.constraint(equalTo: (scrollView?.topAnchor)!, constant: 16).isActive = true
        senatorView?.leadingAnchor.constraint(equalTo: (scrollView?.leadingAnchor)!, constant: 8).isActive = true
        senatorView?.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.95).isActive = true
        /********/
        
        let houseRepViewY = (senatorView?.frame.origin.y)! + (senatorView?.frame.height)! + 32
        
        let rectHouseRep = CGRect(
            origin: CGPoint(x: 0/*myLegislatorsHeading.frame.origin.x*/, y: houseRepViewY),
            size: CGSize(width: (scrollView?.frame.width)!-16, height: 200)
        )
        
        houserepView = LegislatorUI(frame: rectHouseRep)
        scrollView?.addSubview(houserepView!)
        houserepView?.topAnchor.constraint(equalTo: (senatorView?.bottomAnchor)!, constant: 48).isActive = true
        houserepView?.leadingAnchor.constraint(equalTo: (scrollView?.leadingAnchor)!, constant: 8).isActive = true
        houserepView?.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.95).isActive = true
        
        doCaptureLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func doCaptureLocation() {
        
        //guard user != nil else {return}
        
        guard let lati = TPUser.sharedInstance.current_latitude,
            let longi = TPUser.sharedInstance.current_longitude else {
                return }
        
        
        lat.text = "Lat: \(lati)"
        lng.text = "Long: \(longi)"
        
        guard let url = URL(string: "https://openstates.org/api/v1/legislators/geo/?lat=\(lati)&long=\(longi)&apikey=aad44b39-c9f2-4cc5-a90a-e0503e5bdc3c") else { return }
        
        //guard let url = URL(string: "https://jsonplaceholder.typicode.com/albums") else { return }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (data, response, responseError) in
            
            let str = String(describing: type(of: data))
            print( "data is: \(str)"  )
            
            let decoder = JSONDecoder()
            let legislators = try? decoder.decode([Legislator].self, from: data!)
            
            DispatchQueue.main.async {
                for legislator in legislators! {
                    if legislator.chamber == "upper" {
                        self.senatorView?.setLegislator(legislator: legislator)
                    }
                    else if legislator.chamber == "lower" {
                        self.houserepView?.setLegislator(legislator: legislator)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        //print("user latitude = \(userLocation.coordinate.latitude)")
        //print("user longitude = \(userLocation.coordinate.longitude)")
        
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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


extension MyLegislatorsVC : AddressUpdater {
    func beginUpdatingAddressManually() {
        addressUpdater?.beginUpdatingAddressManually()
    }
    func beginUpdatingAddressUsingGPS() {
        addressUpdater?.beginUpdatingAddressUsingGPS()
    }
}


// CenterViewController is an AddressUpdater and the assignment is made in ContainerViewController
protocol AddressUpdater {
    func beginUpdatingAddressManually()
    func beginUpdatingAddressUsingGPS()
}

