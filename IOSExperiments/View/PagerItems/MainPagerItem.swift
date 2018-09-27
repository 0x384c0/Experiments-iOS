import UIKit

import RxSwift
import RxBlocking
import RxCocoa

class MainPagerItem: UIViewController {

    // MARK: - ViewModel
    var itemIndex: Int = 0
    var mainTab: MainTab = MainTab()

    // MARK: RX
    let disposeBag = DisposeBag()

    // MARK: - UI
    var tableController = MainTableController()

    @IBOutlet weak var ScreensTableView: UITableView!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableVIew()
    }

    func setupTableVIew() {
        print(#function)
        _ = tableController.setItems(mainTab.screens)
        ScreensTableView.delegate = tableController
        ScreensTableView.dataSource = tableController
        ScreensTableView.rowHeight = UITableViewAutomaticDimension;
        ScreensTableView.estimatedRowHeight = 67; // set to whatever your "average" cell height is
        ScreensTableView.tableFooterView = UIView(frame: CGRect.zero)
        ScreensTableView
        .rx.itemSelected
        .subscribe(onNext:  { indexPath in
            print((indexPath as NSIndexPath).item)
            if let screenId = self.mainTab.screens[(indexPath as NSIndexPath).item].screenId {
                print(screenId)
                if let screenController = self.storyboard?.instantiateViewController(withIdentifier: screenId){
                    self.navigationController?.pushViewController(screenController, animated: true)
                }
            }
        })
        .addDisposableTo(disposeBag)
    }
}
