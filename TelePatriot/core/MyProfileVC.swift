//
//  MyLegislatorsVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 1/22/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MyProfileVC: BaseViewController, CLLocationManagerDelegate {
    
    
    //var ref : DatabaseReference?
    var locationManager:CLLocationManager!
    var latitude : Double?
    var longitude : Double?
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    // not your residential address, just wherever you are at the moment
    var currentStreetAddress : String?
    var currentCity : String?
    var currentState : String?
    var currentZip : String?
    
    
    let myAddressHeading : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "My Address"
        l.font = l.font.withSize(24)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize) // just example
        return l
    }()
    
    
    let myAddressExplanation : UITextView = {
        let textView = UITextView()
        textView.text = "Not your residential address?  Use the fields below to update, or touch Capture Location next time you're home."
        textView.font = UIFont(name: (textView.font?.fontName)!, size: (textView.font?.pointSize)!+4)!
        //textView.font = UIFont.boldSystemFont(ofSize: textView.font.pointSize) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        //var frame = textView.frame
        //frame.size.height = 200
        //textView.frame = frame
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    let addressLine1Field : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Address line 1"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let addressLine2Field : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "Address line 2"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let cityField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "City"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let stateField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "ST"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let zipField : UITextField = {
        let field = UITextField()
        let backgroundColor : UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        field.backgroundColor = backgroundColor
        field.layer.borderWidth = 0.5
        //field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = 5.0
        field.placeholder = "ZIP"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    var myLegislatorView : MyLegislators?
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if TPUser.sharedInstance.residential_address_line1 == nil {
            myAddressExplanation.text = "Enter your residential address in the fields below, or touch Capture Location next time you're home"
        }
        
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.contentSize = CGSize(width: 250, height: 1450)
        
        //scrollView.removeFromSuperview()
        view.addSubview(scrollView)
        
        
        scrollView.addSubview(myAddressHeading)
        myAddressHeading.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8).isActive = true
        myAddressHeading.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        //myAddressHeading.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        //myAddressHeading.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        
        scrollView.addSubview(myAddressExplanation)
        myAddressExplanation.topAnchor.constraint(equalTo: myAddressHeading.bottomAnchor, constant: 8).isActive = true
        myAddressExplanation.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        myAddressExplanation.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
        
        scrollView.addSubview(addressLine1Field)
        addressLine1Field.topAnchor.constraint(equalTo: myAddressExplanation.bottomAnchor, constant: 16).isActive = true
        addressLine1Field.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        addressLine1Field.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
        addressLine1Field.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.05).isActive = true
        
        scrollView.addSubview(addressLine2Field)
        addressLine2Field.topAnchor.constraint(equalTo: addressLine1Field.bottomAnchor, constant: 8).isActive = true
        addressLine2Field.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        addressLine2Field.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95).isActive = true
        addressLine2Field.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.05).isActive = true
        
        scrollView.addSubview(cityField)
        cityField.topAnchor.constraint(equalTo: addressLine2Field.bottomAnchor, constant: 8).isActive = true
        cityField.leadingAnchor.constraint(equalTo: addressLine2Field.leadingAnchor, constant: 0).isActive = true
        cityField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.5).isActive = true
        cityField.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.05).isActive = true
        
        scrollView.addSubview(stateField)
        stateField.topAnchor.constraint(equalTo: addressLine2Field.bottomAnchor, constant: 8).isActive = true
        stateField.leadingAnchor.constraint(equalTo: cityField.trailingAnchor, constant: 8).isActive = true
        stateField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.1).isActive = true
        stateField.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.05).isActive = true
        
        scrollView.addSubview(zipField)
        zipField.topAnchor.constraint(equalTo: addressLine2Field.bottomAnchor, constant: 8).isActive = true
        zipField.trailingAnchor.constraint(equalTo: addressLine2Field.trailingAnchor, constant: 0).isActive = true
        zipField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.25).isActive = true
        zipField.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.05).isActive = true
        
        
        scrollView.addSubview(locationButton)
        locationButton.topAnchor.constraint(equalTo: zipField.bottomAnchor, constant: 8).isActive = true
        locationButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        //locationButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        //locationButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        
        if myLegislatorView != nil {
            myLegislatorView?.removeFromSuperview()
        }
        
        myLegislatorView = MyLegislators(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.addSubview(myLegislatorView!)
        myLegislatorView?.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 16).isActive = true
        myLegislatorView?.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        myLegislatorView?.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        
        
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
        
        if sender.titleLabel?.text == "Capture Location" {
            doCaptureLocation(sender)
        }
        else if sender.titleLabel?.text == "This is my Home Address" {
            updateResidentialAddress()
        }
    }
    
    func callback(error: NSError?) {
        //var error : NSError?
        //error = NSError(domain:"", code:400, userInfo: ["message": "Uh Oh! You got an error.  Try again and if this problem persists, talk to Michelle or Brent"])
        var message = "Account info updated"
        var title = "Success"
        let buttonText = "OK"
        if ((error) != nil) {
            message = "Hmmm - didn't expect this...\nYou should probably talk to Michelle or Brent"
            title = "Error"
            // need to display alert box to user on error or success
            if let msg = error!.userInfo["message"] as? String {
                message = msg
            }
        }
        
        let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateResidentialAddress() {
        
        TPUser.sharedInstance.residential_address_line1 = addressLine1Field.text
        TPUser.sharedInstance.residential_address_line2 = addressLine2Field.text
        TPUser.sharedInstance.residential_address_city = cityField.text
        TPUser.sharedInstance.residential_address_state_abbrev = stateField.text
        TPUser.sharedInstance.residential_address_zip = zipField.text
        TPUser.sharedInstance.current_latitude = latitude
        TPUser.sharedInstance.current_longitude = longitude
        TPUser.sharedInstance.update(callback: callback)
    }
    
    private func doCaptureLocation(_ sender: UIButton) {
        
        //guard user != nil else {return}
        
        guard let lati = latitude,
            let longi = longitude else { return }
        
        let thisIsHome = "This is my Home Address"
        sender.setTitle(thisIsHome, for: .normal)
        myAddressExplanation.text = "If this is your residential address, touch \"\(thisIsHome)\". If not, use these fields to correct and then touch \"\(thisIsHome)\""
        
        addressLine1Field.text = currentStreetAddress
        cityField.text = currentCity
        stateField.text = currentState
        zipField.text = currentZip
        
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
            
            self.myLegislatorView?.setLegislators(legislators: legislators!)
        }
        
        task.resume()
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



