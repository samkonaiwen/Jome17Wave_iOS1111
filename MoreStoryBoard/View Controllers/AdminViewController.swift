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
        let logoutAlertController = UIAlertController(title: "登出確認", message: "你確定要登出管理系統嗎？", preferredStyle: .alert)
        
        let logout = UIAlertAction(title: "登出", style: .default) { (UIAlertAction) in
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            self.view.window?.rootViewController = storyboard.instantiateInitialViewController()
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        logoutAlertController.addAction(logout)
        logoutAlertController.addAction(cancel)
        
        self.present(logoutAlertController, animated: true, completion: nil)
    }
    
    @IBAction func clickSegment(_ sender: UISegmentedControl) {
        containerViews.forEach{
            $0.isHidden = true
        }
        containerViews[sender.selectedSegmentIndex].isHidden = false
    }
    
    



}
