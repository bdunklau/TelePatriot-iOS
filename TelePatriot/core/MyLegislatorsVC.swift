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
    
    
    
    
    let myLegislatorsHeading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "My Legislators"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    var senatorView : LegislatorUI?
    var houserepView : LegislatorUI?
    
    
    
    let locationButton : BaseButton = {
        let button = BaseButton(text: "Capture Location")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureLocation(_:)), for: .touchUpInside)
        return button
    }()
    
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
    
    let speed : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var scrollView : UIScrollView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if scrollView != nil {
            //scrollView?.removeFromSuperview()
            return // this may be better
        }
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView?.contentSize = CGSize(width: 250, height: 1450)
        
        view.addSubview(scrollView!)
        
        
        scrollView?.addSubview(locationButton)
        locationButton.topAnchor.constraint(equalTo: (scrollView?.topAnchor)!, constant: 8).isActive = true
        locationButton.centerXAnchor.constraint(equalTo: (scrollView?.centerXAnchor)!).isActive = true
        //locationButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        //locationButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        scrollView?.addSubview(myLegislatorsHeading)
        myLegislatorsHeading.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 16).isActive = true
        myLegislatorsHeading.leadingAnchor.constraint(equalTo: (scrollView?.leadingAnchor)!, constant: 8).isActive = true
        //myAddressHeading.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        //myAddressHeading.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        /*******/
        let senatorViewY = myLegislatorsHeading.frame.origin.y + myLegislatorsHeading.frame.height + 8
        
        let rectSenator = CGRect(
            origin: CGPoint(x: myLegislatorsHeading.frame.origin.x, y: senatorViewY),
            size: CGSize(width: (scrollView?.frame.width)!-16, height: 200)
        )
        
        
        senatorView = LegislatorUI(frame: rectSenator)
        scrollView?.addSubview(senatorView!)
        senatorView?.topAnchor.constraint(equalTo: myLegislatorsHeading.bottomAnchor, constant: 16).isActive = true
        senatorView?.leadingAnchor.constraint(equalTo: (scrollView?.leadingAnchor)!, constant: 8).isActive = true
        senatorView?.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.95).isActive = true
        /********/
        
        let houseRepViewY = (senatorView?.frame.origin.y)! + (senatorView?.frame.height)! + 32
        
        let rectHouseRep = CGRect(
            origin: CGPoint(x: myLegislatorsHeading.frame.origin.x, y: houseRepViewY),
            size: CGSize(width: (scrollView?.frame.width)!-16, height: 200)
        )
        
        houserepView = LegislatorUI(frame: rectHouseRep)
        scrollView?.addSubview(houserepView!)
        houserepView?.topAnchor.constraint(equalTo: (senatorView?.bottomAnchor)!, constant: 48).isActive = true
        houserepView?.leadingAnchor.constraint(equalTo: (scrollView?.leadingAnchor)!, constant: 8).isActive = true
        houserepView?.widthAnchor.constraint(equalTo: (scrollView?.widthAnchor)!, multiplier: 0.95).isActive = true
        
        
        /************
         view.addSubview(lat)
         lat.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
         lat.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
         
         view.addSubview(lng)
         lng.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
         lng.topAnchor.constraint(equalTo: lat.bottomAnchor, constant: 8).isActive = true
         
         view.addSubview(address)
         address.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
         address.topAnchor.constraint(equalTo: lng.bottomAnchor, constant: 160).isActive = true
         
         view.addSubview(legislatorView)
         legislatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
         legislatorView.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 8).isActive = true
         **************/
        
        
        /*****************
         // cool - but don't need this
         view.addSubview(speed)
         speed.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
         speed.bottomAnchor.constraint(equalTo: address.topAnchor, constant: -16).isActive = true
         ***************/
        
        //locationTuples = [(sourceField, nil), (destinationField1, nil), (destinationField2, nil)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func captureLocation(_ sender: UIButton) {
        //guard user != nil else {return}
        
        guard let lati = latitude,
            let longi = longitude else { return }
        
        
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
            
            /*************
             var resultFromServer: Any?
             resultFromServer = try? JSONSerialization.jsonObject(with: data!, options: [.allowFragments])
             print( String(describing: type(of: resultFromServer)) )
             //print(resultFromServer)
             
             guard let array = resultFromServer as? [[String: Any]] else {
             return
             }
             
             print( String(describing: type(of: array)) )
             ***********/
            
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
        
        /***************
         //creating a NSURL
         guard let url = URL(string: "https://openstates.org/api/v1/legislators/geo/?lat=\(lati)&long=\(longi)&apikey=aad44b39-c9f2-4cc5-a90a-e0503e5bdc3c") else { return }
         
         //fetching the data from the url
         URLSession.shared.dataTask(with: url) {(data, response, error) in
         guard let data = data else {
         return}
         
         print("data = \(data)")
         
         do {
         guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
         as? [String: Any] else {
         return}
         print("json = \(json)")
         print("1")
         }
         catch {
         
         }
         
         }.resume()
         ***********/
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
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
        speed.text = "Speed: \(userLocation.speed.magnitude)"
        
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            //print(placeMark.addressDictionary ?? "address n/a", terminator: "")
            
            guard let plc = placeMark,
                let addrDict = placeMark.addressDictionary else {
                    return
            }
            
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                self.currentStreetAddress = locationName as String
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                //print(street, terminator: "")
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.currentCity = city as String
            }
            
            // state
            if let state = placeMark.addressDictionary!["State"] as? NSString {
                self.currentState = state as String
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                self.currentZip = zip as String
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                //print(country, terminator: "")
            }
            
            //self.address.text = self.address.text! + "\(placeMark.addressDictionary)"
            
        })
        
        
        
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as!
            [String]).joined(separator: ", ")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    /**********
     
     *********/
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

