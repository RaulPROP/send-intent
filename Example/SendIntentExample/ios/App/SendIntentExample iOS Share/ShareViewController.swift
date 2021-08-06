import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    private var uriString: String?
    private var textString: String?
    private var typeString: String?

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        print(contentText ?? "content is empty")
        return true
    }

    override func didSelectPost() {
        var urlString = "SendIntentExample://?text=" + (self.textString ?? "");
        urlString = urlString + "&type=" + (self.typeString ?? "");
        urlString = urlString + "&uri=" + (self.uriString ?? "");
        let url = URL(string: urlString)!
        let _ = openURL(url)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        
        self.typeString = contentType
        
        for provider in attachments {
            // Check if the content type is the same as we expected
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType,
                                options: nil) { [unowned self] (data, error) in
                // Handle the error here if you want
                guard error == nil else { return }
                   
                    let url = data as! URL?
                    self.uriString = url?.absoluteString ?? ""
                    
                    let text = data as! String?
                    self.textString = text ?? ""
                }
                
            }
        }

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

}
