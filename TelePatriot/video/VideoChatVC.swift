//
//  VideoChatVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 3/27/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase

class VideoChatVC: BaseViewController, VCConnectorIConnect, VCConnectorIRegisterRemoteCameraEventListener,
VCConnectorIRegisterLocalCameraEventListener, VCConnectorIRegisterLocalSpeakerEventListener, VCConnectorIRegisterLocalMicrophoneEventListener, VCConnectorIRegisterParticipantEventListener, UIPopoverPresentationControllerDelegate
    //, EditSocialMediaDelegate
    , SearchUsersDelegate
{
    

    var databaseRef : DatabaseReference?
    
    // Vidyo code ref:   https://vidyo.io/blog/how-to/vidyo-io-using-swift-build-ios-video-chat-app/
    private var connector:VCConnector?
    var localCameraView : UIView?
    var remoteViews: UIView!
    private var remoteViewsMap:[String:UIView] = [:]
    private var numberOfRemoteViews = 0   
    var resourceID          = ""
    var micMuted            = false
    var cameraMuted         = false
    var connected = false
    var recording = false
    var room_id : String? // we want the room_id to be the same as the video_node_key
    
    var videoNode : VideoNode?
    var legislator : Legislator?
    var videoChatInstructionsView : VideoChatInstructionsView?
    
    // not sure if I like it being this explicit but I need a way to get to CenterViewController.doView()
    // specifically in findSomeone() at the very bottom
    var centerViewController : CenterViewController?
    var spinnerView : UIView?
    let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    
    var rotateToLandscapeView : UIView?
    
    let searchIcon : UIImageView = {
        let img = UIImage(named: "baseline_search_black_36dp.png")
        let imgView = UIImageView(image: img)
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    
    let invite_someone_button : BaseButton = {
        let button = BaseButton(text: "invite someone")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Verdana", size: 16)
        button.addTarget(self, action: #selector(inviteSomeone(_:)), for: .touchUpInside)
        return button
    }()
    
    let revoke_invitation_button : BaseButton = {
        let button = BaseButton(text: "cancel invitation")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Verdana", size: 16)
        button.addTarget(self, action: #selector(revokeInvitation(_:)), for: .touchUpInside)
        return button
    }()
    
    let connect_button : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        // have to do this in viewDidLoad() I think - because 'self' isn't available here
        //button.frame = CGRect(x: 8, y: self.view.bounds.height / 3 + 40, width: 40, height: 40)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "callStart.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(connectionClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    /********** DON'T DELETE THESE these work but let's take them out for now  **********/
//    let cameraButton : UIButton = {
//        let button = UIButton(type: UIButtonType.custom)
//        button.backgroundColor = UIColor.clear
//        button.setImage(UIImage(named: "cameraOn.png"), for: UIControlState.normal)
//        button.addTarget(self, action: #selector(cameraClicked(_:)), for: .touchUpInside)
//        return button
//    }()
//
//    let micButton : UIButton = {
//        let button = UIButton(type: UIButtonType.custom)
//        button.backgroundColor = UIColor.clear
//        button.setImage(UIImage(named: "microphoneOnWhite.png"), for: UIControlState.normal)
//        button.addTarget(self, action: #selector(micClicked(_:)), for: .touchUpInside)
//        return buttonf
//    }()
    
    let record_button : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "record.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(recordClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    let publish_button : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "arrow-upload-icon.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(publishClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    // Once an invitation has been extended to someone, and before they accept it, that person's name will appear
    // in the remote view pane as a sort of confirmation that you have successfully invited someone to participate
    // in a video chat with you
    let guest_name : UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 16) // just example
        textView.translatesAutoresizingMaskIntoConstraints = false
        //var frame = textView.frame
        //frame.size.height = 200
        //textView.frame = frame
        //textView.layer.borderWidth = 0.5
        //textView.layer.cornerRadius = 5.0
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let rotateToLandscapeMessage : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.text = "Rotate to Landscape to shoot videos"
        return l
    }()
    
    
    override func viewDidAppear(_ animated:Bool) {
        print("view appeared")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topMargin : CGFloat = 30
        let localCameraXPos : CGFloat = 0
        let localCameraYPos : CGFloat = topMargin
        let localHeight : CGFloat = self.view.bounds.height / 2 - topMargin / 2
        let localCameraWidth : CGFloat = 16 / 9 * localHeight
        
        let remoteXPos = localCameraXPos
        let remoteYPos : CGFloat = localCameraYPos + localHeight
        let remoteWidth = localCameraWidth
        let remoteHeight = localHeight
        
        localCameraView = UIView(frame: CGRect(x: 0, y: localCameraYPos, width: localCameraWidth, height: localHeight))
        remoteViews = UIView(frame: CGRect(x: remoteXPos, y: remoteYPos, width: remoteWidth, height: remoteHeight))
        
        
        // Vidyo code ref:   https://vidyo.io/blog/how-to/vidyo-io-using-swift-build-ios-video-chat-app/
        VCConnectorPkg.vcInitialize()
        connector = VCConnector(nil, // For custom handling of views, set this to nil.  See:  https://github.com/Vidyo/customview-swift-ios/blob/master/CustomLayoutSample/CustomViewController.swift
                                viewStyle: .default,
                                remoteParticipants: 1,
                                logFileFilter: UnsafePointer("warning"),
                                logFileName: UnsafePointer(""),
                                userData: 0)
    
        
        
        // Oh Yeah! This is how you listen for camera events!!!
        if connector != nil {
            // When For custom view we need to register to all the device events
            connector?.registerLocalCameraEventListener(self)
            connector?.registerRemoteCameraEventListener(self)
            connector?.registerLocalSpeakerEventListener(self)
            connector?.registerLocalMicrophoneEventListener(self)
            connector?.registerParticipantEventListener(self)
        }
        
        let buttonWidth : CGFloat = 48
        let buttonHeight : CGFloat = buttonWidth
        //let bottomAreaHeight = self.view.frame.height - remoteYPos - remoteHeight
        let buttonYPos : CGFloat = localCameraYPos + localHeight - buttonHeight / 2
        let spacingConstant : CGFloat = 24
        var buttonSpacing : CGFloat = spacingConstant
        
        connect_button.frame = CGRect(x: buttonSpacing, y: buttonYPos, width: buttonWidth, height: buttonHeight)
//        buttonSpacing += buttonWidth + spacingConstant
//        cameraButton.frame = CGRect(x: buttonSpacing, y: buttonYPos, width: buttonWidth, height: buttonHeight)
//        buttonSpacing += buttonWidth + spacingConstant
//        micButton.frame = CGRect(x: buttonSpacing, y: buttonYPos, width: buttonWidth, height: buttonHeight)
        buttonSpacing += buttonWidth + spacingConstant
        record_button.frame = CGRect(x: buttonSpacing, y: buttonYPos, width: buttonWidth, height: buttonHeight)
        buttonSpacing += buttonWidth + spacingConstant
        publish_button.frame = CGRect(x: buttonSpacing, y: buttonYPos, width: buttonWidth, height: buttonHeight)
        record_button.isHidden = true
        publish_button.isHidden = true
        
        // The below line will give you what you want
        //micButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)

        
        localCameraView?.backgroundColor = UIColor.red
        view.addSubview(localCameraView!) // placement is dictated by the dimensions of the CGRect in the UIView's constructor
        
        
        remoteViews?.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 1, alpha: 0.8)
        //unrid()
        view.addSubview(remoteViews!) // placement is dictated by the dimensions of the CGRect in the UIView's constructor
        
        view.addSubview(connect_button)
//        DON'T DELETE THESE 2
//        view.addSubview(cameraButton)
//        view.addSubview(micButton)
        view.addSubview(record_button)
        view.addSubview(publish_button)
        
        if let videoChatInstructionsView = videoChatInstructionsView {
            videoChatInstructionsView.removeFromSuperview()
        }
        
        let instructionsXPos = localCameraXPos + localCameraWidth
        let instructionsYPos = localCameraYPos
        let instructionsWidth = self.view.bounds.width - instructionsXPos
        let instructionsHeight = self.view.bounds.height - instructionsYPos
        let bounds = CGRect(x: instructionsXPos, y: instructionsYPos, width: instructionsWidth, height: instructionsHeight)
        videoChatInstructionsView = VideoChatInstructionsView.init(frame: bounds)
        
        if let esm = getAppDelegate().editSocialMediaVC,
            let evmd = getAppDelegate().editVideoMissionDescriptionVC,
            let elv = getAppDelegate().editLegislatorForVideoVC {
            videoChatInstructionsView?.buildView(editSocialMediaVC: esm,
                                                 videoChatVC: self,
                                                 editVideoMissionDescriptionVC: evmd,
                                                 editLegislatorForVideoVC: elv)
            view.addSubview(videoChatInstructionsView!)
            
            videoChatInstructionsView?.topAnchor.constraint(equalTo: view.topAnchor, constant: instructionsYPos).isActive = true
            videoChatInstructionsView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: instructionsXPos).isActive = true
        }
        
        let videoNodeKey = getVideoNodeKey()
        
        // the initial query...
        Database.database()
            .reference()
            .child("video/list")
            .child(videoNodeKey)
            .observe(.value, with: {(snapshot) in
                
                self.videoNode = VideoNode(snapshot: snapshot, vc: self)
                if let vc = self.videoChatInstructionsView {
                    vc.setVideoNode(videoNode: self.videoNode!)
                }
                
                if let bothPresent = self.videoNode?.bothParticipantsPresent() {
                    if bothPresent {
                        print("BOTH PARTICIPANTS READY !!!!!!");
                        // connect automatically !!!
                        self.connectIfNotConnected();
                    }
                    else {
                        print("BOTH PARTICIPANTS >>>NOT<<< READY");
                    }
                }
        })
    }
    
    // See AppDelegate: NotificationCenter.default.addObserver(self, selector: #selector(VideoChatVC.rotated), ....
    func rotated() {
        /********** not working yet - still buggy
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            dismissRotateToLandscapeView()
        }
        else {
            rotateToLandscapeView = UIView.init(frame: view.bounds)
            rotateToLandscapeView?.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.addSubview(self.rotateToLandscapeView!)
            self.rotateToLandscapeView?.addSubview(self.rotateToLandscapeMessage)
            
            rotateToLandscapeMessage.centerYAnchor.constraint(equalTo: (rotateToLandscapeView?.centerYAnchor)!, constant: 0).isActive = true
            rotateToLandscapeMessage.centerXAnchor.constraint(equalTo: (rotateToLandscapeView?.centerXAnchor)!, constant: 0).isActive = true
        }
        **********/
    }
    
    /*****
     The point of setting 'present' for the participants is so that both participants can know if the other is actually on the
     VideoChatVC screen.  When both people are on the VideoChatVC screen, we can automatically connect the two people ...because
     users aren't going to understand the need to connect ...that's a "Vidyo thing".  But if we know both people are actually on
     the VideoChatVC screen at the same time, we can actually trigger a connect for both of them so they will just instantly see
     each other
    ******/
    override func viewWillAppear(_ animated: Bool) {
        if let video_node_key = TPUser.sharedInstance.current_video_node_key {
            let updates = ["present" : true,
                           "vidyo_token_requested" : true
            ]
            Database.database().reference()
                .child("video/list/\(video_node_key)/video_participants/\(TPUser.sharedInstance.getUid())").updateChildValues(updates)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let video_node_key = TPUser.sharedInstance.current_video_node_key {
            let path = "video/list/\(video_node_key)/video_participants/\(TPUser.sharedInstance.getUid())/present"
            Database.database().reference().child(path).setValue(false)
        }
    }
    
    private func dismissRotateToLandscapeView() {
        //DispatchQueue.main.async {
        self.rotateToLandscapeMessage.removeFromSuperview()
        self.rotateToLandscapeView?.removeFromSuperview()
        //}
    }
    
    private func getVideoNodeKey() -> String {
        if let key = TPUser.sharedInstance.current_video_node_key {
            return key
        }
        else {
            let vn = createVideoNode()
            TPUser.sharedInstance.setCurrent_video_node_key(current_video_node_key: vn.getKey())
            return vn.getKey()
        }
    }
    
    private func createVideoNode() -> VideoNode {
        let appDelegate = getAppDelegate()
        
        // hardcode for now...
        let theType = "Video Petition"
        // appDelegate.videoTypes is created in AppDelegate: func application(_ application: UIApplication, didFinishLaunchingWithOptions...)
        let videoType = appDelegate.videoTypes.filter{ $0.type == theType }.first
        
        return VideoNode(creator: TPUser.sharedInstance, type: videoType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func recordClicked(_ sender: Any) {
        if recording {
            stopRecording()
        }
        else {
            startRecording()
        }
    }
    
    @objc func publishClicked(_ sender: Any) {
        showSpinner()
        // write to /video/video_events.  There's a trigger listening for writes to that node
        // When a "start publishing" record is written, the trigger will call the virtual machine
        // which in turn calls the appropriate docker instance and executes the python script in
        // that docker instance
        
        let startPublishingRequest : [String:Any] = [
            "request_type": "start publishing",
            "video_node_key": TPUser.sharedInstance.current_video_node_key,
            // not sure if we need room_id here - it's the same as the video_node_key anyway
            "uid": TPUser.sharedInstance.getUid(),
            "date": Util.getDate_MMM_d_yyyy_hmm_am_z(),
            "date_ms": Util.getDate_as_millis()
        ]
        Database.database().reference().child("video/video_events").childByAutoId().setValue(startPublishingRequest)
    }
    
    
    @objc func connectionClicked(_ sender: Any) {
        publish_button.isHidden = true
        if connected {
            showSpinner()
            if recording {
                stopRecording()
            }
            // hide the record button
            self.record_button.isHidden = true
            
            connector?.disconnect()
            DispatchQueue.main.async { self.dismissSpinner() }
            connect_button.setImage(UIImage(named: "callStart.png"), for: UIControlState.normal)
            connected = false
            unrid()
        }
        else {
            doConnect()
        }
    }
    
    // result of the callback from the docker container.  The docker container makes
    // a GET request on recording_has_started() which sets recording_started on the video node
    // The constructor of VideoNode here in Swift calls this method to dismiss the spinner
    //   - lot of work just to activate and dismiss a spinner
    func recordingStarted() {
        DispatchQueue.main.async { self.dismissSpinner() }
    }
    // works just like recordingStarted()
    func publishingStarted() {
        DispatchQueue.main.async { self.dismissSpinner() }
    }
    
    private func startRecording() {
        recording = true
        showSpinner()
        record_button.setImage(UIImage(named: "recordstop.png"), for: UIControlState.normal)
        createRecordingEvent(request_type: "start recording")
        publish_button.isHidden = true
    }
    
    private func stopRecording() {
        recording = false
        record_button.setImage(UIImage(named: "record.png"), for: UIControlState.normal)
        createRecordingEvent(request_type: "stop recording")
        publish_button.isHidden = false
    }
    
    private func createRecordingEvent(request_type: String) {
        // write at least this much to /video/video_events
        let recording_request : [String:Any] = [
                               "request_type": request_type,
                               "video_node_key": TPUser.sharedInstance.current_video_node_key,
                               "room_id": TPUser.sharedInstance.current_video_node_key,
                               "uid": TPUser.sharedInstance.getUid(),
                               "date": Util.getDate_MMM_d_yyyy_hmm_am_z(),
                               "date_ms": Util.getDate_as_millis()]
        // might also want to capture who made the request and when
        
        // There's a trigger function: exports.dockerRequest that listens for writes to this node
        // and selects a docker instance that can serve as "recording secretary" for the call
        Database.database().reference().child("video/video_events").childByAutoId().setValue(recording_request)
    }
    
    private func connectIfNotConnected() {
        if(!connected) {
            doConnect();
        }
        else { print("already connected to Vidyo server") }
    }
    
    private func getSpinner() {
        spinnerView = UIView.init(frame: view.bounds)
        spinnerView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        ai.startAnimating()
        ai.center = (spinnerView?.center)!
    }
    
    private func showSpinner() {
        DispatchQueue.main.async {
            self.spinnerView?.addSubview(self.ai)
            self.view.addSubview(self.spinnerView!)
        }
    }
    
    private func dismissSpinner() {
        self.ai.removeFromSuperview()
        self.spinnerView?.removeFromSuperview()
    }
    
    private func doConnect() {
        guard let videoNode = videoNode,
              let me = videoNode.video_participants[TPUser.sharedInstance.getUid()],
              let mytoken = me.vidyo_token
            else {
            return
        }
        
        // The room_id will NOT be nil if the user is coming to this screen from accepting a video invitation
        // See extension CenterViewController : VideoInvitationDelegate
        if room_id == nil {
            room_id = TPUser.sharedInstance.current_video_node_key
        }
        
        rid()
    
        getSpinner()
        showSpinner()
    
        DispatchQueue.main.async {
            
            self.connector?.connect("prod.vidyo.io",
                                    token: mytoken,
                                    displayName: TPUser.sharedInstance.getName(),
                                    resourceId: self.room_id,
                                    connectorIConnect: self)
            
            self.connect_button.setImage(UIImage(named: "callEnd.png"), for: UIControlState.normal)
            
            self.connected = true
            self.connector?.setCameraPrivacy(false)
            
            // show the record button
            self.record_button.isHidden = false
            self.dismissSpinner()
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        // The room_id will NOT be nil if the user is coming to this screen from accepting a video invitation
//        // See extension CenterViewController : VideoInvitationDelegate
//        if room_id == nil {
//            room_id = TPUser.sharedInstance.current_video_node_key
//        }
//        let name = TPUser.sharedInstance.getUid()
//        guard let escapedString = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
//            return }
//        let urlString = "https://us-central1-telepatriot-bd737.cloudfunctions.net/generateVidyoToken?userName=\(escapedString)"
//        guard let url = URL(string: urlString) else {
//            return }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//        // TODO need to handle errors.  If there's an error, we want the green call button back
//        // We don't want the UI to show the red hang up button if we aren't actually connected
//        let task = session.dataTask(with: request) { (data, response, responseError) in
//            
//            let str = String(describing: type(of: data))
//            print( "data is: \(str)"  )
//            
//            let decoder = JSONDecoder()
//            guard let tokenResponse = try? decoder.decode([String:String].self, from: data!) else {
//                return }
//            
//            DispatchQueue.main.async {
//                guard let token = tokenResponse["token"] else { return }
//                
//                self.connector?.connect("prod.vidyo.io",
//                                        token: token,
//                                        displayName: TPUser.sharedInstance.getName(),
//                                        resourceId: self.room_id,
//                                        connectorIConnect: self)
//                
//                self.connect_button.setImage(UIImage(named: "callEnd.png"), for: UIControlState.normal)
//                
//                self.connected = true
//                self.connector?.setCameraPrivacy(false)
//                
//                // show the record button
//                self.recordButton.isHidden = false
//                self.dismissSpinner()
//            }
//        }
//        
//        task.resume()
    }
    
    // MARK: - VCIConnect delegate methods
    
    func onSuccess() {
        print("Connection Successful")
    }
    
    func onFailure(_ reason: VCConnectorFailReason) {
        print("Connection failed \(reason)")
    }
    
    func onDisconnected(_ reason: VCConnectorDisconnectReason) {
        print("Call Disconnected")
    }
    
    
    func refreshUI() {
        DispatchQueue.main.async {
            
            
            guard let w = self.localCameraView?.frame.size.width,
                let h = self.localCameraView?.frame.size.height else {
                    return
            }
            
            
            // Updating remote views
            let refFrames   = RemoteViewLayout.getTileFrames(numberOfTiles: self.numberOfRemoteViews)
            var index       = 0
            /****************/
            for var remoteView in self.remoteViewsMap.values {
                let refFrame        = refFrames[index] as! CGRect
                remoteView.frame    = refFrame
                self.connector?.showView(at: UnsafeMutableRawPointer(&remoteView),
                                         x: 0,
                                         y: 0,
                                         width: UInt32(w),
                                         height: UInt32(h))
                
                // updating label location
                for subview in remoteView.subviews
                {
                    if let item = subview as? UILabel
                    {
                        item.frame = CGRect(x: 0,
                                            y: 10,
                                            width: remoteView.frame.width,
                                            height: 20)
                    }
                }
                index += 1
                if index >= 4 {
                    // Showing max 4 remote participants
                    break
                }
            }
            /*************/
        }
    }
    
    
    // MARK: - IRegisterRemoteCameraEventListener delegate methods
    
    func onRemoteCameraAdded(_ remoteCamera: VCRemoteCamera!, participant: VCParticipant!) {
        
        numberOfRemoteViews += 1
        DispatchQueue.main.async {
            let rec = self.remoteViews.bounds
            var newRemoteView = UIView(frame: rec)
            newRemoteView.layer.borderColor = UIColor.black.cgColor
            newRemoteView.layer.borderWidth = 0.0
            self.remoteViews.addSubview(newRemoteView)
            self.remoteViewsMap[participant.getId()] = newRemoteView
            self.connector?.assignView(toRemoteCamera: UnsafeMutableRawPointer(&newRemoteView),
                                       remoteCamera: remoteCamera,
                                       displayCropped: false,
                                       allowZoom: /*true*/false)
            self.connector?.showViewLabel(UnsafeMutableRawPointer(&newRemoteView),
                                          showLabel: false)
            
            // Adding custom UILabel to show the participant name
            let newParticipantNameLabel = UILabel()
            newParticipantNameLabel.text = participant.getName()
            newParticipantNameLabel.textColor = UIColor.white
            newParticipantNameLabel.textAlignment = .center
            newParticipantNameLabel.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            newParticipantNameLabel.shadowOffset = CGSize(width: 1, height: 1)
            newParticipantNameLabel.font = newParticipantNameLabel.font.withSize(14)
            newRemoteView.addSubview(newParticipantNameLabel)
            // still need to add constraints here - that's why it's not showing up yet
            
            self.refreshUI()
        }
    }
    
    func onRemoteCameraRemoved(_ remoteCamera: VCRemoteCamera!, participant: VCParticipant!) {
        numberOfRemoteViews -= 1
        DispatchQueue.main.async {
            let remoteView = self.remoteViewsMap.removeValue(forKey: participant.getId())
            for view in (remoteView?.subviews)!{
                view.removeFromSuperview()
            }
            remoteView?.removeFromSuperview()
            
            self.refreshUI()
        }
    }
    
    func onRemoteCameraStateUpdated(_ remoteCamera: VCRemoteCamera!, participant: VCParticipant!, state: VCDeviceState) {
        
    }
    
    
    // MARK: - IRegisterLocalCameraEventListener delegate methods
    
    func onLocalCameraRemoved(_ localCamera: VCLocalCamera!) {
        self.localCameraView?.isHidden = true
    }
    
    // Equiv in Android is VidyoChatFragment.onLocalCameraAdded()
    func onLocalCameraAdded(_ localCamera: VCLocalCamera!) {
        if ((localCamera) != nil) {
            self.localCameraView?.isHidden = false
            localCamera.setPreviewLabel(TPUser.sharedInstance.getName())
            DispatchQueue.main.async {
                
                if let w = self.localCameraView?.frame.size.width, let h = self.localCameraView?.frame.size.height {
                    self.connector?.assignView(toLocalCamera: UnsafeMutableRawPointer(&self.localCameraView),
                                               localCamera: localCamera,
                                               displayCropped: false,
                                               allowZoom: false)
                    self.connector?.showViewLabel(UnsafeMutableRawPointer(&self.localCameraView),
                                                  showLabel: false)
                    self.connector?.showView(at: UnsafeMutableRawPointer(&self.localCameraView),
                                             x: 0,
                                             y: 0,
                                             width: UInt32(w),
                                             height: UInt32(h))
                }
                
            }
        }
    }
    
    func onLocalCameraSelected(_ localCamera: VCLocalCamera!) {
        print("onLocalCameraSelected")
    }
    
    func onLocalCameraStateUpdated(_ localCamera: VCLocalCamera!, state: VCDeviceState) {
        
    }
    
    // MARK: - IRegisterParticipantEventListener delegate methods
    
    func onParticipantLeft(_ participant: VCParticipant!) {
        
    }
    
    func onParticipantJoined(_ participant: VCParticipant!) {
        
    }
    
    func onLoudestParticipantChanged(_ participant: VCParticipant!, audioOnly: Bool) {
        
    }
    
    func onDynamicParticipantChanged(_ participants: NSMutableArray!, remoteCameras: NSMutableArray!) {
        
    }
    
    // MARK: - IRegisterLocalSpeakerEventListener delegate methods
    
    func onLocalSpeakerAdded(_ localSpeaker: VCLocalSpeaker!) {
        
    }
    
    func onLocalSpeakerRemoved(_ localSpeaker: VCLocalSpeaker!) {
        
    }
    
    func onLocalSpeakerSelected(_ localSpeaker: VCLocalSpeaker!) {
        
    }
    
    func onLocalSpeakerStateUpdated(_ localSpeaker: VCLocalSpeaker!, state: VCDeviceState) {
        
    }
    
    // MARK: - IRegisterLocalMicrophoneEventListener delegate methods
    
    func onLocalMicrophoneAdded(_ localMicrophone: VCLocalMicrophone!) {
        
    }
    
    func onLocalMicrophoneRemoved(_ localMicrophone: VCLocalMicrophone!) {
        
    }
    
    func onLocalMicrophoneSelected(_ localMicrophone: VCLocalMicrophone!) {
        
    }
    
    func onLocalMicrophoneStateUpdated(_ localMicrophone: VCLocalMicrophone!, state: VCDeviceState) {
        
    }
    
    // MARK: - IRegisterRemoteMicrophoneEventListener delegate methods
    
    func onRemoteMicrophoneAdded(_ remoteMicrophone: VCRemoteMicrophone!, participant: VCParticipant!) {
        
    }
    
    func onRemoteMicrophoneRemoved(_ remoteMicrophone: VCRemoteMicrophone!, participant: VCParticipant!) {
        
    }
    
    func onRemoteMicrophoneStateUpdated(_ remoteMicrophone: VCRemoteMicrophone!, participant: VCParticipant!, state: VCDeviceState) {
        
    }
 
    
//    DON'T DELETE THESE
//    @objc func micClicked(_ sender: Any) {
//        if micMuted {
//            micMuted = !micMuted
//            self.micButton.setImage(UIImage(named: "microphoneOnWhite.png"), for: .normal)
//            connector?.setMicrophonePrivacy(micMuted)
//        } else {
//            micMuted = !micMuted
//            self.micButton.setImage(UIImage(named: "microphoneOff.png"), for: .normal)
//            connector?.setMicrophonePrivacy(micMuted)
//        }
//    }
//
//    @objc func cameraClicked(_ sender: Any) {
//        if cameraMuted {
//            cameraMuted = !cameraMuted
//            self.cameraButton.setImage(UIImage(named: "cameraOn.png"), for: .normal)
//            connector?.setCameraPrivacy(cameraMuted)
//            self.localCameraView?.isHidden = cameraMuted
//        } else {
//            cameraMuted = !cameraMuted
//            self.cameraButton.setImage(UIImage(named: "cameraOff.png"), for: .normal)
//            connector?.setCameraPrivacy(cameraMuted)
//            self.localCameraView?.isHidden = cameraMuted
//        }
//    }
    
    private func rid() {
        searchIcon.removeFromSuperview()
        invite_someone_button.removeFromSuperview()
        guest_name.removeFromSuperview()
        revoke_invitation_button.removeFromSuperview()
    }
    
    // the opposite of rid()  LOL
    private func unrid() {
        if let extended_to = videoNode?.video_invitation_extended_to {
            invite_someone_button.removeFromSuperview()
            searchIcon.removeFromSuperview()
            
            // guest_name is filled in at very bottom in userSelected()
            remoteViews?.addSubview(guest_name)
            guest_name.text = "You have invited \(extended_to) to participate in a video chat"
            guest_name.topAnchor.constraint(equalTo: (remoteViews?.topAnchor)!, constant:24).isActive = true
            guest_name.leadingAnchor.constraint(equalTo: (remoteViews?.leadingAnchor)!, constant:8).isActive = true
            guest_name.widthAnchor.constraint(equalTo: (remoteViews?.widthAnchor)!, constant:0.85).isActive = true
            //guest_name.heightAnchor.constraint(equalTo: (remoteViews?.heightAnchor)!, constant:0.5).isActive = true
            
            remoteViews?.addSubview(revoke_invitation_button)
            revoke_invitation_button.topAnchor.constraint(equalTo: guest_name.bottomAnchor, constant:16).isActive = true
            revoke_invitation_button.centerXAnchor.constraint(equalTo: guest_name.centerXAnchor, constant:0).isActive = true
        }
        else {
            remoteViews?.addSubview(invite_someone_button)
            invite_someone_button.topAnchor.constraint(equalTo: remoteViews.topAnchor, constant: 16).isActive = true
            invite_someone_button.centerXAnchor.constraint(equalTo: remoteViews.centerXAnchor, constant: 0).isActive = true
            
            remoteViews?.addSubview(searchIcon)
            searchIcon.leadingAnchor.constraint(equalTo: invite_someone_button.trailingAnchor, constant: 16).isActive = true
            searchIcon.centerYAnchor.constraint(equalTo: invite_someone_button.centerYAnchor, constant: 0).isActive = true
            
            guest_name.removeFromSuperview()
            revoke_invitation_button.removeFromSuperview()
        }
        
        
    }
    
    
    // TODO these next 2 funcs are a lot like rid() and unrid() - need to consolidate
    func videoInvitationExtended(name: String) {
        // remove the "invite someone" button - because now an invitation has already been extended
        invite_someone_button.removeFromSuperview()
        searchIcon.removeFromSuperview() // remove this for the same reason
        
        remoteViews?.addSubview(guest_name)
        guest_name.text = "You have invited \(name) to participate in a video chat"
        guest_name.topAnchor.constraint(equalTo: (remoteViews?.topAnchor)!, constant:24).isActive = true
        guest_name.leadingAnchor.constraint(equalTo: (remoteViews?.leadingAnchor)!, constant:8).isActive = true
        guest_name.widthAnchor.constraint(equalTo: (remoteViews?.widthAnchor)!, constant:0.85).isActive = true
        //guest_name.heightAnchor.constraint(equalTo: (remoteViews?.heightAnchor)!, constant:0.5).isActive = true
        
        remoteViews?.addSubview(revoke_invitation_button)
        revoke_invitation_button.topAnchor.constraint(equalTo: guest_name.bottomAnchor, constant:16).isActive = true
        revoke_invitation_button.centerXAnchor.constraint(equalTo: guest_name.centerXAnchor, constant:0).isActive = true
    }
    
    
    // TODO this func and the one above are a lot like rid() and unrid() - need to consolidate
    func videoInvitationNotExtended() {
        remoteViews?.addSubview(invite_someone_button)
        invite_someone_button.topAnchor.constraint(equalTo: remoteViews.topAnchor, constant: 16).isActive = true
        invite_someone_button.centerXAnchor.constraint(equalTo: remoteViews.centerXAnchor, constant: 0).isActive = true
        
        remoteViews?.addSubview(searchIcon)
        searchIcon.leadingAnchor.constraint(equalTo: invite_someone_button.trailingAnchor, constant: 16).isActive = true
        searchIcon.centerYAnchor.constraint(equalTo: invite_someone_button.centerYAnchor, constant: 0).isActive = true
        
        guest_name.removeFromSuperview()
        revoke_invitation_button.removeFromSuperview()
    }
    
    
    // These next two functions kinda go together.  This first one pops up the Search Users screen
    @objc private func inviteSomeone(_ sender: UIButton) {
        // pop up the same Search Users screen that Admins see
        if let vc = getAppDelegate().searchUsersVC {
            vc.modalPresentationStyle = .popover
            vc.searchUsersDelegate = self
//            centerViewController?.doView(vc: vc)
            self.present(vc, animated: true, completion:nil)
        }
    }
    
    
    // This second function is what gets called when you choose a user from SearchUsersVC
    // Notice in the method above that we made 'self' the delegate of SearchUsersVC
    // per SearchUsersDelegate
    func userSelected(user: TPUser) {
        if let vc = getAppDelegate().searchUsersVC {
            vc.dismiss(animated: false, completion: nil)
        }
        
        // We want to write this user and the current user to /video/invitations
        if let vid = TPUser.sharedInstance.current_video_node_key {
            let videoInvitation = VideoInvitation(creator: TPUser.sharedInstance, guest: user, video_node_key: vid)
            let video_invitation_key = videoInvitation.save()
            videoNode?.video_invitation_key = video_invitation_key
            
            // now write the video_invitation_key to the video node so that we can revoke the invitation later if we want to
            let data = ["video/list/\(vid)/video_invitation_key" : video_invitation_key,
                        "video/list/\(vid)/video_invitation_extended_to" : user.getName() ]
            Database.database().reference().updateChildValues(data)
        }
    }
    
    
    // revoke_invitation_button should only be displayed when an invitation has been extended
    @objc private func revokeInvitation(_ sender: UIButton) {
        
        if let videoNode = videoNode, let video_invitation_key = videoNode.video_invitation_key {
            let updatedData = ["video/list/\(videoNode.getKey())/video_invitation_key": nil,
                               "video/list/\(videoNode.getKey())/video_invitation_extended_to": nil,
                               "video/invitations/\(String(describing: video_invitation_key))": nil
                ] as [String : Any?]
            
            // example of multi-path update
            Database.database().reference().updateChildValues(updatedData, withCompletionBlock: { (error, ref) -> Void in
                // don't really need to do anything on successful save - just left this as a reminder of how to do stuff on completion
                self.dismiss(animated: true, completion: nil)
            })
            
        }
        
    }
    

}
