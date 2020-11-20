//
//  AdminViewController.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/16.
//

import UIKit

class AdminViewController: UIViewController {
    @IBOutlet var containerViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViews[0].isHidden = false
        containerViews[1].isHidden = true
        containerViews[2].isHidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登出", style: .plain, target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        view.window?.rootViewController = storyboard.instantiateInitialViewController()
    }
    
    @IBAction func clickSegment(_ sender: UISegmentedControl) {
        containerViews.forEach{
            $0.isHidden = true
        }
        containerViews[sender.selectedSegmentIndex].isHidden = false
    }
    
    



}
