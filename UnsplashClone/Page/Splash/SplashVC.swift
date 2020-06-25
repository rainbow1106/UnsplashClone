//
//  SplashVC.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit

class SplashVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appInit()
        
    }
    

    
    private func appInit(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            NaviManager.shared.initMainVC()
        })
    }
}
