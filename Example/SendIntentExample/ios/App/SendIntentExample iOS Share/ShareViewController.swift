import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    private var uriString: String?
    private var textString: String?
    private var typeString: String?

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        var urlString = "SendIntentExample://?text=" + (self.textString ?? "");
        urlString = urlString + "&uri=" + (self.uriString ?? "");
        urlString = urlString + "&type=" + (self.typeString ?? "");
        let url = URL(string: urlString)!
        _ = openURL(url)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.extensionContext?.inputItems as Any)

        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        
        for attachment in attachments {
            
            attachment.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: self.urlDataHandler)
            
            attachment.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler:self.textDataHandler)
            
        }
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.didSelectPost), userInfo: nil, repeats: false)

    }

    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
    func urlDataHandler(_ item: NSSecureCoding?, _ error: Error?) -> Void {
        if (item != nil) {
            self.handleUrlData(item as? NSURL)
        }
    }
    
    func textDataHandler(_ item: NSSecureCoding?, _ error: Error?) -> Void {
        if (item != nil) {
            self.handleTextData(item as? NSString)
            self.handleUrlData(item as? NSURL)
        }
    }
    
    func handleUrlData(_ url: NSURL?) -> Void {
        if (url != nil) {
            print("handling url data", url as Any)
            if url?.isFileURL ?? false {
                do {
                    self.uriString = url?.absoluteString ?? ""
                    self.typeString = self.getMimeType(url)
                    print(self.typeString as Any)
                }
            } else {
                self.textString = url?.absoluteString ?? ""
            }
        }
    }
    
    func handleTextData(_ text: NSString?) -> Void {
        if (text != nil) {
            print("handling text data", text as Any)
            self.textString = text as String? ?? ""
        }
    }
    
    func getMimeType(_ url: NSURL?) -> String {
        if (url == nil) {
            return ""
        }
        let pathExtension = url?.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }

}
