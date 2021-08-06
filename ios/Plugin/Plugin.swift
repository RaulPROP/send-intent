import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(SendIntent)
public class SendIntent: CAPPlugin {
    
    let store = ShareStore.store

    @objc func checkSendIntentReceived(_ call: CAPPluginCall) {
        if !store.processed {
            call.resolve([
                "type": store.type,
                "uri": store.uri,
                "text": store.text,
            ])
            store.processed = true
        }
    }

    public override func load() {
        let nc = NotificationCenter.default
            nc.addObserver(self, selector: #selector(eval), name: Notification.Name("triggerSendIntent"), object: nil)
    }

    @objc open func eval(){
        self.bridge?.eval(js: "window.dispatchEvent(new Event('sendIntentReceived'))");
    }

}
