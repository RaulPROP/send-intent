import Foundation

public final class ShareStore {

    public static let store = ShareStore()
    private init() {
        self.text = ""
        self.uri = ""
        self.type = ""
        self.processed = false
    }

    public var text: String;
    public var uri: String;
    public var type: String;
    public var processed: Bool;
}
