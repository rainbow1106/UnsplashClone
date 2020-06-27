//
//  ListVM.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ListVMInput {
    func initializeData(completion: @escaping () -> Void)
    func moreData(completion: @escaping () -> Void)
    func searchKeyword(keyword: String, completion: @escaping () -> Void)
    func checkMoreAvailable() -> Bool
    func refreshData(completion: @escaping () -> Void)
}
protocol ListVMOutput {
    var itemList: BehaviorRelay<[ListTableVCellDPModel]> { get }
    var error: BehaviorRelay<Error?> { get }
    var randomItemList: BehaviorRelay<[ListTableVCellDPModel]> { get }
}
final class ListVM: ListVMInput, ListVMOutput{
    
    public var input: ListVMInput{
        get{
            return self
        }
    }
    public var output: ListVMOutput{
        get{
            return self
        }
    }
    
    // MARK: - local variables
    private let disposeBag = DisposeBag()
    private let worker = ListApiWorker()
    private var page: Int = 1
    private let pageSize: Int = 20
    
    private var originalDataList = [ListTableVCellDPModel]()
    private var isMoreAvailable = true
    private var isSearchMode = false
    private var searchedKeyword = ""
    
    // MARK: - output
    var itemList = BehaviorRelay<[ListTableVCellDPModel]>(value: [ListTableVCellDPModel]())
    var error = BehaviorRelay<Error?>(value: nil)
    var randomItemList = BehaviorRelay<[ListTableVCellDPModel]>(value: [ListTableVCellDPModel]())
    
    // MARK: - input
    func refreshData(completion: @escaping () -> Void){
        
        self.resetPage()
        
        self.isSearchMode = false
        
        self.worker.photoList(page: self.page, pageSize: self.pageSize)
            .subscribe(onNext: { [weak self](rData) in
                
                guard let self = self else{
                    return
                }
                self.parseListData(pData: rData)
                self.page += 1
                
                },
                       onError: { [weak self](rError) in
                        
                        guard let self = self else{
                            return
                        }
                        self.error.accept(rError)
                        
                },
                       onDisposed: completion)
            .disposed(by: self.disposeBag)
    }
    func checkMoreAvailable() -> Bool{
        return self.isMoreAvailable
    }
    func searchKeyword(keyword: String, completion: @escaping () -> Void){
        
        self.resetPage()
        
        self.searchedKeyword = keyword
        self.isSearchMode = true
        
        self.worker
            .searchKeyword(keyword: keyword,
                           page: self.page,
                           pageSize: self.pageSize)
            .subscribe(onNext: { [weak self](rSearchResultData) in
                
                guard let self = self else{
                    return
                }
                self.isMoreAvailable = true
                if let totalPages = rSearchResultData.totalPages{
                    if self.page == totalPages{
                        self.isMoreAvailable = false
                    }
                    
                }
                self.page += 1
                
                guard let list = rSearchResultData.results else{
                    return
                }
                self.parseListData(pData: list)
                
                
            },
                       onError: { [weak self](rError) in
                        
                        guard let self = self else{
                            return
                        }
                        self.error.accept(rError)
                        
                },
                       onDisposed: completion)
            .disposed(by: self.disposeBag)
    }
    func moreData(completion: @escaping () -> Void){
        
        if self.isSearchMode == true {
            
            self.worker.searchKeyword(keyword: self.searchedKeyword,
                                      page: self.page,
                                      pageSize: self.pageSize)
                .subscribe(onNext: { [weak self](rSData) in
                    
                    guard let self = self else{
                        return
                    }
                    
                    self.isMoreAvailable = true
                    if let totalPages = rSData.totalPages{
                        if self.page == totalPages{
                            self.isMoreAvailable = false
                        }
                        
                    }
                    self.page += 1
                    
                    guard let list = rSData.results else{
                        return
                    }
                    self.parseListData(pData: list)
                    
                },
                           onError: { [weak self](rError) in
                            
                            guard let self = self else{
                                return
                            }
                            self.error.accept(rError)
                },
                           onDisposed: completion)
                .disposed(by: self.disposeBag)
            
        }else{
            
            self.worker
                .photoList(page: self.page, pageSize: self.pageSize)
                .subscribe(onNext: { [weak self](rList) in
                    
                    guard let self = self else{
                        return
                    }
                    self.parseListData(pData: rList)
                    self.page += 1
                    
                    },
                           onError: { [weak self](rError) in
                            
                            guard let self = self else{
                                return
                            }
                            self.error.accept(rError)
                            
                    },
                           onDisposed: completion)
                .disposed(by: self.disposeBag)
        }
        
    }
    func initializeData(completion: @escaping () -> Void){
        
        self.resetPage()
        
        let list = self.worker.photoList(page: self.page, pageSize: self.pageSize)
        let random = self.worker.randomPhoto()
        
        Observable
            .zip(list, random)
            .subscribe(onNext: { [weak self](arg) in
                
                guard let self = self else{
                    return
                }
                
                let rList = arg.0

                self.parseListData(pData: rList)
                
                let randomImgList = arg.1
                self.parseRandomData(pData: randomImgList)
                
                self.page += 1
                
                },
                       onError: { [weak self](rError) in
                        
                        guard let self = self else{
                            return
                        }
                        self.error.accept(rError)
                        
                },
                       onDisposed: completion)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - private
    private func parseRandomData(pData: [PhotoListItemData]){
        
        let parsedList = pData.compactMap { (origin) -> ListTableVCellDPModel? in
            
            var rData = ListTableVCellDPModel()
            guard let itemId = origin.id else{
                return nil
            }
            rData.id = itemId
            
            if let uColorCode = origin.color{
                
                let newColorCode = String(uColorCode.dropFirst())
                rData.color = UIColorFromRGB(newColorCode)
                
            }
            
            if let uHeight = origin.height{
                rData.height = uHeight
            }
            if let uWidth = origin.width{
                rData.width = uWidth
            }
            rData.imgUrl_original = origin.urls?.full
            rData.imgUrl_thumb = origin.urls?.thumb
            
            rData.name = origin.user?.username
            
            return rData
            
        }
        
        self.randomItemList.accept(parsedList)
    }
    private func parseListData(pData: [PhotoListItemData]){

        let parsedList = pData.compactMap { (origin) -> ListTableVCellDPModel? in
            
            var rData = ListTableVCellDPModel()
            guard let itemId = origin.id else{
                return nil
            }
            rData.id = itemId
            
            if let uColorCode = origin.color{
                
                let newColorCode = String(uColorCode.dropFirst())
                rData.color = UIColorFromRGB(newColorCode)
                
            }
            
            if let uHeight = origin.height{
                rData.height = uHeight
            }
            if let uWidth = origin.width{
                rData.width = uWidth
            }
            rData.imgUrl_original = origin.urls?.full
            rData.imgUrl_thumb = origin.urls?.thumb
            
            rData.name = origin.user?.username
            
            return rData
            
        }
        
        self.originalDataList.append(contentsOf: parsedList)
        self.itemList.accept(self.originalDataList)
        
    }
    private func resetPage(){
        
        self.page = 1
        self.originalDataList.removeAll()
        self.searchedKeyword = ""
        self.isMoreAvailable = true
        
    }
}
