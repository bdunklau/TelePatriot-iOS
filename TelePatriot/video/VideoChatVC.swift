//
//  VideoChatVC.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 3/27/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import UIKit
import Firebase
import TwilioVideo

class VideoChatVC: BaseViewController, TVICameraCapturerDelegate, TVIVideoViewDelegate
    // There is also an extension below making this class implement TVIRoomDelegate
    // ditto for TVIRemoteParticipantDelegate
{
    
    // Video SDK components
    var room: TVIRoom?
    var camera: TVICameraCapturer?
    var localVideoTrack: TVILocalVideoTrack?
    var localAudioTrack: TVILocalAudioTrack?
    var local_view : UIView!
    var local_camera_view: TVIVideoView!
    
    //var remote_view : UIView!
//    var empty_remote_view : UIView!
    var remote_camera_view: TVIVideoView?
    var remoteParticipant: TVIRemoteParticipant?
    var remoteCameraVisible = false
    
    var room_id: String?
    var centerViewController : CenterViewController?
    var videoChatInstructionsView : VideoChatInstructionsView?
    
    var localCameraXPos : CGFloat?
    var localCameraYPos : CGFloat?
    var localHeight : CGFloat?
    var localCameraWidth : CGFloat?
    
    var remoteXPos : CGFloat?
    var remoteYPos : CGFloat?
    var remoteWidth : CGFloat?
    var remoteHeight : CGFloat?
    
    var currentVideoNode : VideoNode?
    
    var audioCodec: TVIAudioCodec?
    var videoCodec: TVIVideoCodec?
    
    var maxAudioBitrate = UInt()
    var maxVideoBitrate = UInt()
    
    
    let connect_button : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        // have to do this in viewDidLoad() I think - because 'self' isn't available here
        //button.frame = CGRect(x: 8, y: self.view.bounds.height / 3 + 40, width: 40, height: 40)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "callStart.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(connectionClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    let microphone_button : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "microphoneOnWhite.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(micClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    let record_button : UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "record.png"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(recordClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    let record_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        //l.font = l.font.withSize(18)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.textColor = .red
        // this setting, plus the widthAnchor constraint below is how we achieve word wrapping inside the scrollview
        l.numberOfLines = 0
        l.text = ""
        return l
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
    
    var portraitView: UIView?
    var landscapeView: UIView?
    
    let flip_to_landscape_label : UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = l.font.withSize(16)
        l.font = UIFont.boldSystemFont(ofSize: l.font.pointSize)
        l.textColor = .black
        l.text = "Rotate your phone 90 degrees"
        return l
    }()
    
//    This is a "hack" button in case people rotate their phones but still see the "Rotate your phone" message
    let ok_rotated : BaseButton = {
        let button = BaseButton(text: "OK")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "Verdana", size: 16)
        button.addTarget(self, action: #selector(checkForLandscape(_:)), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hack = false
        if hack {
            if let landscapeView = landscapeView {
                landscapeView.removeFromSuperview()
            }
            if let portraitView = portraitView {
                portraitView.removeFromSuperview()
            }
            landscapeView = nil
            portraitView = nil
            queryCurrentVideoNode()
            loadLandscapeView()
            view.addSubview(landscapeView!)
        }
        else if UIDevice.current.orientation.isLandscape {
            queryCurrentVideoNode()
            
            if landscapeView == nil {
                loadLandscapeView()
            }
            view.addSubview(landscapeView!)
            if let portraitView = portraitView {
                portraitView.removeFromSuperview()
            }
        }
        else if UIDevice.current.orientation.isPortrait {
            if portraitView == nil {
                loadPortraitView()
            }
            view.addSubview(portraitView!)
            if let landscapeView = landscapeView {
                landscapeView.removeFromSuperview()
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        inviteLinks()
//    }
    
    func loadPortraitView() {
        
        portraitView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        if let portraitView = portraitView {
            portraitView.addSubview(flip_to_landscape_label)
            flip_to_landscape_label.centerXAnchor.constraint(equalTo: portraitView.centerXAnchor, constant: 0).isActive = true
            flip_to_landscape_label.centerYAnchor.constraint(equalTo: portraitView.centerYAnchor, constant: 0).isActive = true
            
            portraitView.addSubview(ok_rotated)
            ok_rotated.centerXAnchor.constraint(equalTo: flip_to_landscape_label.centerXAnchor, constant: 0).isActive = true
            ok_rotated.topAnchor.constraint(equalTo: flip_to_landscape_label.bottomAnchor, constant: 16).isActive = true
        }
    }
    
    func loadLandscapeView() {
        
        landscapeView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        if let landscapeView = landscapeView {
            let topMargin : CGFloat = 30
            localCameraXPos = 0 // why do we have to go negative to flush left?
            localCameraYPos = topMargin
            localHeight = landscapeView.bounds.height / 2 - topMargin / 2
            localCameraWidth = 16 / 9 * localHeight!
            
            remoteXPos = localCameraXPos
            remoteYPos = localCameraYPos! + localHeight!
            remoteWidth = localCameraWidth
            remoteHeight = localHeight
            
            // add the remote_view when the remote camera comes online
            self.remote_camera_view = TVIVideoView.init(frame: CGRect(x: remoteXPos!, y: remoteYPos!, width: remoteWidth!, height: remoteHeight!), delegate:self)
            remote_camera_view?.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 1, alpha: 0.8)
            
            let buttonWidth : CGFloat = 48
            let buttonHeight : CGFloat = buttonWidth
            let buttonYPos : CGFloat = localCameraYPos! + localHeight! - buttonHeight / 2
            let spacingConstant : CGFloat = 24
        
            local_view = UIView(frame: CGRect(x: 0, y: localCameraYPos!, width: localCameraWidth!, height: localHeight!))
            local_view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            landscapeView.addSubview(local_view)
            
            // Preview our local camera track in the local video preview view.
            self.startPreview()
            
            landscapeView.addSubview(remote_camera_view!) // put this on top of the empty_remote_view so that it will "appear" when we connect
            
            var buttonSpacing : CGFloat = spacingConstant
            connect_button.frame = CGRect(x: buttonSpacing, y: buttonYPos, width: buttonWidth, height: buttonHeight)
            buttonSpacing += buttonWidth + spacingConstant
            microphone_button.frame = CGRect(x: buttonSpacing, y: buttonYPos, width: buttonWidth, height: buttonHeight)
            buttonSpacing += buttonWidth + spacingConstant
            record_button.frame = CGRect(x: buttonSpacing, y: buttonYPos, width: buttonWidth, height: buttonHeight)
            buttonSpacing += buttonWidth + spacingConstant
            publish_button.frame = CGRect(x: buttonSpacing, y: buttonYPos, width: buttonWidth, height: buttonHeight)
            
            microphone_button.isHidden = true
            record_button.isHidden = true
            publish_button.isHidden = true
        
            landscapeView.addSubview(connect_button)
            landscapeView.addSubview(microphone_button)
            landscapeView.addSubview(record_button)
            landscapeView.addSubview(publish_button)
            
            landscapeView.addSubview(record_label)
            record_label.topAnchor.constraint(equalTo: landscapeView.topAnchor, constant: 48).isActive = true
            record_label.leadingAnchor.constraint(equalTo: landscapeView.leadingAnchor, constant: 72).isActive = true
            record_label.widthAnchor.constraint(equalTo: landscapeView.widthAnchor, multiplier: 0.3).isActive = true
            
            if let videoChatInstructionsView = videoChatInstructionsView {
                videoChatInstructionsView.removeFromSuperview()
            }
            
            let instructionsXPos = localCameraXPos! + localCameraWidth!
            let instructionsYPos = localCameraYPos
            let instructionsWidth = landscapeView.bounds.width - instructionsXPos - 16
            let instructionsHeight = landscapeView.bounds.height - instructionsYPos!
            let bounds = CGRect(x: instructionsXPos, y: instructionsYPos!, width: instructionsWidth, height: instructionsHeight)
            videoChatInstructionsView = VideoChatInstructionsView.init(frame: bounds)
        
            if let esm = getAppDelegate().editSocialMediaVC,
                let evmd = getAppDelegate().editVideoMissionDescriptionVC,
                let elv = getAppDelegate().editLegislatorForVideoVC {
                videoChatInstructionsView?.buildView(editSocialMediaVC: esm,
                                                     videoChatVC: self,
                                                     editVideoMissionDescriptionVC: evmd,
                                                     editLegislatorForVideoVC: elv)
                landscapeView.addSubview(videoChatInstructionsView!)

                videoChatInstructionsView?.topAnchor.constraint(equalTo: landscapeView.topAnchor, constant: instructionsYPos!).isActive = true
                videoChatInstructionsView?.leadingAnchor.constraint(equalTo: landscapeView.leadingAnchor, constant: instructionsXPos).isActive = true
            }
        }
    }
    
    private func queryCurrentVideoNode() {
        /****
         UNLIKE IN ANDROID, we are NOT checking for nil videoNode here.  That's because once the videoNode
         is created in Swift, it never goes back to nil.  Usually this isn't a problem.  But if you ever delete
         a user's video node, checking for nil here would mean you would never create ANOTHER video node.
         You would always be referring to the deleted node.
         Why is android different?  Because unlike here, in android, we recreate the VidyoChatFragment
         each time we choose the "Video Chat" menu item.  Not so in swift.  In swift, we have CenterViewController.doView()
         CenterViewController.doView() does not recreate view controllers.  It just calls the viewDidLoad() method.
         But viewDidLoad() doesn't reinstantiate the videoNode object.  So if you delete it from the database, the user
         would never know if we put a !=nil check in here
         ******/
        
        let videoNodeKey = getVideoNodeKey()

        // the initial query...
        Database.database()
            .reference()
            .child("video/list")
            .child(videoNodeKey)
            .observe(.value, with: {(snapshot) in

                self.currentVideoNode = VideoNode(snapshot: snapshot, vc: self)
                if let vc = self.videoChatInstructionsView {
                    vc.setVideoNode(videoNode: self.currentVideoNode!)
                }

//                // YOU HAVE TO KNOW IF THE STATE IS ACTUALLY CHANGING !!!  WE DON'T WANT TO ISSUE CONNECT
//                // AND DISCONNECT CALLS WHEN THE STATE HASN'T CHANGED !
                self.figureOutConnectivity()
                
                // Determine publish_button visibility:
                // Hide if the video has been published (email_to_participant_send_date != null)
                // Show if not published but twilio has called back to us with a recording-completed event
                // see twilio-telepatriot.js:twilioCallback()
                // Hide otherwise
                if let vn = self.currentVideoNode {
                    if vn.email_to_participant_send_date != nil { self.publish_button.isHidden = true }
                    else if vn.recording_completed { self.publish_button.isHidden = false }
                    else { self.publish_button.isHidden = true }
                }
                
                // notify the user when publishing is complete - 'cause that's the end
                self.boomNotify()
                
                self.inviteLinks()
            })
    }
    
    var notifiedOfEnd = false
    private func boomNotify() {
        if TPUser.sharedInstance.isAllowed() && TPUser.sharedInstance.isVideoCreator {
            boomNotify1()
        }
        else {
            boomNotify2()
        }
    }
    
    private func boomNotify1() {
        guard let vn = currentVideoNode else { return }
        let videoLifecycleComplete = vn.email_to_participant_send_date != nil
        if videoLifecycleComplete && !notifiedOfEnd {
           
            notifiedOfEnd = true
        
            let title = "BOOM! You Did It!"
            let message = "Mission Accomplished - Your video has been published.  What do you want to do now?"
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            let stop = UIAlertAction(title: "Stop For Now", style: .default, handler: { action in
                switch action.style {
                case .default:
                    self.stopForNow()
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }
            })
        
            let makeAnother = UIAlertAction(title: "Make Another Video", style: .default, handler: { action in
                switch action.style {
                case .default:
                    self.makeAnotherVideo()
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }
            })
        
            alert.addAction(stop)
            alert.addAction(makeAnother)
        
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // for users that aren't allowed in to the app yet.  We don't give them an option to do anything
    // after the video has been published. They can hit ok and that sends them back to the limbo screen
    private func boomNotify2() {
        guard let vn = currentVideoNode else { return }
        let videoLifecycleComplete = vn.email_to_participant_send_date != nil
        if videoLifecycleComplete && !notifiedOfEnd {
            
            notifiedOfEnd = true
            
            let title = "BOOM! You Did It!"
            let message = "Mission Accomplished - Your video has been published.  Check your email."
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            let close = UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style {
                case .default:
                    var updates : [String:Any] = [:]
                    updates["users/\(TPUser.sharedInstance.getUid())/current_video_node_key"] = NSNull()     // can't use nil
                    updates["users/\(TPUser.sharedInstance.getUid())/video_invitation_from"] = NSNull()      // can't use nil
                    updates["users/\(TPUser.sharedInstance.getUid())/video_invitation_from_name"] = NSNull() // can't use nil
                    Database.database().reference().updateChildValues(updates)
                    self.closeScreen()
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }
            })
            
            alert.addAction(close)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func stopForNow() {
        disconnectIfConnected()
        TPUser.sharedInstance.signOut()
    }
    
    private func makeAnotherVideo() {
        // Should create another video node
        notifiedOfEnd = false
        disconnectIfConnected()
        createVideoNodeKey()
        currentVideoNode = nil
        queryCurrentVideoNode()
    }
    
    private func disconnectIfConnected() {
        if let vn = currentVideoNode,
            let room_id = vn.room_id,
            let room = room, room.state == TVIRoomState.connected || room.state == TVIRoomState.connecting {
            
            let request_type = "disconnect request"
            showSpinner() // dismissed in doConnect() and doDisconnect()
            let ve = VideoEvent(uid: TPUser.sharedInstance.getUid(), name: TPUser.sharedInstance.getName(), video_node_key: vn.getKey(), room_id: room_id, request_type: request_type, RoomSid: vn.room_sid, MediaUri: vn.composition_MediaUri) /*keeps the server from trying to create a room that already exists - prevents js exception   see switchboard.js:connect() */
            ve.save()
        }
    }
    
    var currentRoomId : String?
    private func figureOutConnectivity() {
        // Do I have a token?  -geez
        guard let vn = currentVideoNode,
            let room_id = vn.room_id,
            let me = vn.getParticipant(uid: TPUser.sharedInstance.getUid()) else {
            return
        }
        
        var doIHaveToken = false;
        if room_id.starts(with: "record"), let token = me.twilio_token_record {
            doIHaveToken = true
        }
        else if !room_id.starts(with: "record"), let token = me.twilio_token {
            doIHaveToken = true
        }
        
        let iAmAbleToConect = doIHaveToken;
        
        // Are we connected?
        let connected = room != nil && (room?.state == TVIRoomState.connected || room?.state == TVIRoomState.connecting)
        // Should we be connected?
        let shouldBeConnected = me.isConnected();
        // Should we be disconnected?
        let shouldBeDisconnected = !shouldBeConnected;
        // Am I connected to the wrong room?
        let connectedToTheWrongRoom = connected && room_id != currentRoomId
        // Do I need to connect?
        let doINeedToConnect = !connected && shouldBeConnected
        let iAmAboutToConnect = iAmAbleToConect && doINeedToConnect
        let doINeedToDisconnect = connected && shouldBeDisconnected
        let iAmAboutToDisconnect = doINeedToDisconnect
        let doINeedToSwitchRooms = shouldBeConnected && connectedToTheWrongRoom
        let iAmAboutToSwitchRooms = iAmAbleToConect && doINeedToSwitchRooms
        
        print("[VideoChatVC]  ------------------------------------------------------------");
        print("[VideoChatVC]  RoomId IS: \(String(describing: currentRoomId))   -- CHANGING TO: \(room_id)");
        print("[VideoChatVC]      connected: \(connected)");
        print("[VideoChatVC]      shouldBeConnected: \(shouldBeConnected)");
        print("[VideoChatVC]      shouldBeDisconnected: \(shouldBeDisconnected)");
        print("[VideoChatVC]      connectedToTheWrongRoom: \(connectedToTheWrongRoom)");
        print("[VideoChatVC]      iAmAbleToConect: \(iAmAbleToConect)");
        print("[VideoChatVC]      doINeedToConnect: \(doINeedToConnect)");
        print("[VideoChatVC]      iAmAboutToConnect: \(iAmAboutToConnect)");
        print("[VideoChatVC]      doINeedToDisconnect: \(doINeedToDisconnect)");
        print("[VideoChatVC]      iAmAboutToDisconnect: \(iAmAboutToDisconnect)");
        print("[VideoChatVC]      doINeedToSwitchRooms: \(doINeedToSwitchRooms)");
        print("[VideoChatVC]      iAmAboutToSwitchRooms: \(iAmAboutToSwitchRooms)");
        
        if(iAmAboutToConnect) {
            print("[VideoChatVC  connecting...");
            doConnect();
            currentRoomId = vn.room_id
        }
        else if(iAmAboutToDisconnect) {
            print("[VideoChatVC  disconnecting...");
            doDisconnect();
            currentRoomId = vn.room_id
        }
        else if(iAmAboutToSwitchRooms) {
            print("[VideoChatVC]  disconnecting...");
            doDisconnect();
            print("[VideoChatVC]  connecting...");
            doConnect();
            currentRoomId = vn.room_id
        }
    }
    
    
    @objc func connectionClicked(_ sender: Any) {
        guard let vn = currentVideoNode,
            let video_participant = vn.video_participants[TPUser.sharedInstance.getUid()],
            let room_id = vn.room_id
        else {
            simpleOKDialog(title: "Video Chat", message: "Video chat is currently disabled")
            return
        }
        
        recordingWillStart = false // reset these values to false whenever
        recordingWillStop = false  // the connect/disconnect button is clicked
        
        let img = connect_button.currentImage == UIImage(named: "callEnd.png") ? UIImage(named: "callStart.png") : UIImage(named: "callEnd.png")
        DispatchQueue.main.async { self.connect_button.setImage(img, for: UIControlState.normal) }
        
        let request_type = video_participant.isConnected() ? "disconnect request" : "connect request"
        showSpinner() // dismissed in doConnect() and doDisconnect()
        let ve = VideoEvent(uid: TPUser.sharedInstance.getUid(), name: TPUser.sharedInstance.getName(), video_node_key: vn.getKey(), room_id: room_id, request_type: request_type, RoomSid: vn.room_sid, MediaUri: vn.composition_MediaUri) /*keeps the server from trying to create a room that already exists - prevents js exception   see switchboard.js:connect() */
        ve.save()
    }
    
    //var connected = false
    private func doConnect() {
        if (room != nil && (room?.state == TVIRoomState.connected || room?.state == TVIRoomState.connecting)) {
            return
        }
        
        guard let videoNode = currentVideoNode,
            let me = videoNode.video_participants[TPUser.sharedInstance.getUid()],
            let room_id = videoNode.room_id
            else {
                return
        }
        
        let token = room_id.starts(with: "record") ? me.twilio_token_record : me.twilio_token
        guard let mytoken = token else {
            return
        }
        
        DispatchQueue.main.async {
            self.dismissSpinner()
        }
        
        
        // Prepare local media which we will share with Room Participants.
        self.prepareLocalMedia()
        
        // Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = TVIConnectOptions.init(token: mytoken) { (builder) in
            
            // Use the local media that we prepared earlier.
            builder.audioTracks = self.localAudioTrack != nil ? [self.localAudioTrack!] : [TVILocalAudioTrack]()
            builder.videoTracks = self.localVideoTrack != nil ? [self.localVideoTrack!] : [TVILocalVideoTrack]()
            
            // Use the preferred audio codec
            if let preferredAudioCodec = self.audioCodec {
                builder.preferredAudioCodecs = [preferredAudioCodec]
            }
            
            // Use the preferred video codec
            if let preferredVideoCodec = self.videoCodec {
                builder.preferredVideoCodecs = [preferredVideoCodec]
            }
            
            // Use the preferred encoding parameters
            if let encodingParameters = self.getEncodingParameters() {
                builder.encodingParameters = encodingParameters
            }
            
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = room_id
        }
        
        // Connect to the Room using the options we provided.
        room = TwilioVideo.connect(with: connectOptions, delegate: self)
        if let room = room
            //, room.isRecording // why doesn't THIS work?
            , room.name.starts(with: "record")
        {
            DispatchQueue.main.async { self.record_label.text = "Recording..." }
        }
        self.buttonStates(inRoom: true)
    }
    
    private func doDisconnect() {
        if (room != nil && room?.state == TVIRoomState.disconnected) {
            return
        }
        
        if let room = room {
            room.disconnect()
            remoteCameraVisible = false
            if recordingWillStop {
                DispatchQueue.main.async { self.record_label.text = "Recording stopped" }
            } else if recordingWillStart { /*noop*/ }
            else {
                DispatchQueue.main.async { self.record_label.text = "" }
            }
            print("[VideoChatVC]  disconnected from:  \(String(describing: room.name)) (currentVideoNode.room_id = \(room_id)");
            self.buttonStates(inRoom: false)
        }
    }
    
    private func getVideoNodeKey() -> String {
        if let key = TPUser.sharedInstance.current_video_node_key {
            return key
        }
        else {
            return createVideoNodeKey()
        }
    }
    
    private func createVideoNodeKey() -> String {
        let vn = createVideoNode()
        TPUser.sharedInstance.setCurrent_video_node_key(current_video_node_key: vn.getKey())
        return vn.getKey()
    }

    private func createVideoNode() -> VideoNode {
        let appDelegate = getAppDelegate()

        // hardcode for now...
        let theType = "Video Petition"
        // appDelegate.videoTypes is created in AppDelegate: func application(_ application: UIApplication, didFinishLaunchingWithOptions...)
        let videoType = appDelegate.videoTypes.filter{ $0.type == theType }.first

        return VideoNode(creator: TPUser.sharedInstance, type: videoType)
    }
    
    
    var micMuted = false
    @objc func micClicked(_ sender: Any) {
        if let localAudioTrack = localAudioTrack {
            let imgName = micMuted ? "microphoneOnWhite.png" : "microphoneOff.png"
            self.microphone_button.setImage(UIImage(named: imgName), for: .normal)
            localAudioTrack.isEnabled = !localAudioTrack.isEnabled
            micMuted = !micMuted
        }
    }
    
    private func startPreview() {
        
        // Preview our local camera track in the local video preview view.
        camera = TVICameraCapturer(source: .frontCamera, delegate: self)
        localVideoTrack = TVILocalVideoTrack.init(capturer: camera!, enabled: true, constraints: nil, name: "Camera")
        
        // TODO sloppy. This will never be nil.  We just instantiated it.
        if (localVideoTrack == nil) {
            //logMessage(messageText: "Failed to create video track")
            print("localVideoTrack is nil - that's not good")
        } else {
            local_camera_view = TVIVideoView(frame: CGRect(x: localCameraXPos!, y: localCameraYPos!, width: localCameraWidth!, height: localHeight!))
            local_camera_view.backgroundColor = .black
            if let landscapeView = landscapeView {
                /*local_*/landscapeView.addSubview(local_camera_view)
            }
            
            // doesn't do what I want - goes full screen regardless of height and width anchors
            local_camera_view.topAnchor.constraint(equalTo: local_view.topAnchor, constant: 0).isActive = true
            local_camera_view.leadingAnchor.constraint(equalTo: local_view.leadingAnchor, constant: 0).isActive = true
            local_camera_view.widthAnchor.constraint(equalTo: local_view.widthAnchor, constant: 1).isActive = true
            local_camera_view.heightAnchor.constraint(equalTo: local_view.heightAnchor, constant: 1).isActive = true
            
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.local_camera_view)
            
            //logMessage(messageText: "Video track created")
            
            // We will flip camera on tap.
            let tap = UITapGestureRecognizer(target: self, action: #selector(VideoChatVC.flipCamera))
            self.local_camera_view.addGestureRecognizer(tap)
        }
    }
    
    // don't really need this
    @objc func flipCamera() {
        if (self.camera?.source == .frontCamera) {
            self.camera?.selectSource(.backCameraWide)
        } else {
            self.camera?.selectSource(.frontCamera)
        }
    }
    
//    func videoInvitationExtended(name: String) {
//        print("videoInvitationExtended():  name = \(name)")
//    }
    
//    func videoInvitationNotExtended() {
//        print("videoInvitationNotExtended()")
//    }
    
    func rotated() {
        print("rotated():  phone orientation was just rotated")
        viewDidLoad() // checks device orientation and only loads if in landscape mode
    }
    
    private func showSpinner() {
//        DispatchQueue.main.async {
//            self.showSpinner2()
//        }
    }

    private func showSpinner2() {
//        if (self.spinning) {
//            return
//        }
//        self.spinnerView?.addSubview(self.ai)
//        print("showSpinner2():  ================================================")
//        print("showSpinner2():  self.spinnerView?.addSubview(self.ai)")
//        self.view.addSubview(self.spinnerView!)
//        print("showSpinner2():  self.view.addSubview(self.spinnerView!)")
//        self.spinning = true
//        print("showSpinner2():  self.spinning = \(self.spinning)")
    }
    
    func prepareLocalMedia() {
        
        // We will share local audio and video when we connect to the Room.
        
        // Create an audio track.
        if (localAudioTrack == nil) {
            // didn't cancel echo like I hoped, but is a good example of how to create one of these options objects
            //let options = TVIAudioOptions.init(block: {(builder: TVIAudioOptionsBuilder) -> Void in
            //    builder.isSoftwareAecEnabled = true
            //})
            localAudioTrack = TVILocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")
            
            if (localAudioTrack == nil) {
                print("Failed to create audio track")
            }
        }
        
        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
    }
    
    func cleanupRemoteParticipant() {
        if ((self.remoteParticipant) != nil) {
            if ((self.remoteParticipant?.videoTracks.count)! > 0) {
                let remoteVideoTrack = self.remoteParticipant?.remoteVideoTracks[0].remoteTrack
                remoteVideoTrack?.removeRenderer(self.remote_camera_view!)
                remote_camera_view?.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 1, alpha: 0.8)
//                self.remote_camera_view?.removeFromSuperview()
//                self.remote_camera_view = nil
            }
        }
        self.remoteParticipant = nil
    }
    
    func getEncodingParameters() -> TVIEncodingParameters?  {
        if maxAudioBitrate == 0 && maxVideoBitrate == 0 {
            return nil;
        } else {
            return TVIEncodingParameters(audioBitrate: maxAudioBitrate,
                                         videoBitrate: maxVideoBitrate)
        }
    }
    
    // Update our UI based upon if we are in a Room or not
    func buttonStates(inRoom: Bool) {
        guard let vn = currentVideoNode else {
            return
        }
        if recordingWillStart || recordingWillStop {
            // prevent the buttons from changing state when the recording starts and stops - very confusing to the user
            // The user doesn't know that they are actually being disconnected from one room and automatically connected to another room
        } else {
            self.connect_button.setImage(UIImage(named: inRoom ? "callEnd.png" : "callStart.png"), for: UIControlState.normal)
            self.microphone_button.isHidden = !inRoom
            self.record_button.isHidden = !inRoom
        }
    }
    
    private func dismissSpinner() {
//        if (!spinning) {
//            return
//        }
//        self.ai.removeFromSuperview()
//        print("dismissSpinner():  ================================================")
//        print("dismissSpinner():  self.ai.removeFromSuperview()")
//        self.spinnerView?.removeFromSuperview()
//        print("dismissSpinner():  self.spinnerView?.removeFromSuperview()")
//        spinning = false
//        print("dismissSpinner():  self.spinning = \(self.spinning)")
    }
    
    private var recording = false
    private var recordingWillStart = false
    private var recordingWillStop = false
    @objc func recordClicked(_ sender: Any) {
        
        guard let vn = currentVideoNode else {
            return
        }
        
        guard let _ = vn.legislator else {
            simpleOKDialog(title: "Choose Legislator", message: "Choose a legislator before recording")
            return
        }
        
//        The red "Recording..." indicator is set in doConnect() and unset in doDisconnect()
        
        if let room_id = vn.room_id, let _ = vn.room_sid
        {
            if let _ = vn.recording_stopped {
                let alert = UIAlertController(title: "Erase Recording?", message: "Do you want to record over the video you just created?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Keep", style: .cancel, handler: { action in
                    switch action.style {
                    case .default:
                        print("default")
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    }
                }))
                alert.addAction(UIAlertAction(title: "Record Over", style: .destructive, handler: { action in
                    switch action.style {
                    case .default:
                        print("default")
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        self.doRecording(vn: vn, room_id: room_id)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                doRecording(vn: vn, room_id: room_id)
            }
            
        }
        else {
            simpleOKDialog(title: "Recording", message: "Recording is currently disabled")
        }
    }
    
    private func doRecording(vn: VideoNode, room_id: String) {
        
        var rec_label = ""
        if vn.recordingHasNotStarted() || vn.recordingHasStopped() {
            rec_label = "Recording will start momentarily"
            recordingWillStart = true
            recordingWillStop = false
        } else {
            rec_label = "Recording will stop momentarily"
            recordingWillStart = false
            recordingWillStop = true
        }
        DispatchQueue.main.async {
            self.record_label.text = rec_label
        }
        
        let video_node_key = vn.getKey()
        let request_type = vn.recordingHasStarted() ? "stop recording" : "start recording"
        showSpinner() // dismissed in doConnect() and doDisconnect()
        let ve = VideoEvent(uid: TPUser.sharedInstance.getUid(), name: TPUser.sharedInstance.getName(), video_node_key: video_node_key, room_id: room_id, request_type: request_type, RoomSid: vn.room_sid, MediaUri: vn.composition_MediaUri)
        ve.save()
    }
    
//    private func recordingHasNotStarted() {
//        publish_button.isHidden = true
//    }
//
//    private func recordingHasStarted() {
//        publish_button.isHidden = true
//    }
//
//    private func recordingHasStopped() {
//        publish_button.isHidden = false
//    }
    
    private func simpleOKDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
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
    
    private func simpleDeleteCancelDialog(title: String, message: String, delete: String, cancel: String, deleteFunction: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: { action in
            switch action.style {
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        alert.addAction(UIAlertAction(title: delete, style: .destructive, handler: { action in
            switch action.style {
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                deleteFunction()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func publishClicked(_ sender: Any) {
        
        guard let vn = currentVideoNode else {
            return
        }
        
        if let room_id = vn.room_id
        {
            simpleOKDialog(title: "Publishing", message: "Publishing has started. You will get an email when your video is ready.  May take up to 10 mins.")
            let video_node_key = vn.getKey()
            let request_type = "start publishing"
            showSpinner() // dismissed in doConnect() and doDisconnect()
            let ve = VideoEvent(uid: TPUser.sharedInstance.getUid(),
                                name: TPUser.sharedInstance.getName(),
                                video_node_key: video_node_key,
                                room_id: room_id,
                                request_type: request_type,
                                RoomSid: vn.room_sid_record,
                                MediaUri: vn.composition_MediaUri)
            ve.save()
        }
        else {
            simpleOKDialog(title: "Publishing", message: "Publishing is currently disabled")
        }
    }
    
    // modeled after VidyoChatFragment.inviteLinks()
    // TODO need to figure out if we're using rid()/unrid() or videoInvitationNotExtended()/videoInvitationNotExtended() or this
    private func inviteLinks() {
        if remoteCameraVisible {
            invite_someone_button.removeFromSuperview()
            guest_name.removeFromSuperview()
            revoke_invitation_button.removeFromSuperview()
        }
        else if let video_invitation_extended_to = currentVideoNode?.video_invitation_extended_to, let landscapeView = landscapeView {
            invite_someone_button.removeFromSuperview()
            if TPUser.sharedInstance.getName() == video_invitation_extended_to {
                if let inviteFrom = TPUser.sharedInstance.video_invitation_from_name {
                    landscapeView.addSubview(guest_name)
                    guest_name.text = "\(inviteFrom) has invited you to participate in a video chat"
                    guest_name.isHidden = false
                    guest_name.topAnchor.constraint(equalTo: landscapeView.centerYAnchor, constant: 48).isActive = true
                    guest_name.leadingAnchor.constraint(equalTo: landscapeView.leadingAnchor, constant: 24).isActive = true
                    guest_name.trailingAnchor.constraint(equalTo: (videoChatInstructionsView?.leadingAnchor)!, constant:-24).isActive = true
                    landscapeView.addSubview(revoke_invitation_button)
                    revoke_invitation_button.topAnchor.constraint(equalTo: guest_name.bottomAnchor, constant:16).isActive = true
                    revoke_invitation_button.centerXAnchor.constraint(equalTo: guest_name.centerXAnchor, constant:0).isActive = true
                }
            }
            else {
                if remote_camera_view != nil {
                    landscapeView.addSubview(guest_name)
                    guest_name.text = "You have invited \(video_invitation_extended_to) to participate in a video chat"
                    guest_name.isHidden = false
                    guest_name.topAnchor.constraint(equalTo: landscapeView.centerYAnchor, constant: 48).isActive = true
                    guest_name.leadingAnchor.constraint(equalTo: landscapeView.leadingAnchor, constant: 24).isActive = true
                    guest_name.trailingAnchor.constraint(equalTo: (videoChatInstructionsView?.leadingAnchor)!, constant:-24).isActive = true
                    landscapeView.addSubview(revoke_invitation_button)
                    revoke_invitation_button.topAnchor.constraint(equalTo: guest_name.bottomAnchor, constant:16).isActive = true
                    revoke_invitation_button.centerXAnchor.constraint(equalTo: guest_name.centerXAnchor, constant:0).isActive = true
                }
            }
        }
        else {
            // means the remote camera is not visible and there's no invitation extended yet
            let ivl = self.isViewLoaded
            let ibp = self.isBeingPresented
            let hack = TPUser.sharedInstance.isAllowed() || (ivl && ibp)
            if hack, // hack bug fix - keeps app from crashing when invitation is revoked and the user is actually on the limbo screen
                let _ = remote_camera_view,
                let landscapeView = landscapeView
            {
                landscapeView.addSubview(invite_someone_button)
                invite_someone_button.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 48).isActive = true
                invite_someone_button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 96).isActive = true
                guest_name.removeFromSuperview()
                revoke_invitation_button.removeFromSuperview()
            }
        }
    }
    

    // These next two functions kinda go together.  This first one pops up the Search Users screen
    @objc private func inviteSomeone(_ sender: UIButton) {
        // pop up the same Search Users screen that Admins see
        if let vc = getAppDelegate().searchUsersVC {
            vc.modalPresentationStyle = .popover
            vc.searchUsersDelegate = self
            self.present(vc, animated: true, completion:nil)
            // See extension VideoChatVC : SearchUsersDelegate below
        }
    }

    @objc private func checkForLandscape(_ sender: UIButton) {
        if UIDevice.current.orientation.isLandscape {
            viewDidLoad()
        }
        else {
            simpleOKDialog(title: "Rotate", message: "Phone orientation is still Portrait.  Rotate 90 degress please")
        }
    }
    
    // revoke_invitation_button should only be displayed when an invitation has been extended
    @objc private func revokeInvitation(_ sender: UIButton) {
        
        //        Do this on the server side instead
        
        //        if let vn = videoNode, let video_invitation_key = vn.video_invitation_key,
        //            let video_invitation_extended_to = vn.video_invitation_extended_to
        //        {
        //            let request_type = "revoke invitation"
        //            let video_node_key = vn.getKey()
        //            let ve = VideoEvent(uid: TPUser.sharedInstance.getUid(),
        //                                name: TPUser.sharedInstance.getName(),
        //                                video_node_key: video_node_key,
        //                                video_invitation_key: video_invitation_key,
        //                                video_invitation_extended_to: video_invitation_extended_to,
        //                                request_type: request_type, RoomSid: nil)
        //            ve.save()
        //        }
        
        
        guard let vn = currentVideoNode else {
            return
        }
        let vi = VideoInvitation(videoNode: vn)
        vi.delete();
        
    }
    
}

extension VideoChatVC : SearchUsersDelegate {
    
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
            currentVideoNode?.video_invitation_key = video_invitation_key

            // now write the video_invitation_key to the video node so that we can revoke the invitation later if we want to
            let data = ["video/list/\(vid)/video_invitation_key" : video_invitation_key,
                        "video/list/\(vid)/video_invitation_extended_to" : user.getName(),
                        "users/\(user.getUid())/video_invitation_from" : TPUser.sharedInstance.getUid(),
                        "users/\(user.getUid())/video_invitation_from_name" : TPUser.sharedInstance.getName(),
                        "users/\(user.getUid())/current_video_node_key" : TPUser.sharedInstance.current_video_node_key]
            Database.database().reference().updateChildValues(data)
        }
    }
}

extension VideoChatVC : AccountStatusEventListener {
    func roleAssigned(role: String) {
        
    }
    
    func roleRemoved(role: String) {
        
    }
    
    func teamSelected(team: TeamIF, whileLoggingIn: Bool) {
        
    }
    
    func userSignedOut() {
        
    }
    
    func allowed() {
        
    }
    
    func notAllowed() {
        
    }
    
    func accountEnabled() {
        
    }
    
    func accountDisabled() {
        
    }
    
    func videoInvitationExtended(vi: VideoInvitation) {
        
    }
    
    func videoInvitationRevoked() {
        if TPUser.sharedInstance.isAllowed() && TPUser.sharedInstance.isVideoCreator {
            // If you are a vetted user and your invitation is cancelled, we will just present you
            // with the "invite someone" link
        }
        else if TPUser.sharedInstance.isAllowed() && !TPUser.sharedInstance.isVideoCreator {
            // not sure what to do here - just log the user out
            TPUser.sharedInstance.signOut()
        }
        else {
            // If you came from the Limbo screen, you go back to the Limbo screen
            closeScreen()
        }
    }
    
    
}

// MARK: TVIRoomDelegate
extension VideoChatVC : TVIRoomDelegate {
    func didConnect(to room: TVIRoom) {
        
        // At the moment, this example only supports rendering one Participant at a time.
        
        print("Connected to room \(room.name) as \(String(describing: room.localParticipant?.identity))")
        
        if (room.remoteParticipants.count > 0) {
            self.remoteParticipant = room.remoteParticipants[0]
            self.remoteParticipant?.delegate = self
        }
    }
    
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
        print("Disconnected from room \(room.name), error = \(String(describing: error))")
        self.cleanupRemoteParticipant()
        self.room = nil
        self.buttonStates(inRoom: false)
    }
    
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
        print("Failed to connect to room with error")
        self.room = nil
        self.buttonStates(inRoom: false)
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
        if (self.remoteParticipant == nil) {
            self.remoteParticipant = participant
            self.remoteParticipant?.delegate = self
        }
        print("Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
    
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
        if (self.remoteParticipant == participant) {
            cleanupRemoteParticipant()
        }
        print("Room \(room.name), Participant \(participant.identity) disconnected")
    }
}


// MARK: TVIRemoteParticipantDelegate
extension VideoChatVC : TVIRemoteParticipantDelegate {

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           publishedVideoTrack publication: TVIRemoteVideoTrackPublication) {

        // Remote Participant has offered to share the video Track.

        print("Participant \(participant.identity) published \(publication.trackName) video track")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           unpublishedVideoTrack publication: TVIRemoteVideoTrackPublication) {

        // Remote Participant has stopped sharing the video Track.

        print("Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           publishedAudioTrack publication: TVIRemoteAudioTrackPublication) {

        // Remote Participant has offered to share the audio Track.

        print("Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           unpublishedAudioTrack publication: TVIRemoteAudioTrackPublication) {

        // Remote Participant has stopped sharing the audio Track.

        print("Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }

    func subscribed(to videoTrack: TVIRemoteVideoTrack,
                    publication: TVIRemoteVideoTrackPublication,
                    for participant: TVIRemoteParticipant) {

        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's video frames now.

        print("Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == participant) {
            
            if let remote_camera_view = self.remote_camera_view {
                remoteCameraVisible = true
                inviteLinks()
                remote_camera_view.backgroundColor = .black
                videoTrack.addRenderer(remote_camera_view)
            }
        }
    }

    func unsubscribed(from videoTrack: TVIRemoteVideoTrack,
                      publication: TVIRemoteVideoTrackPublication,
                      for participant: TVIRemoteParticipant) {

        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.

        print("Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == participant) {
            remoteCameraVisible = false
            videoTrack.removeRenderer(self.remote_camera_view!)
            inviteLinks()
            remote_camera_view?.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 1, alpha: 0.8)
        }
    }

    func subscribed(to audioTrack: TVIRemoteAudioTrack,
                    publication: TVIRemoteAudioTrackPublication,
                    for participant: TVIRemoteParticipant) {

        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.

        print("Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }

    func unsubscribed(from audioTrack: TVIRemoteAudioTrack,
                      publication: TVIRemoteAudioTrackPublication,
                      for participant: TVIRemoteParticipant) {

        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.

        print("Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           enabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
        print("Participant \(participant.identity) enabled \(publication.trackName) video track")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           disabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
        print("Participant \(participant.identity) disabled \(publication.trackName) video track")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           enabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
        print("Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           disabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
        print("Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    func failedToSubscribe(toAudioTrack publication: TVIRemoteAudioTrackPublication,
                           error: Error,
                           for participant: TVIRemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }

    func failedToSubscribe(toVideoTrack publication: TVIRemoteVideoTrackPublication,
                           error: Error,
                           for participant: TVIRemoteParticipant) {
        print("FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}
