//
//  MemberAdminViewController.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/15.
//

import UIKit

class MemberAdminViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var memberCollectionView: UICollectionView!
    let url = URL(string: "\(common_url)jome_member/LoginServlet")
    var allMembers = [JomeMember]()
    var members = [JomeMember]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberCollectionView.delegate = self
        memberCollectionView.dataSource = self
        searchBar.delegate = self
        getJoMembers()
    }
    
    
    func getJoMembers(){
        let requestParam = ["action" : "getAllMembers"]
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase //將底線轉換成駝峰是命名
        executeTask(url!, requestParam) { (data, resp, error) in
            if let result = try? JSONDecoder().decode([JomeMember].self, from: data!){
                DispatchQueue.main.async {
                    self.allMembers = result
                    self.members = self.allMembers
                    print("membersConut: \(self.members.count)")
                    self.memberCollectionView.reloadData()
                }
            }
        }
    }
}

extension MemberAdminViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if text == "" {
            members = allMembers
        }else{
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            members = allMembers.filter({ (member) -> Bool in
                (member.nickname?.uppercased().contains(text.uppercased()))!
            })
        }
        memberCollectionView.reloadData()
    }
    
    // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MemberAdminViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("membersConutLine66: \(members.count)")
        return members.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memberCollectionView.dequeueReusableCell(withReuseIdentifier: "\(MemberAdminCollectionViewCell.self)", for: indexPath) as! MemberAdminCollectionViewCell
        
        cell.image = nil
        
        let member = members[indexPath.item]
//        print("indexPath.item: \(indexPath.item)")
        cell.memberIdLabel.text = member.memberId
        cell.memberNameLabel.text = member.nickname
        
        //取得大頭貼
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["memberId"] = member.memberId
        requestParam["imageSize"] = memberCollectionView.frame.width
        executeTask(url!, requestParam) { (data, resp, error) in

            if error == nil {
                if data != nil {
                    cell.image = UIImage(data: data!)
                }
                if cell.image == nil {
                    cell.image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    cell.memberImage.image = cell.image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        
        return cell
    }
    
    
}

extension MemberAdminViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memberDetailTableVC = UIStoryboard(name: "Admin", bundle:  nil).instantiateViewController(withIdentifier: "\(MemberDetailTableViewController.self)") as! MemberDetailTableViewController
        
        memberDetailTableVC.joMember = members[indexPath.item]
        self.navigationController?.pushViewController(memberDetailTableVC, animated: true)
    }
}
