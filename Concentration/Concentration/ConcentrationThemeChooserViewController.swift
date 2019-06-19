//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by mingkai on 2019/6/19.
//  Copyright © 2019年 mingkai. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController,UISplitViewControllerDelegate {
    
    let themes = [
        "Sports" : "🏊‍♂️🏋🏿‍♂️🤼‍♀️🚣🏿‍♂️🧗‍♀️🏇🏿🧘‍♀️🤾🏿‍♂️🏌️‍♀️🤸‍♀️",
        "Animals": "🐝🐛🦋🐌🐚🐞🐜🦗🕷🦈",
        "Faces": "😀😁😂🤣🤗🤩🤔🤨😨😩",
    ]
    
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as?ConcentrationViewController{
            if cvc.theme == nil{
                return true
            }
        }
        return false
    }
    
    
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
        }else if let cvc = lastSeguedToConcentrationViewController{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }else{
            performSegue(withIdentifier: "choose theme", sender: sender)
        }
    }
    
    
    private var splitViewDetailConcentrationViewController : ConcentrationViewController?{
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choose theme"{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                if let cvc = segue.destination as? ConcentrationViewController{
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }

}
