//
//  TestVC.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TestVC: BaseVC {

    @IBOutlet weak var tableV: UITableView!
    
    private let vm = ListVM()
    
    convenience init(){
        self.init(nibName: "TestVC", bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableV.do{
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            
            $0.allowsSelection = true
            $0.allowsMultipleSelection = false
            
            $0.rx.setDelegate(self).disposed(by: self.disposeBag)
            
            $0.register(UINib(nibName: "ListTableVCell", bundle: nil),
                        forCellReuseIdentifier: ListTableVCell.description())
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
        
            self.bindDatas()
            
        })
        
    }

    private func bindDatas(){
        
        self.vm.output.itemList.bind(to: self.tableV.rx.items(cellIdentifier: ListTableVCell.description(), cellType: ListTableVCell.self)) { (idx, cellData, cell) in
            
            cell.nameLB.text = cellData
        }
        .disposed(by: self.disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
