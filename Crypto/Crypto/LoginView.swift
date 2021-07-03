import SwiftUI
import Combine


struct ServerMessage: Decodable {
    let status, message: String
}

class HttpAuth: ObservableObject 