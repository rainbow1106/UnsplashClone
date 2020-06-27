//
//  ListTableVCell.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

struct ListTableVCellDPModel {
    
    var id: String = ""
    var width: Int = 0
    var height: Int = 0
    var name: String?
    var color: UIColor?
    
    var imgUrl_thumb: String?
    var imgUrl_original: String?
    
}
final class ListTableVCell: UITableViewCell {

    private var disposeBag = DisposeBag()
    
    // ibs
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var botLine: UIView!
    
    @IBOutlet weak var imgVHeightConstraint: NSLayoutConstraint!
    
    private var fullImgTask: DownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.settingSubviews()
    }

    private func settingSubviews(){
        self.selectionStyle = .none
        self.imgV.do{
            $0.backgroundColor = UIColor.psRandom
            $0.contentMode = .scaleAspectFill
        }
        self.nameLB.do{
            $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            $0.textColor = UIColor.white
            $0.textAlignment = .left
        }
        self.botLine.do{
            $0.backgroundColor = .white
        }
    }
    private func resetData(){
        
        self.imgV.image = nil
        self.nameLB.text = nil
        self.imgV.backgroundColor = .white
        
    }
    public func mapCellData(cellData: ListTableVCellDPModel){
        
        self.resetData()
        
        self.imgV.backgroundColor = cellData.color
        
        if let uThumb = cellData.imgUrl_thumb,
            let imgUrl = URL(string: uThumb){
            self.imgV.kf.setImage(with: imgUrl)
        }
        if let uFul = cellData.imgUrl_original,
            let imgUrl = URL(string: uFul){
            
            self.fullImgWork(url: imgUrl)
            
        }
        
        self.nameLB.text = cellData.name
        
        self.cellHEightWork(pWidth: cellData.width, pHeight: cellData.height)
    }

    private func cellHEightWork(pWidth: Int, pHeight: Int){
        
        let mainWidth = self.frame.width
        
        let newHeight: CGFloat = mainWidth / CGFloat(pHeight) * CGFloat(pWidth)
        
        self.imgVHeightConstraint.constant = newHeight
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgV.kf.cancelDownloadTask()
        self.disposeBag = DisposeBag()
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
    
    private func loadFullImg(url: URL){
        
        self.fullImgTask = KingfisherManager.shared.retrieveImage(with: url) { [weak self](rResult) in
            
            guard let self = self else{
                return
            }
            switch rResult{
            case .failure(_):
                break
            case .success(let rImgResult):
                let rImg = rImgResult.image
                self.imgV.image = rImg
            }
        }
    }
}
