//
//  AvengersViewController.swift
//  Cassini
//
//  Created by 明凯张 on 2019/5/25.
//  Copyright © 2019 明凯张. All rights reserved.
//

import UIKit

class AvengersViewController: UIViewController,UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate=self
    }
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self{
            if let ivc = secondaryViewController.contents as? ImageViewController, ivc.imageURL == nil{
                return true
            }
        }
        return false
    }
    
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
