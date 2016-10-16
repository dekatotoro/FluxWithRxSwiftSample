//
//  ErrorNoticeView.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import UIKit


class ErrorNoticeView: UIVisualEffectView, Nibable {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static func make(with noticeType: ErrorNoticeType) -> ErrorNoticeView {
        let view = makeFromNib()
        view.configure(noticeType: noticeType)
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        effect = UIBlurEffect(style: .light)
        alpha = 0.9
        layer.cornerRadius = 4
        clipsToBounds = true
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.red
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
    }
    
    func configure(noticeType: ErrorNoticeType) {
        descriptionLabel.text = noticeType.description
    }
}

