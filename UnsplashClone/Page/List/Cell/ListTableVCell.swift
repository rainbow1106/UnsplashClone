//
//  ListTableVCell.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit
import Kingfisher

final class ListTableVCell: UITableViewCell {

    // ibs
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    
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
    }
    private func resetData(){
        
        self.imgV.image = nil
        self.nameLB.text = nil
        
    }
    public func mapCellData(){
        
        self.resetData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgV.kf.cancelDownloadTask()
    }
}
