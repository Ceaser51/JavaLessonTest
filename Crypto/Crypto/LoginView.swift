import SwiftUI
import Combine


struct ServerMessage: Decodable {
    let status, message: String
}

class HttpAuth: ObservableObject {
    
    var didChange = PassthroughSubject<HttpAuth, Never>()
    
    var authenticated = false {
        didSet