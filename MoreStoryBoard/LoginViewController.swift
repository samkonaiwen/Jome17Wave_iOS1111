//
//  LoginViewController.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/19.
//

import UIKit
import AVKit

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bg: UIImageView!
    let url = URL(string: "\(common_url)jome_member/AdminServlet")
    var player: AVPlayer?
    var layer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        

        
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if account.isEmpty || account == "" {
            showAlertController("請檢查帳號", "欄位不能空白")
            
        }
        if password.isEmpty || password == "" {
            showAlertController("請檢查密碼", "欄位不能空白")
        }
        
        var requestParam = [String: Any]()
        requestParam["action"] = "adminLogin"
        requestParam["account"] = account
        requestParam["password"] = password
        
        executeTask(url!, requestParam) { (data, resp, error) in
            if let data = data,
               let result = try? JSONDecoder().decode(changeResponse.self, from: data){
                let resultCode = result.resultCode
                DispatchQueue.main.async {
                    if resultCode > 0{
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                    }else{
                        self.showAlertController("登入失敗", "請重新登入")
                    }
                }
            }
        }
        
    }
    
    func showAlertController(_ title: String, _ message: String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "確定", style: .default)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }

}
