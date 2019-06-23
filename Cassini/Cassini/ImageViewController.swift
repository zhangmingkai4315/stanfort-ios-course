//
//  ViewController.swift
//  Cassini
//
//  Created by mingkai on 2019/6/22.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private var image:UIImage?{
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            // 设置?防止prepare的时候失败
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    
    var imageView = UIImageView()
    
    
    var imageURL: URL?{
        didSet{
            image = nil
            // 检查是否当前view窗口可用
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil{
            fetchImage()
            
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 2
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    private func fetchImage(){
        if let url = imageURL{
              spinner.startAnimating()
              DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL{
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageURL == nil{
            imageURL = DemoURLs.nasa0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

