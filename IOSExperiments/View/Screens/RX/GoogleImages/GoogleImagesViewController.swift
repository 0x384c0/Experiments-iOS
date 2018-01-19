//
//  GoogleImagesViewController.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 11/13/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import RxSwift
import RxBlocking
import RxCocoa

//TODO: unwind segue
class GoogleImagesViewController: BaseViewController ,VCWithRefreshControlInTable,VCWithInfinityScroll,VCWithKeyboardProtocol{

    // MARK: UI
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stubSwitch: UISwitch!
    @IBOutlet weak var bottomTextField: UITextFieldWithColoredPlaceholder!
    weak var scrollView: UIScrollView! { return tableView }
    let
    tableDelegate = GoogleImagesTableDelegate(),
    textFieldDelegate = UITextFieldDelegateHidingKeyboard()
    //VCWithRefreshControl
    var refreshControl:UIRefreshControl?
    //VCWithKeyboardProtocol
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    func getTextFileds() -> [UITextField]?{
        return [bottomTextField,searchBar.textField!]
    }
    
    // MARK: UI Actions
    func refreshControlDidSwipe(){
        RefreshViewController()
    }
    @IBAction func stubSwitched(_ sender: UISwitch) {
        viewModel.useStubApi = sender.isOn
    }
    //MARK: LifeCycle
    override func SetupViewController(){
        tableView.estimatedRowHeight = ImageTableCell.estimatedHeigh
        tableView.rowHeight = UITableViewAutomaticDimension
        //CustomSectionView.addSelf(to: tableView)
        
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
        vcWithRefreshControlInTableSetup()
        vcWithKeyboardProtocolSetup()
        stubSwitch.setOn(viewModel.useStubApi, animated: false)
        searchBar.text = Constants.SEARCH_DEFAULT
        
        bottomTextField.delegate = textFieldDelegate
    }
    override func RefreshViewController() {
        if searchBar.text?.isBlank ?? true { return }
        showLoading()
        viewModel.loadData(searchText:searchBar.text)
        viewControllerWasRefreshed()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case DetailViewController.segueID:
            let
            vc = segue.destination as! DetailViewController,
            data = sender as! ImageTableCell
            vc.setup(data.item!)
        default:
            printUndefinedSegue(segue)
        }
    }
    
    
    // MARK: Binding
    let viewModel = GoogleImagesViewModel()
    internal func getViewModel() -> VMWithInfinityScroll { return viewModel }
    override func BindData() {
        bindAlerts(from: viewModel)
        searchBar
            .rx.text
            .skip(1)
            .debounce(1, scheduler: MainScheduler.instance)
            .subscribe(onNext:  { [weak self] _ in
                self?.RefreshViewController()
            })
            .addDisposableTo(disposeBag)
        searchBar
            .rx.searchButtonClicked
            .subscribe(onNext:  { [weak self] _ in
            self?.searchBar.resignFirstResponder()
        })
        .addDisposableTo(disposeBag)
        resetButton
            .rx.tap
            .debounce(1, scheduler: MainScheduler.instance)
            .subscribe(onNext:  {[weak self] in
                self?.RefreshViewController()
            })
            .addDisposableTo(disposeBag)
        viewModel
            .dataBinding
            .subscribeMain {[weak self] data in
                self?.load(data: data)
                self?.hideLoading()
            }
            .addDisposableTo(disposeBag)
        VCWithInfinityScrollBind()
    }
    
    //MARK: Others
    func load(data: [Item]?){
        tableDelegate.setData(data)
        tableView.reloadData()
        dataWasLoaded()
    }
}

