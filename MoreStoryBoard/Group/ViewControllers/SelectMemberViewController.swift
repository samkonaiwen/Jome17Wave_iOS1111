//
//  SelectMemberViewController.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/13.
//

import UIKit

class SelectMemberViewController: UIViewController {
    var members = [Member]()
    let url = URL(string: "\(common_url)jome_member/LoginServlet")
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "MemberListTableViewCell", bundle: nil), forCellReuseIdentifier: "MemberListTableViewCell")
        fetchMembers()
        // Do any additional setup after loading the view.
    }
    
    func fetchMembers() {
        let requestParam = ["action":"getAll"]
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil{
                if data != nil {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase //將底線轉換成駝峰是命名
                    if let result = try? decoder.decode([Member].self, from: data!){
                        self.members = result
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }else{
                print(error!.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectMemberViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberListTableViewCell", for: indexPath) as! MemberListTableViewCell
        let member = members[indexPath.row]
        cell.nameLabel.text = member.nickname
        cell.accountLabel.text = member.account
        
        /* 設定照片 */
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["memberId"] = member.memberId
        requestParam["imageSize"] = cell.frame.width
        var image: UIImage?
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {cell.memberImageView.image = image}
            } else {
                print(error!.localizedDescription)
            }
        }
        
        return cell
    }
    
    
}
