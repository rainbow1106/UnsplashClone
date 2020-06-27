//
//  DetailColVCell.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/27/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

final class DetailColVCell: UICollectionViewCell {

    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var contentV: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var imgVHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLB: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingSubviews()
    }

    private func settingSubviews(){
        self.contentView.do {
            $0.backgroundColor = UIColor.black
        }
        
        self.imgV.do{
            $0.contentMode = .scaleAspectFill
        }
        
        self.nameLB.do{
            $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            $0.textColor = UIColor.white
            $0.textAlignment = .left
            $0.numberOfLines = 0
        }
    }
    
    private func resetData(){
        
        self.imgV.image = nil
        self.imgV.backgroundColor = .black
        
        self.imgVHeight.constant = 0
        
        self.nameLB.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgV.kf.cancelDownloadTask()
        self.disposeBag = DisposeBag()
    }
    
    public func mapCellData(cellData: ListTableVCellDPModel){
        
        self.resetData()
        
        if let uThumb = cellData.imgUrl_thumb,
            let url = URL(string: uThumb){
            
            self.imgV.kf.setImage(with: url)
            
        }
        if let uFull = cellData.imgUrl_original,
            let url = URL(string: uFull){
            
            self.fullImgWork(url: url)
            
        }
        self.imgV.backgroundColor = cellData.color
        
        self.nameLB.text = cellData.name
        
        self.imgVHeightwork(width: cellData.width, height: cellData.height)
        
    }
    
    private func imgVHeightwork(width: Int, height: Int){
        
        let mainWidth = UIScreen.main.bounds.width
        let newHeight = mainWidth * CGFloat(width) / CGFloat(height)
        
        self.imgVHeight.constant = newHeight
        self.layoutIfNeeded()
    }
    
    private func fullImgWork(url: URL){
        
        let global = ConcurrentDispatchQueueScheduler.init(qos: .background)
        
        self.loadFullImgObs(url: url)
            .subscribeOn(global)
            .asDriver(onErrorJustReturn: UIImage())
            .drive(self.imgV.rx.image)
            .disposed(by: self.disposeBag)
        
    }
    private func loadFullImgObs(url: URL) -> Observable<UIImage>{
        
        return Observable.create { (emitter) -> Disposable in
            
            KingfisherManager.shared
                .retrieveImage(with: url) { (rResult) in
                    switch rResult{
                    case .success(let rImgResult):
                        
                        emitter.onNext(rImgResult.image)
                        emitter.onCompleted()
                        
                    case .failure(let rError):
                        emitter.onError(rError)
                    }
            }
            return Disposables.create()
        }
    }
}
