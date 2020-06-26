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
    @IBOutlet weak var topV: UIView!
    @IBOutlet weak var topImgV: UIImageView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchCont: UIView!
    @IBOutlet weak var searchBTN: UIButton!
    
    @IBOutlet weak var topVHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableV: UITableView!
    
    // MARK: - local variables
    private var topVHeight: CGFloat = 0
    private let vm = ListVM()
    
    
    
    // MARK: - init
    convenience init(){
        self.init(nibName: "ListVC", bundle: nil)
    }
    deinit {
        print(self.description)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingSubviews()
        self.initVState()
        self.bindUIEvents()
        self.bindDatas()
    }


    // MARK: - view setting
    private func settingSubviews(){
        
        self.naviBarHidden = true
        self.naviLineHidden = true
        
        self.topImgV.do{
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = UIColor.psRandom
        }
        self.searchTF.do{
            $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            $0.textColor = UIColorFromRGB("2d2d2d")
            $0.textAlignment = .left
            
            $0.keyboardType = .default
            
            $0.clearButtonMode = .always
            
            $0.clipsToBounds = true
            $0.layer.cornerRadius = $0.frame.height / 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColorFromRGB("dcdcdc").cgColor
            $0.backgroundColor = UIColor.white
            
            let leftV = UIView()
            leftV.do{
                var frm = CGRect.zero
                frm.size = CGSize(width: 10, height: 1)
                $0.frame = frm
                
                self.searchTF.leftView = $0
            }
            $0.leftViewMode = .always
            
            
        }
        self.searchCont.do{
            $0.backgroundColor = .clear
        }
        self.searchBTN.do{
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            $0.setTitleColor(UIColor.blue, for: .normal)
            
            $0.clipsToBounds = true
            $0.layer.cornerRadius = $0.frame.height / 4
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColorFromRGB("dcdcdc").cgColor
            $0.backgroundColor = UIColor.white
        }
        
        self.tableV.do{
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            
            $0.allowsSelection = true
            $0.allowsMultipleSelection = false
            
            $0.separatorStyle = .none
            
            $0.rx.setDelegate(self).disposed(by: self.disposeBag)
            
            $0.register(UINib(nibName: "ListTableVCell", bundle: nil),
                        forCellReuseIdentifier: ListTableVCell.description())
        }
        
    }
    private func initVState(){
        
        // topV height
        let mainWidth = UIScreen.main.bounds.width
        let lTopVHeight = mainWidth / 4 * 3
        self.topVHeightConstraint.constant = lTopVHeight
        self.topVHeight = lTopVHeight
        
        self.topImgV.alpha = 1
        
    }

    private func bindUIEvents(){
        
        self.tableV
            .rx
            .contentOffset
            .map { [weak self](origin) -> CGFloat in
                
                guard let self = self else{
                    return 0
                }
                
                let offsetY = origin.y
                
                var result: CGFloat = self.topVHeight - (offsetY / 3)
                
                var minHeight: CGFloat = self.searchCont.frame.height
                if let uSafeTop = UIApplication.shared.windows.first?.safeAreaInsets.top {
                    minHeight += uSafeTop
                }
                if result < minHeight {
                    result = minHeight
                }
                return result
                
        }
        .bind(to: self.topVHeightConstraint.rx.constant)
        .disposed(by: self.disposeBag)
     
        self.topVHeightConstraint
            .rx
            .observe(CGFloat.self, "constant")
            .asDriver(onErrorJustReturn: nil)
            .compactMap {
                $0
        }
        .map { [weak self](tHeight) -> CGFloat in
            
            guard let self = self else{
                return 1
            }
            var minHeight: CGFloat = self.searchCont.frame.height
            if let uSafeTop = UIApplication.shared.windows.first?.safeAreaInsets.top {
                minHeight += uSafeTop
            }
            
            let standardHeight = self.topVHeight - minHeight
            let result = (tHeight - minHeight) / standardHeight
            
            return result
            
        }
        .drive(self.topImgV.rx.alpha)
        .disposed(by: self.disposeBag)
        
        
        //
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.endKeyboard))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
     
        //
        self.tableV
            .rx
            .willDisplayCell
            .asDriver()
            .filter { [weak self] (arg) -> Bool in
                
                guard let self = self else{
                    return false
                }
                let lastIdx = self.vm.output.itemList.value.count - 1
                
                guard lastIdx > 0 else{
                    return false
                }
                
                return arg.indexPath.row == lastIdx
                
        }
        .drive(onNext: { [weak self](_) in
            
            guard let self = self else{
                return
            }
            
            CommonVManager.showLoadingV()
            self.vm
                .input
                .moreData(completion: CommonVManager.hideLoadingV)
            
        })
            .disposed(by: self.disposeBag)
        
        self.tableV
            .rx
            .itemSelected
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .drive(onNext: { [weak self](idx) in
                
                guard let self = self else{
                    return
                }
                
                var userinfo = DetailVCUserinfo()
                userinfo.selectedIdx = idx.row
                userinfo.dataList = self.vm.output.itemList.value
                userinfo.closeClosure = { (selectedIdx) in
                    
                    guard selectedIdx < self.vm.output.itemList.value.count else{
                        return
                    }
                    self.tableV
                        .scrollToRow(at: IndexPath(row: selectedIdx, section: 0),
                                     at: UITableView.ScrollPosition.middle,
                                     animated: true)
                    
                }
                
                NaviManager.shared.detailVC(userinfo: userinfo)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindDatas(){
        
        let output = self.vm.output
        
        output
            .error
            .asDriver()
            .compactMap {
            $0
        }
        .drive(onNext: CommonVManager.showErrorMsg(error:))
        .disposed(by: self.disposeBag)
        
        output
            .itemList
            .asDriver()
            .drive(self.tableV
                .rx
                .items(cellIdentifier: ListTableVCell.description(),
                       cellType: ListTableVCell.self)) { (idx, cellData, cell) in
                        
                        cell.mapCellData(cellData: cellData)
                        
        }
        .disposed(by: self.disposeBag)
            
        
        output
            .randomItemList
            .asDriver()
            .compactMap {
                $0.first
        }
        .drive(onNext: { [weak self](origin) in
            
            guard let self = self else{
                return
            }
            guard let uImg = origin.imgUrl_thumb,
                let uUrl = URL(string: uImg) else{
                    return
            }
            self.topImgV.backgroundColor = origin.color
            self.topImgV.kf.setImage(with: uUrl)
            
        })
            .disposed(by: self.disposeBag)
//        output
//            .itemList
//            .bind(to: self.tableV.rx
//                .items(cellIdentifier: ListTableVCell.description(),
//                       cellType: ListTableVCell.self)) {
//                        (idx, cellData, cell) in
//
//                        cell.nameLB.text = cellData
//        }
//        .disposed(by: self.disposeBag)
        
        
    }
    // MARK: - view cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initializeData()
    }
    
    // MARK: - private
    private var isFirst = true
    private func initializeData(){

        guard self.isFirst == true else{
            return
        }
        
        CommonVManager.showLoadingV()
        self.vm.input
            .initializeData(completion: CommonVManager.hideLoadingV)
        
    }
    
    @objc private func endKeyboard(){
        self.view.endEditing(true)
    }
}


extension ListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

