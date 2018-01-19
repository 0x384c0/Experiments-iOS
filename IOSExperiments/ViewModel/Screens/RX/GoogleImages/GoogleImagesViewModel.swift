//
//  GoogleImagesViewModel.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/11/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import RxSwift

class GoogleImagesViewModel : BaseViewModel,VMWithInfinityScroll  {
    //VMWithInfinityScroll
    var
    infinityScrollDisabledBinding = PublishSubject<Void>(),
    page = Constants.FIRST_PAGE,
    PAGINATION_ENABLED = true
    
    //MARK: UI Binding
    var
    dataBinding = Variable<[Item]>([])
    
    
    //MARK: Data fetching
    var useStubApi = Constants.USE_STUB_API
    private let
    _apiServiceStub = GoogleServiceStub(),
    _apiService = GoogleService()
    private var apiService:GoogleServiceProtocol { return useStubApi ? _apiServiceStub: _apiService }
    func loadData(searchText:String?){
        dataWasReloaded()
        data = [Item]()
        self.searchText = searchText ?? Constants.SEARCH_DEFAULT
        _loadData()
    }
    
    func loadMore(){
        _loadData()
    }
    
    private var
    data = [Item](),
    searchText = Constants.SEARCH_DEFAULT
    private func _loadData(){
        apiService
            .searchImages(query: searchText, page: page)
            .subscribeOn(scheduler)
            .subscribe(
                onNext: {[weak self] data in
                    self?.setData(data.items ?? [])
                },
                onError: getOnErrorObserver()
            )
            .addDisposableTo(disposeBag)
        dataWasStartedLoad()
    }
    func setData(_ data:[Item]){
        self.data.append(contentsOf: data)
        dataBinding.value = self.data
    }
}
