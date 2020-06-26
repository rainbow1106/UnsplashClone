//
//  BaseVC.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/25/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then

class BaseVC: UIViewController {

    let disposeBag = DisposeBag()
    
    var naviBarHidden = false
    var naviLineHidden = false
    var naviAnitype = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(self.naviBarHidden, animated: naviAnitype)
        self.navigationController?.navigationBar.setValue(self.naviLineHidden, forKey: "hidesShadow")
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
}
