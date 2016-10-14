//
//  SearchUserCell.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//


import UIKit
import Kingfisher

class SearchUserCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var url: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        thumbnail.contentMode = .scaleAspectFit
        name.font = UIFont.systemFont(ofSize: 20)
        name.textColor = UIColor.darkGray
        url.font = UIFont.systemFont(ofSize: 12)
        url.textColor = UIColor.gray
    }
    
    func configure(user: GitHubUser) {
        name.text = user.name
        url.text = user.url
        thumbnail.kf.setImage(with: ImageResource(downloadURL: URL(string:user.imageUrl)!))
        
    }
    
}
