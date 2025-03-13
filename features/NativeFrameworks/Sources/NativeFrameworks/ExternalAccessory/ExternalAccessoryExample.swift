//NativeFrameworks
// Created on: 13/3/25

import Foundation
import ExternalAccessory

class ExternalAccessoryExample : NSObject {
    private var accessory: EAAccessory?
    private var session: EASession?
    private var inputStream: InputStream?
    private var outputStream: OutputStream?

    func connectToAccessory() {
        let accessoryManager = EAAccessoryManager.shared()
        let connectedAccessories = accessoryManager.connectedAccessories

        for accessory in connectedAccessories {
            if accessory.protocolStrings.contains("com.example.protocol") {
                self.accessory = accessory
                openSession()
                break
            }
        }
    }

    private func openSession() {
        if session != nil {
            closeSession()
        }

        guard let accessory = accessory else { return }
        session = EASession(accessory: accessory, forProtocol: "com.example.protocol")

        if let session = session {
            inputStream = session.inputStream
            outputStream = session.outputStream

            inputStream?.delegate = self
            outputStream?.delegate = self

            inputStream?.schedule(in: .current, forMode: .default)
            outputStream?.schedule(in: .current, forMode: .default)

            inputStream?.open()
            outputStream?.open()

            guard inputStream?.streamStatus == .open, outputStream?.streamStatus == .open else {
                print("Failed to open streams. Closing session.")
                return
            }
        }
    }

    func readData() -> Data? {
        guard let inputStream = inputStream else { return nil }
        var buffer = [UInt8](repeating: 0, count: 1024)
        let bytesRead = inputStream.read(&buffer, maxLength: buffer.count)
        if bytesRead > 0 {
            return Data(bytes: buffer, count: bytesRead)
        }
        return nil
    }

    func writeData(_ string: String) {
        guard let outputStream = outputStream else { return }
        guard let data = string.data(using: .utf8) else { return }
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            outputStream.write(pointer, maxLength: data.count)
        }
    }

    private func closeSession() {
        inputStream?.close()
        outputStream?.close()
        inputStream?.remove(from: .current, forMode: .default)
        outputStream?.remove(from: .current, forMode: .default)
        inputStream = nil
        outputStream = nil
        session = nil
        accessory = nil
    }
}

// Extend the class to conform to the StreamDelegate protocol
extension ExternalAccessoryExample: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            if aStream === inputStream {
                if let data = readData() {
                    print(data)
                }
            }
        case .hasSpaceAvailable:
            if aStream === outputStream {
                writeData("Hello, accessory!")
            }
        case .endEncountered, .errorOccurred:
            closeSession()
        default:
            break
        }
    }
}
