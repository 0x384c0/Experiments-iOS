

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
        url.text = ScreenStreamer.shared.URL 
        stream.text = ScreenStreamer.shared.STREAM 
        setupAVPlayer()
        setStreamStatusToView()
    }
    
    //MARK: actions
    @IBAction func playTap(_ sender: AnyObject) {
        toggleAVPlayer()
    }
    @IBAction func streamTap(_ sender: UIButton) {
        ScreenStreamer.shared.URL = url.text!
        ScreenStreamer.shared.STREAM = stream.text!
        toggleScreenStreaming()
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
            streamButton.setTitle("Stop stream screen and Disconnect", for: UIControl.State())
            infoText.text = "Connected to \(ScreenStreamer.shared.URL)/\(ScreenStreamer.shared.STREAM)"
            activityIndicator.startAnimating()
        } else {
            streamButton.setTitle("Connect and stream screen", for: UIControl.State())
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
