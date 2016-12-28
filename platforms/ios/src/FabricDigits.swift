import Foundation
import Cordova
import Fabric
import DigitsKit

fileprivate func log(_ msg: String) {
    print(msg)
}

@objc(FabricDigits)
class FabricDigits: CDVPlugin {
    private var currentCommand: CDVInvokedUrlCommand?

    // MARK: - Plugin Commands
    
    func login(_ command: CDVInvokedUrlCommand) {
        fork(command) {
            Digits.sharedInstance().authenticate(completion: { (session: DGTSession?, error: Error?) -> Void in
                if let error = error {
                    self.finish_error(error.localizedDescription)
                } else {
                    if let session = session {
                        self.finish_ok([
                            "token": session.authToken,
                            "secret": session.authTokenSecret
                        ])
                    } else {
                        self.finish_error("No session available.")
                    }
                }
            })
        }
    }
    
    func logout(_ command: CDVInvokedUrlCommand) {
        fork(command) {
            Digits.sharedInstance().logOut()
            self.finish_ok()
        }
    }
    
    
    func getToken(_ command: CDVInvokedUrlCommand) {
        fork(command) {
            if let session = Digits.sharedInstance().session() {
                self.finish_ok([
                    "token": session.authToken,
                    "secret": session.authTokenSecret
                ])
            } else {
                self.finish_ok()
            }
        }
    }
    
    // MARK: - Private Utillities
    
    private func fork(_ command: CDVInvokedUrlCommand, _ proc: @escaping () -> Void) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async(execute: {
            self.currentCommand = command
            defer {
                self.currentCommand = nil
            }
            proc()
        })
    }
    
    private func finish_error(_ msg: String!) {
        if let command = self.currentCommand {
            commandDelegate!.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: msg), callbackId: command.callbackId)
        }
    }
    
    private func finish_ok(_ result: Any? = nil) {
        if let command = self.currentCommand {
            log("Command Result: \(result)")
            if let msg = result as? String {
                commandDelegate!.send(CDVPluginResult(status: CDVCommandStatus_OK, messageAs: msg), callbackId: command.callbackId)
            } else if let dict = result as? [String: AnyObject] {
                commandDelegate!.send(CDVPluginResult(status: CDVCommandStatus_OK, messageAs: dict), callbackId: command.callbackId)
            } else if result == nil {
                commandDelegate!.send(CDVPluginResult(status: CDVCommandStatus_OK), callbackId: command.callbackId)
            }
        }
    }
}
