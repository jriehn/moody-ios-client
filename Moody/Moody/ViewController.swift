import UIKit
import Socket_IO_Client_Swift

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var chatView: UITableView!
    @IBOutlet var textField: UITextField!
    
    let socket = SocketIOClient(socketURL: "localhost:3000")
    var chatItems: [String] = []
    
    func addHandlers() {
        self.socket.on("chat message") {[weak self] data, ack in
            self!.chatItems.append(data!.firstObject! as! String)
            self!.chatView.reloadData()
            self!.textField.text = ""
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        socket.connect()
        
        chatView.dataSource = self
        chatView.delegate = self
        
        textField.delegate = self
    }
    
    @IBAction func onSubmit(sender: AnyObject) {
        self.socket.emit("chat message", self.textField.text)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = chatItems[indexPath.item]
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.socket.emit("chat message", self.textField.text)
        
        return true
    }
}
