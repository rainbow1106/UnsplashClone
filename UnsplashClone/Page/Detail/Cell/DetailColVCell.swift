//
//  DetailColVCell.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/27/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit
import Kingfisher

final class DetailColVCell: UICollectionViewCell {

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
    }
    
    public func mapCellData(cellData: ListTableVCellDPModel){
        
        self.resetData()
        
        if let uThumb = cellData.imgUrl_thumb,
            let url = URL(string: uThumb){
            
            self.imgV.kf.setImage(with: url)
            
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
}
