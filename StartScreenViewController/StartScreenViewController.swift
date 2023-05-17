import Cocoa

class StartScreenViewController: NSViewController {

    @IBOutlet weak var nameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startAction(_ sender: NSButton) {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: EditingScreenViewController.self)
        
        self.view.window?.contentViewController = storyBoard.instantiateController(withIdentifier: identifier) as? NSViewController
        
    }
}

