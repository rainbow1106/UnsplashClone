//
//  ListVC.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ListVC: BaseVC {

    // ibs
    
    // MARK: - local variables
    
    // MARK: - init
    convenience init(){
        self.init(nibName: "ListVC", bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingSubviews()
        
    }


    // MARK: - view setting
    private func settingSubviews(){
        
        self.naviBarHidden = true
        self.naviLineHidden = true
        
        
    }

}
