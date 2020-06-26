//
//  DetailVM.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/27/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DetailVMInput {
    func setData(itemList: [ListTableVCellDPModel], selectedIdx: Int)
}
protocol DetailVMOutput {
    var itemList: BehaviorRelay<[ListTableVCellDPModel]> { get }
    var selectedIdx: BehaviorRelay<Int?> { get }
}
final class DetailVM: DetailVMInput, DetailVMOutput{
    
    public var input: DetailVMInput{
        get {
            return self
        }
    }
    public var output: DetailVMOutput{
        get {
            return self
        }
    }
    
    private let disposeBag = DisposeBag()
    
    
    
    // MARK: - output
    var itemList = BehaviorRelay<[ListTableVCellDPModel]>(value: [ListTableVCellDPModel]())
    var selectedIdx = BehaviorRelay<Int?>(value: nil)
    
    // MARK: - input
    func setData(itemList: [ListTableVCellDPModel], selectedIdx: Int){
        
        self.itemList.accept(itemList)
        
        DispatchQueue.global()
            .asyncAfter(deadline: DispatchTime.now() + 1,
                        execute: { [weak self] in
            
                            guard let self = self else{
                                return
                            }
                            self.selectedIdx.accept(selectedIdx)
        })
    }
}
