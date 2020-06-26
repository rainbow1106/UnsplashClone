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
}
protocol ListVMOutput {
    var itemList: BehaviorRelay<[String]> { get }
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
    
    // MARK: - output
    var itemList = BehaviorRelay<[String]>(value: [String]())
    
    // MARK: - input
    func initializeData(completion: @escaping () -> Void){
        
        var list = [String]()
        for i in 0 ..< 30{
            list.append(String(i))
        }
        self.itemList.accept(list)
        completion()
    }
    
}
