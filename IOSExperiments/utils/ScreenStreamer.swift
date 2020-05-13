//
//  ScreenStreamer.swift
//  IOSExperiments
//
//  Created by Andrew Ashurow on 19.09.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import HaishinKit
import VideoToolbox
import AVFoundation

class ScreenStreamer {
    
    var
    URL = "rtmp://localhost:1935/live",
    STREAM = "stream"
    
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
        
        
        rtmpConnection.addEventListener(Event.Name.rtmpStatus,  selector:#selector(ScreenStreamer.rtmpStatusHandler(_:)), observer: self)
        rtmpConnection.addEventListener(Event.Name.event,        selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
        rtmpConnection.addEventListener(Event.Name.ioError,     selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
        rtmpConnection.addEventListener(Event.Name.sync,         selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
    }
    
    deinit {
        rtmpConnection.removeEventListener(Event.Name.rtmpStatus,   selector:#selector(ScreenStreamer.rtmpStatusHandler(_:)), observer: self)
        rtmpConnection.removeEventListener(Event.Name.event,         selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
        rtmpConnection.removeEventListener(Event.Name.ioError,      selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
        rtmpConnection.removeEventListener(Event.Name.sync,          selector:#selector(ScreenStreamer.eventHandler(_:)), observer: self)
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
