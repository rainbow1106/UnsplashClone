//
//  ListTableVCell.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit
import Kingfisher

struct ListTableVCellDPModel {
    
    var id: String = ""
    var width: Int = 0
    var height: Int = 0
    var name: String?
    var color: UIColor?
    
    var imgUrl_raw: String?
    var imgUrl_thumb: String?
    var imgUrl_original: String?
    
}
final class ListTableVCell: UITableViewCell {

    // ibs
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var botLine: UIView!
    
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
        self.nameLB.text = cellData.name
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgV.kf.cancelDownloadTask()
    }
    
}
