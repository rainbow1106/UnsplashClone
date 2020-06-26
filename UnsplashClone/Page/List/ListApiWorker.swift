//
//  ListApiWorker.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift


final class ListApiWorker{
    
    public func randomPhoto() -> Observable<[PhotoListItemData]>{
        
        guard let reqURL = ApiUtils.makeUrl("photos/random?count=5") else{
            return .error(RxError.unknown)
        }
        let reqHeader = ApiUtils.makeHeader()
        
        return RxAlamofire
            .requestData(.get, reqURL, parameters: nil, encoding: JSONEncoding.default, headers: reqHeader)
            .flatMap { (arg) -> Observable<[PhotoListItemData]> in
                
                var rawData: PhotoListRawData?
                do{
                    rawData = try PhotoListRawData(data: arg.1)
                }catch(let rError){
                    return .error(rError)
                }
                
                var list = [PhotoListItemData]()
                if let uList = rawData{
                    list = uList
                }
                return .just(list)
        }
    }
    public func photoList(page: Int,
                          pageSize: Int) -> Observable<[PhotoListItemData]>{
        
        guard let reqURL = ApiUtils.makeUrl("photos?page=\(page)&&per_page=\(pageSize)") else{
            return .error(RxError.unknown)
        }
        let reqHeader = ApiUtils.makeHeader()
        
        return RxAlamofire
            .requestData(.get, reqURL,
                         parameters: nil,
                         encoding: JSONEncoding.default,
                         headers: reqHeader)
            .flatMap { (arg) -> Observable<[PhotoListItemData]> in
                
                var rawData: PhotoListRawData?
                do{
                    rawData = try PhotoListRawData(data: arg.1)
                }catch(let rError){
                    return .error(rError)
                }
                
                var list = [PhotoListItemData]()
                if let uList = rawData{
                    list = uList
                }
                return .just(list)
        }
    }
    
    
    
}
