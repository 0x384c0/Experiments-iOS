import UIKit
import Alamofire

class WebViewScreenController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBAction func onClick(_ sender: AnyObject) {
        webView.goBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let request = Alamofire.request("http://www.google.com", method: .get).request
        webView.loadRequest(request!)
    }
}
