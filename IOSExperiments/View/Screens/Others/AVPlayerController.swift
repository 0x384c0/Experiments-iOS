

import UIKit

import AVFoundation

class AVPlayerController: UIViewController {
    
    //MARK: UI
    @IBOutlet weak var streamButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoText: UITextView!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var stream: UITextField!
    
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVPlayer()
        setStreamStatusToView()
    }
    
    //MARK: actions
    @IBAction func playTap(_ sender: AnyObject) {
        toggleAVPlayer()
    }
    @IBAction func streamTap(_ sender: UIButton) {
        urlDidChanged(url)
        streamNameDidChanged(stream)
        toggleScreenStreaming()
    }
    func urlDidChanged(_ sender: UITextField) {
        if let
            placeholder = sender.placeholder
            ,
            sender.text?.isBlank ?? true {
            ScreenStreamer.shared.URL = placeholder
        } else {
            if let _ = URL(string: sender.text!){
                ScreenStreamer.shared.STREAM = sender.text!
            }
        }
    }
    func streamNameDidChanged(_ sender: UITextField) {
        if let
            placeholder = sender.placeholder
            ,
            sender.text?.isBlank ?? true {
            ScreenStreamer.shared.STREAM = placeholder
        } else {
            ScreenStreamer.shared.STREAM = sender.text!
        }
        print(#function)
        print(sender.text)
        print(sender.placeholder)
        print(ScreenStreamer.shared.STREAM)
    }
    
    //MARK: avplayer
    var player = AVPlayer()
    func setupAVPlayer() {
        let url = "http://touhouradio.com:8000/touhouradio.mp3"
        if let steamingURL:URL = URL(string:url) {
            let playerItem = AVPlayerItem( url: steamingURL )
            player = AVPlayer(playerItem:playerItem)            
            
        }        
    }
    func toggleAVPlayer(){
        if (player.rate != 0 && player.error == nil)  {
            player.pause()
        } else {
            player.play()
        }
        
    }
    
    //MARK: screen stream
    func setStreamStatusToView(){
        streamButton.isEnabled = true
        if ScreenStreamer.shared.connected {
            streamButton.setTitle("Stop stream screen and Disconnect", for: UIControlState())
            infoText.text = "Connected to \(ScreenStreamer.shared.URL)/\(ScreenStreamer.shared.STREAM)"
            activityIndicator.startAnimating()
        } else {
            streamButton.setTitle("Connect and stream screen", for: UIControlState())
            infoText.text = "Not Connected to \(ScreenStreamer.shared.URL)/\(ScreenStreamer.shared.STREAM)"
            activityIndicator.stopAnimating()
        }
    }
    func toggleScreenStreaming(){
        
        streamButton.isEnabled = false
        if ScreenStreamer.shared.connected {
            ScreenStreamer.shared.stop(){[unowned self] in
                self.setStreamStatusToView()
            }
        } else {
            ScreenStreamer.shared.start(){[unowned self] in
                self.setStreamStatusToView()
            }
        }
    }
}
