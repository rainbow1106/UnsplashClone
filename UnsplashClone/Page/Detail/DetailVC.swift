//
//  DetailVC.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/27/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct DetailVCUserinfo {
    
    var dataList = [ListTableVCellDPModel]()
    var selectedIdx: Int = 0
    
    var closeClosure: ((Int) -> Void)?
    
}
final class DetailVC: BaseVC {

    var userinfo: DetailVCUserinfo?
    
    // IBS
    @IBOutlet weak var colV: UICollectionView!
    @IBOutlet weak var closeBTN: UIButton!
    @IBOutlet weak var pageLB: UILabel!
    
    // MARK: - local variables
    private let vm = DetailVM()
    private var page: Int = 0
    
    // MARK: - init
    convenience init(){
        self.init(nibName: "DetailVC", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    deinit {
        print(self.description)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingSubviews()
        self.bindEvents()
        self.bindDatas()
    }

    // MARK: - view setting
    private func settingSubviews(){
        self.view.do {
            $0.backgroundColor = .black
        }
        self.colV.do{
            $0.backgroundColor = .black
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            $0.collectionViewLayout = layout
            
            $0.isPagingEnabled = true
            
            $0.rx.setDelegate(self).disposed(by: self.disposeBag)
            
            $0.register(UINib(nibName: "DetailColVCell", bundle: nil),
                        forCellWithReuseIdentifier: DetailColVCell.description())
            
        }
        self.pageLB.do{
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = UIColor.white
            $0.textAlignment = .center
        }
    }

    private func bindEvents(){
        
        self.closeBTN
            .rx
            .tap
            .asDriver()
            .throttle(RxTimeInterval.seconds(1))
            .drive(onNext: { [weak self](_) in
            
                guard let self = self else{
                    return
                }
                
                self.dismiss(animated: true, completion: {
                    
                    self.userinfo?.closeClosure?(self.page)
                    
                })
                
        })
            .disposed(by: self.disposeBag)
        
        
        self.colV
            .rx
            .contentOffset
            .asDriver()
            .map { [weak self](offset) -> Int in
                
                guard let self = self else{
                    return 0
                }
                
                let mainWidth = UIScreen.main.bounds.width
                let idx = Int(offset.x / mainWidth)
                self.page = idx
                
                return idx
                
        }
        .map { [weak self](page) -> String in
            
            guard let self = self else{
                return ""
            }
            return "\(page + 1) / \(self.vm.itemList.value.count)"
        }
        .drive(self.pageLB.rx.text)
        .disposed(by: self.disposeBag)
    }
    
    private func bindDatas(){
        
        let output = self.vm.output
        
        output
            .itemList
            .asDriver()
            .drive(self.colV
                .rx
                .items(cellIdentifier: DetailColVCell.description(),
                       cellType: DetailColVCell.self)) { (idx, cellData, cell) in
            
            cell.mapCellData(cellData: cellData)
            
        }
        .disposed(by: self.disposeBag)
        
        output
            .selectedIdx
            .compactMap {
                $0
        }
        .filter { [weak self] (idx) -> Bool in
            
            guard let self = self else{
                return false
            }
            return idx < self.vm.output.itemList.value.count
        }
        .asDriver(onErrorJustReturn: 0)
        .drive(onNext: { [weak self](idx) in
            
            guard let self = self else{
                return
            }
            self.colV
                .scrollToItem(at: IndexPath(row: idx, section: 0),
                              at: UICollectionView.ScrollPosition.centeredHorizontally,
                              animated: false)
        })
            .disposed(by: self.disposeBag)
        
        
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
        self.isFirst = false
        
        guard let uUserinfo = self.userinfo else{
            return
        }
        
        self.vm.input
            .setData(itemList: uUserinfo.dataList,
                     selectedIdx: uUserinfo.selectedIdx)
        
    }
}

extension DetailVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let mainSize = UIScreen.main.bounds.size
        
        return mainSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

