//
//  ErrorNoticeView.swift
//  FluxWithRxSwiftSample
//
//  Created by Yuji Hato on 2016/10/13.
//  Copyright © 2016年 dekatotoro. All rights reserved.
//

import UIKit


class ErrorNoticeView: UIView, Nibable {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static func make(with noticeType: ErrorNoticeType) -> ErrorNoticeView {
        let view = makeFromNib()
        view.configure(noticeType: noticeType)
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .lightGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
    }
    
    func configure(noticeType: ErrorNoticeType) {
        descriptionLabel.text = noticeType.description
    }
}

