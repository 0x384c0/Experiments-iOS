import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    // MARK: RX
    let disposeBag = DisposeBag()
    
    // MARK: UI
    var pageViewController: UIPageViewController!
    var pageViewDataSource = MainPageViewDataSource()
    
    var viewModel = MainViewModel()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        BindData()
        viewModel.loadTabs()
    }
    
    fileprivate func createPageViewController() {
        pageViewDataSource.setParentViewController(self)
        
        pageViewController = self.storyboard!.instantiateViewController(withIdentifier: "PageControllerMain") as? UIPageViewController
        pageViewController.dataSource = pageViewDataSource
        pageViewController.delegate = pageViewDataSource
        //Add page view on screen
        addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    // MARK: Binding
    func BindData(){
        viewModel
            .tabsBinding
            .subscribe(onNext: { tabs in
                self.loadDataInTabController(tabs)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Func
    fileprivate func loadDataInTabController(_ tabs:[MainTab]){
        
        pageViewDataSource.setTabs(tabs)
        if tabs.count > 0 {
            let firstController = pageViewDataSource.getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageViewController.setViewControllers (
                startingViewControllers as? [UIViewController],
                direction: UIPageViewController.NavigationDirection.forward,
                animated: false,
                completion: nil
            )
        }
    }
    
}
