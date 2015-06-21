import UIKit

class ChatViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var chatView: UITableView!
    @IBOutlet var textField: UITextField!
    
    var chat: Chat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chat = Chat(socketURL: "localhost:3000", delegate: self)
        chat.connect()
        let nibName = UINib(nibName: "MyChatCell", bundle:nil)
        self.chatView.registerNib(nibName, forCellReuseIdentifier: "chatCell")
        
        chatView.dataSource = self
        chatView.delegate = self
        
        textField.delegate = self
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        chat.sendMessage(textField.text!)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.chatItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = chat.chatItems[indexPath.item]
        switch message.type {
        case .CHAT_MESSAGE: return renderChatMessage(message, indexPath:indexPath)
        case .MOODY_MESSAGE: return renderMoodyMessage(message,indexPath:indexPath)
        }
    }
    
    private func renderChatMessage(message: Message, indexPath: NSIndexPath) -> UITableViewCell {
        var cell = chatView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as! MyChatCell
        cell.label.text = chat.chatItems[indexPath.item].text
        return cell
    }
    
    private func renderMoodyMessage(message: Message, indexPath: NSIndexPath) -> UITableViewCell {
        var cell = chatView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = chat.chatItems[indexPath.item].text
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        chat.sendMessage(textField.text!)
        
        return true
    }
}

extension ChatViewController: ChatProtocol {
    func onReceiveMessage(message: Message) {
        self.chatView.reloadData()
        self.textField.text = ""
    }
}
