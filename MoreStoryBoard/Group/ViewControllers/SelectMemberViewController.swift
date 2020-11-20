//
//  SelectMemberViewController.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/13.
//

import UIKit

class SelectMemberViewController: UIViewController {
    
    var selectedMember: Member?
    var allMembers = [Member]()
    let url = URL(string: "\(common_url)jome_member/LoginServlet")
    var members = [Member]()
    var searchKeyword = ""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "MemberListTableViewCell", bundle: nil), forCellReuseIdentifier: "MemberListTableViewCell")
        fetchMembers()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closedKeybored))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func closedKeybored(){
        self.view.endEditing(true)
    }
    
    func fetchMembers() {
        let requestParam = ["action":"getAll"]
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil{
                if data != nil {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase //將底線轉換成駝峰是命名
                    if let result = try? decoder.decode([Member].self, from: data!){
                        self.allMembers = result
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
}

extension SelectMemberViewController: UITableViewDataSource, UITableViewDelegate{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "back", sender: nil)
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? InsertGroupTableViewController,
           let row = tableView.indexPathForSelectedRow?.row{
            controller.member = members[row]
        }
    }
}

extension SelectMemberViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchKeyword = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if searchKeyword == "" {
               members = allMembers
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            members = allMembers.filter({ (member) -> Bool in
                member.account.uppercased().contains(searchKeyword.uppercased())
            })
            
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
