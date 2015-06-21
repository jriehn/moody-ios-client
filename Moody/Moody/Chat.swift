import Foundation
import Socket_IO_Client_Swift

public protocol ChatProtocol {
    func onReceiveMessage(message: String)
}

public class Chat {
    let socket : SocketIOClient
    var chatItems: [String] = []
    let delegate: ChatProtocol

    public init(socketURL: String, delegate: ChatProtocol) {
        self.socket = SocketIOClient(socketURL: socketURL)
        self.delegate = delegate
        
        addHandlers()
    }
    
    func addHandlers() {
        socket.on("chat message") {[weak self] data, ack in
            var message = data!.firstObject! as! String
            self!.chatItems.append(message)
            self!.delegate.onReceiveMessage(message)
            return
        }
    }
    
    public func connect() {
        socket.connect()
    }
    
    public func sendMessage(message: String) {
        self.socket.emit("chat message", message)
    }
}