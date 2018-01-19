//
//  ScreenStreamer.swift
//  IOSExperiments
//
//  Created by Andrew Ashurow on 19.09.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import lf
import VideoToolbox
import AVFoundation
import XCGLogger

class ScreenStreamer {
    
    var
    URL = "rtmp://localhost/live",
    STREAM = "test"
    
    static let
    shared = ScreenStreamer()
    
    fileprivate let
    rtmpConnection:RTMPConnection,
    rtmpStream:RTMPStream
    fileprivate var
    rtmpCompletion:(() -> ())?
    fileprivate init(){
        print("init \(type(of: self))")
        rtmpConnection = RTMPConnection()
        rtmpStream = RTMPStream(connection: rtmpConnection)
        rtmpStream.attachScreen(ScreenCaptureSession(shared: UIApplication.shared))
        //XCGLogger.defaultInstance().outputLogLevel = .Error
        
        
        rtmpConnection.addEventListener(Event.RTMP_STATUS,  selector:#selector(ScreenStreamer.rtmpStatusHandler(_:)), observer: self)
        rtmpConnection.addEventListener(Event.EVENT,        selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
        rtmpConnection.addEventListener(Event.IO_ERROR,     selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
        rtmpConnection.addEventListener(Event.SYNC,         selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
    }
    
    deinit {
        rtmpConnection.removeEventListener(Event.RTMP_STATUS,   selector:#selector(ScreenStreamer.rtmpStatusHandler(_:)), observer: self)
        rtmpConnection.removeEventListener(Event.EVENT,         selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
        rtmpConnection.removeEventListener(Event.IO_ERROR,      selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
        rtmpConnection.removeEventListener(Event.SYNC,          selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
    }
    var connected:Bool {
        return rtmpConnection.connected
    }
    func start( completion: @escaping () -> ()) {
        rtmpConnection.connect(URL)
        rtmpCompletion = completion
    }
    func stop( completion: @escaping () -> ()) {
        rtmpConnection.close()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            sleep(2)
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    @objc func rtmpStatusHandler(_ notification:Notification) {
        let event = Event.from(notification)
        if let
            data = event.data as? ASObject,
            let code = data["code"] as? String {
            //print("\(#function): " + code)
            switch code {
            case RTMPConnection.Code.connectSuccess.rawValue:
                rtmpStream.publish(STREAM)
            default:
                break
            }
            DispatchQueue.main.async { [unowned self] in
                print(code)
                self.rtmpCompletion?()
                self.rtmpCompletion = nil
            }
        }
    }
    @objc func eventHandler(_ notification:Notification) {
        let event = Event.from(notification)
        print("\(#function): " ,terminator:"")
        print(event)
        if let
            data = event.data as? ASObject,
            let code = data["code"] as? String {
            print(code)
        }
    }
}
