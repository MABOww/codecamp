//
//  TableViewCell.swift
//  CustomcellAPI
//
//  Created by 井上正裕 on 2017/02/18.
//  Copyright © 2017年 井上正裕. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemTitleLabel: UILabel!

    @IBOutlet weak var itemPriceLabel: UILabel!
    
 

    @IBOutlet weak var itemImageView: UIImageView!
    var itemUrl: String? // 商品ページのURL。遷移先の画面で利用する
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        // 元々入っている情報を再利用時にクリア
        //itemImageView.image = nil

    }
    
    

}


