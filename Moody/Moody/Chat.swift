import Foundation
import Socket_IO_Client_Swift

public protocol ChatProtocol {
    func onReceiveMessage(message: Message)
}

public class Chat {
    let socket : SocketIOClient
    var chatItems: [Message] = []
    let delegate: ChatProtocol

    public init(socketURL: String, delegate: ChatProtocol) {
        self.socket = SocketIOClient(socketURL: socketURL)
        self.delegate = delegate
        
        addHandlers()
    }
    
    func addHandlers() {
        socket.on(MessageType.CHAT_MESSAGE.rawValue) {[weak self] data, ack in
            var chat = data!.firstObject! as! [String: AnyObject]
            
            var stringMessage = chat["message"] as! String
            var type = MessageType(rawValue: chat["type"] as! String)!
            
            var message = Message(text: stringMessage, type: type)
            
            self!.chatItems.append(message)
            self!.delegate.onReceiveMessage(message)
            return
        }
    }
    
    public func connect() {
        socket.connect()
    }
    
    public func sendMessage(message: String) {
        self.socket.emit("CHAT", message)
    }
}