//
//  MemberDetailTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/16.
//

import UIKit

class MemberDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var memberLabels: [UILabel]!
    @IBOutlet var memberTextFields: [UITextField]!
    @IBOutlet weak var accountSwitch: UISwitch!
    
    var joMember: JomeMember?
    var url: URL?
    var accountStatus: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(clickSaveBarItem))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        guard let member = joMember else {
            print("joMember is nil!")
            return }
        
        memberLabels[2].text = transGender2Icon(member.gender!)
        memberLabels[0].text = member.memberId
        memberLabels[1].text = formateDate(member.modifyDate!)
        
        loadValue2Switch(member.accountStatus!)
        
        memberTextFields[0].text = member.account
        memberTextFields[1].text = member.password
        memberTextFields[2].text = member.nickname
        memberTextFields[3].text = member.phoneNumber
        textFieldsEnableOrNot(false)
        
        

        
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["memberId"] = member.memberId
        requestParam["imageSize"] = self.tableView.frame.width
        executeTask(url!, requestParam) { (data, resp, error) in

            guard let data = data else{

                self.profileImageView.image = UIImage(named: "noImage")
                return
            }
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func clickLocation(_ sender: Any) {
        let singleMemberMapVC = UIStoryboard(name: "Admin", bundle: nil).instantiateViewController(withIdentifier: "\(SingleMemberMapViewController.self)") as? SingleMemberMapViewController
        
        singleMemberMapVC?.member = self.joMember
        singleMemberMapVC?.image = self.profileImageView.image
        
        self.navigationController?.pushViewController(singleMemberMapVC!, animated: true)
    }
    
        
    @IBAction func close(_ sender: Any) {
    }
    
    
    @IBAction func switchValueChange(_ sender: Any) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        if accountSwitch.isOn {
            accountStatus = 1
        }else{
            accountStatus = 0
        }
    }
    
    @IBAction func accountModify(_ sender: Any) {
        if navigationItem.rightBarButtonItem?.isEnabled != true {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        textFieldIsEnable(memberTextFields[0])
        
    }
    
    @IBAction func passwordModify(_ sender: Any) {
        if navigationItem.rightBarButtonItem?.isEnabled != true {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        textFieldIsEnable(memberTextFields[1])
    }
    
    @IBAction func nicknameModify(_ sender: Any) {
        if navigationItem.rightBarButtonItem?.isEnabled != true {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        textFieldIsEnable(memberTextFields[2])
    }
    
    @IBAction func phoneModify(_ sender: Any) {
        if navigationItem.rightBarButtonItem?.isEnabled != true {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        textFieldIsEnable(memberTextFields[3])
        memberTextFields[3].keyboardType = UIKeyboardType.phonePad
    }
    
    func transGender2Icon(_ gender: Int) -> String {
        var icon: String = ""
        switch gender {
        case 1:
            icon = String("🙎‍♂️")
        case 2:
            icon = String("🙎‍♀️")
        case 3:
            icon = String("😁")
        default: break
            
        }
        return icon
    }
    
    func formateDate(_ dateStr: String) -> String {
        var date: Date = Date()
        var shortStlyeStr  = ""
        let strFormat = DateFormatter()
        strFormat.dateFormat = "yyyy-MM-dd HH:mm"
        if let afterFormatDate = strFormat.date(from: dateStr) {
            date = afterFormatDate
        }
        strFormat.locale = Locale.current
        strFormat.dateStyle = .short
        strFormat.timeStyle = .short
        
        shortStlyeStr = strFormat.string(from: date)

        return shortStlyeStr
    }
    
    func textFieldsEnableOrNot(_ bool: Bool) {
        for textField in memberTextFields{
            textField.isEnabled = bool
            textField.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    func textFieldIsEnable(_ textField: UITextField) {
        textField.isEnabled = true
        textField.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        textField.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
    }
    
    func loadValue2Switch(_ accountStatus: Int) {
        if accountStatus == 1 {
            accountSwitch.isOn = true
        }else{
            accountSwitch.isOn = false
        }
    }
        
    @objc func clickSaveBarItem() {
        let alertController = UIAlertController(title: "請檢查欄位", message: "不能有空白喔！", preferredStyle: .alert)
        
        
        let account = memberTextFields[0].text ?? ""
        let password = memberTextFields[1].text ?? ""
        let nickname = memberTextFields[2].text ?? ""
        let phoneNumber = memberTextFields[3].text ?? ""
        
        if account.isEmpty || account == "" {
            let ok = UIAlertAction(title: "OK", style: .default){_ in
                self.memberTextFields[0].backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            }
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if password.isEmpty || password == "" {
            let ok = UIAlertAction(title: "OK", style: .default){_ in
                self.memberTextFields[1].backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            }
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if nickname.isEmpty || nickname == "" {
            let ok = UIAlertAction(title: "OK", style: .default){_ in
                self.memberTextFields[2].backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            }
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if phoneNumber.isEmpty || phoneNumber == "" {
            let ok = UIAlertAction(title: "OK", style: .default){_ in
                self.memberTextFields[3].backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            }
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let submitAlertController = UIAlertController(title: "更新確認", message: "確認要更新會員資料？", preferredStyle: .actionSheet)
        let submitAction = UIAlertAction(title: "確定", style: .default){ [self]_ in
            let submitMember = JomeMember(memberId: joMember?.memberId, accountStatus: accountStatus, phoneNumber: phoneNumber, nickname: nickname, account: account, password: password, gender: joMember?.gender, latitude: joMember?.latitude, longitude: joMember?.longitude, tokenId: joMember?.tokenId, friendCount: joMember?.friendCount, scoreAverage: joMember?.scoreAverage, beRankedCount: joMember?.beRankedCount, groupCount: joMember?.groupCount, createGroupCount: joMember?.createGroupCount, modifyDate: joMember?.modifyDate)
            
            var requestParam = [String: Any]()
            requestParam["action"] = "update"
            requestParam["memberUp"] = try! String(data: JSONEncoder().encode(submitMember), encoding: .utf8)
            requestParam["imageBase64"] = "noImage"
            executeTask(self.url!, requestParam) { (data, response, error) in
                if let data = data,
                   let result = try? JSONDecoder().decode(changeResponse.self, from: data){
                    let resultCode = result.resultCode
                    DispatchQueue.main.async {
                        if resultCode != 0 {
                            self.navigationController?.popViewController(animated: true)
                            print("resultCode~~~~~~~~~~~~~~: \(resultCode)")
                            
                        }
                    }
                }
            }
        }
        submitAlertController.addAction(submitAction)
        self.present(submitAlertController, animated: true, completion: nil)
    }

}
