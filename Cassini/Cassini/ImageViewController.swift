//
//  ImageViewController.swift
//  Cassini
//
//  Created by 明凯张 on 2019/5/25.
//  Copyright © 2019 明凯张. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{
    var imageURL: URL?{
        didSet{
            image = nil
            fetchImage()
        }
    }
    
//    private func fetchImage(){
//        if let url = imageURL{
//            let urlContent = try? Data(contentsOf: url)
//            if let imageData = urlContent{
//                image = UIImage(data:imageData)
//            }
//        }
//    }
    
    private func fetchImage(){
        if let url = imageURL{
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                let urlContent = try? Data(contentsOf: url)
                if let imageData = urlContent, url == self?.imageURL{
                    // set ui should in main queue
                    DispatchQueue.main.async {
                        self?.image = UIImage(data:imageData)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    fileprivate var imageView = UIImageView()
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil{
            fetchImage()
        }
    }
}


extension ImageViewController: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
