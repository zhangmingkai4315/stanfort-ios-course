//
//  AvengersViewController.swift
//  Cassini
//
//  Created by 明凯张 on 2019/5/25.
//  Copyright © 2019 明凯张. All rights reserved.
//

import UIKit

class AvengersViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = AvengersURL.Avengers[segue.identifier ?? ""]{
            if let imageVC = (segue.destination.contents as? ImageViewController){
                print(url)
                imageVC.imageURL = url
                imageVC.title = (sender as? UIButton)?.currentTitle
            }
        }
    }
}


extension UIViewController {
    var contents : UIViewController {
        if let navcon = self as?UINavigationController{
            return navcon.visibleViewController ?? self
        }else{
            return self
        }
    }
}
