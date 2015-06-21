import Foundation

public enum MessageType: String {
    case CHAT_MESSAGE = "CHAT"
    case MOODY_MESSAGE = "MOODY"
}

public struct Message {
    let text: String
    let type: MessageType
}