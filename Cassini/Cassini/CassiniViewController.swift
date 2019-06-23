//
//  CassiniViewController.swift
//  Cassini
//
//  Created by mingkai on 2019/6/23.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if let url = DemoURLs.NASA[identifier]{
                // 如果当前的detail嵌入到navigation controller中，则需要检查destination
                var destination = segue.destination
                if let navcon = destination as? UINavigationController{
                    destination = navcon.visibleViewController ?? navcon
                }
                
                if let imageVC = destination as? ImageViewController{
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }

}
