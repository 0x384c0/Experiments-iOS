//
//  VCWithInfinityScroll.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 23.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//
import RxSwift

protocol VCWithInfinityScroll:class {
    weak var tableView: UITableView!{get set}
    func getViewModel() -> VMWithInfinityScroll
}
extension VCWithInfinityScroll where Self:BaseViewController{
    func VCWithInfinityScrollBind(){
        getViewModel()
            .infinityScrollDisabledBinding
            .subscribeMain(onNext: { [weak self] data in
                self?.disableInfinityScroll()
            })
            .addDisposableTo(disposeBag)
    }
    func viewControllerWasRefreshed(){
        if getViewModel().PAGINATION_ENABLED {
            tableView.infiniteScrollIndicatorStyle = .white
            print("addInfiniteScroll")
            tableView.addInfiniteScroll{[weak self] _ in
                self?.getViewModel().loadMore()
            }
        }
    }
    func dataWasLoaded(){
        print("finishInfiniteScroll")
        tableView.finishInfiniteScroll()
    }
    func disableInfinityScroll(){
        print("removeInfiniteScroll")
        tableView.removeInfiniteScroll()
    }
}
protocol VMWithInfinityScroll:class{
    var PAGINATION_ENABLED:Bool{get}
    func loadMore()
    var infinityScrollDisabledBinding:PublishSubject<Void>{ get }
    var page:Int{get set}
}
extension VMWithInfinityScroll{
    func dataWasReloaded(){
        page = Constants.FIRST_PAGE
    }
    func dataWasStartedLoad(){
        page += 1
    }
    func lastPageWasLoaded(){
        infinityScrollDisabledBinding.value = Void()
    }
}
