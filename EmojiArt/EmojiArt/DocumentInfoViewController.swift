//
//  DocumentInfoViewController.swift
//  EmojiArt
//
//  Created by mingkai on 2019/6/29.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class DocumentInfoViewController: UIViewController {
    
    var document: EmojiArtDocument?{
        didSet{
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    private func updateUI(){
        if sizeLabel != nil, dateLabel != nil, let url = document?.fileURL, let attributes = try? FileManager.default.attributesOfItem(atPath: url.path){
            sizeLabel.text  = "\(attributes[.size] ?? 0) bytes"
            if let created = attributes[.creationDate] as? Date{
                dateLabel.text = shortDateFormatter.string(from: created)
            }
        }
        // 创建根据图片自定义的比例
        if thumbnailImageView != nil,
            thumbnailAspect != nil,
            let thumbnail = document?.thumbnail{
            thumbnailImageView.image = thumbnail
            thumbnailImageView.removeConstraint(thumbnailAspect)
                thumbnailAspect = NSLayoutConstraint(
                    item: thumbnailImageView,
                    attribute: .width,
                    relatedBy: .equal,
                    toItem: thumbnailImageView,
                    attribute: .height,
                    multiplier: thumbnail.size.width/thumbnail.size.height,
                    constant: 0
            )
            thumbnailImageView.addConstraint(thumbnailAspect)
        }
        
        if presentationController is UIPopoverPresentationController {
            thumbnailImageView?.isHidden = true
            returnBtn?.isHidden = true
            view.backgroundColor = .clear
        }
    }
    
    
    @IBOutlet weak var returnBtn: UIButton!
    
    // 设置popover的大小
    @IBOutlet weak var topLevelView: UIStackView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let fittedSize = topLevelView?.sizeThatFits(UILayoutFittingCompressedSize){
            preferredContentSize = CGSize(width: fittedSize.width+30, height: fittedSize.height+30)
        }
    }
    
    // 将storeboard中的thumbnail aspect 【constrains】拖拽到这里
    @IBOutlet weak var thumbnailAspect: NSLayoutConstraint!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func returnBtnAction(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
}
