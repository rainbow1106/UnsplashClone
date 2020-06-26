//
//  LibManager.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import Foundation
import DeallocationChecker
import RxSwift
import RxReachability
import Reachability

final class LibManager{
    static let shared = LibManager()
    
    private var reachability: Reachability?
    private let disposeBag = DisposeBag()
    
    public func settingThirdLib(){
        
        self.settingReachability()
        self.deallocationCheck()
        
    }
    
    
    private func settingReachability(){
        self.reachability = Reachability()
        do{
            try self.reachability?.startNotifier()
        }catch(let rError){
            print(rError.localizedDescription)
        }
        
        self.reachability?
        .rx
        .status
        .subscribe(onNext: { [weak self](rStatus) in

            guard let `self` = self else{
                return
            }
            
            print("reachability")
            guard rStatus == .none else{
                return
            }
            self.showNetworkErrorPopop()

        })
        .disposed(by: self.disposeBag)
    }
    private func deallocationCheck(){
        
        guard isDev == true else{
            return
        }
        #if DEBUG
        DeallocationChecker.shared.setup(with: .callback({ (state, vcType) in
            
            guard state == .leaked else{
                return
            }
            
            let alert = UIAlertController(title: "메모리누수",
                                          message: "\(vcType) is not deallocated",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction.init(title: "확인", style: .default, handler: nil))
            
            UIApplication.topViewController()?.present(alert, animated: false, completion: nil)
            
        }))
        #endif
    }
    
    private func showNetworkErrorPopop(){
        
        let alert = UIAlertController(title: "주의",
                                      message: "네트워크가 연결되어 있지 않습니다.\n네트워크 환경을 확인해주세요.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "확인", style: .default, handler: nil))
        
        UIApplication.topViewController()?.present(alert, animated: false, completion: nil)
    }
}
