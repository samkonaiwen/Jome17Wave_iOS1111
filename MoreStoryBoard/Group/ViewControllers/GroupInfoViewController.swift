//
//  GroupInfoViewController.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/12.
//

import UIKit

class GroupInfoViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var allGroups = [PersonalGroup]()
    let url = URL(string: "\(common_url)jome_member/GroupOperateServlet")
    var searchGroups = [PersonalGroup]()
    var searchKeyword = ""
    
    @IBAction func changePage(_ sender: UISegmentedControl) {
        let x = CGFloat(sender.selectedSegmentIndex) * scrollView.bounds.width
        let offset = CGPoint(x: x, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllGroups()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        /* 點擊畫面任一處來關閉鍵盤 */
//        let tap = UITapGestureRecognizer(target: self, action: #selector(closedKeybored))
//        view.addGestureRecognizer(tap)
    }
    
//    @objc func closedKeybored(){
//        self.view.endEditing(true)
//    }
    
    @IBAction func closeKeyboard(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
    
    /* 讀取所有活動 */
    @objc func fetchAllGroups() {
        let requestParam = ["action":"getAll"]
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil{
                if data != nil {
                    if let result = try? JSONDecoder().decode(GroupGetAllResponse.self, from: data!){
                        if let allGroups = result.groups {
                            self.allGroups = allGroups
                        }
                        
                        DispatchQueue.main.async {
                            self.laodGroupsData(newGroupsData: self.allGroups)
                        }
                        
                    }
                }
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    func laodGroupsData(newGroupsData: [PersonalGroup]) {
        /* 全部 */
        let allGroupsViewController = self.children[0] as? AllGroupsViewController
        allGroupsViewController?.allGroups = newGroupsData
        allGroupsViewController?.tableView.reloadData()
        
        /* 最新發佈 */
        var lastGroups = [PersonalGroup]()
        for group in newGroupsData {
            if group.groupStatus == Int(1){
                lastGroups.append(group)
            }
        }
        let lastGroupsViewController = self.children[1] as? LastGroupsViewController
        lastGroupsViewController?.lastGroups = lastGroups
        lastGroupsViewController?.tableView.reloadData()
        
        /* 即將開始 */
        var comingGroups = [PersonalGroup]()
        for group in newGroupsData {
            if group.groupStatus == Int(2) {
                comingGroups.append(group)
            }
        }
        let comingGroupsViewController = self.children[2] as? ComingGroupsViewController
        comingGroupsViewController?.comingGroups = comingGroups
        comingGroupsViewController?.tableView.reloadData()
        
        /* 已結束 */
        var finishedGroups = [PersonalGroup]()
        for group in newGroupsData {
            if group.groupStatus == Int(3) {
                finishedGroups.append(group)
            }
        }
        let finishedGroupsViewController = self.children[3] as? FinishedGroupsViewController
        finishedGroupsViewController?.finishedGroups = finishedGroups
        finishedGroupsViewController?.tableView.reloadData()
    }
}
    
extension GroupInfoViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        segmentedControl.selectedSegmentIndex = index
    }
}

extension GroupInfoViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchKeyword = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if searchKeyword == "" {
             searchGroups = allGroups
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchGroups = allGroups.filter({ (group) -> Bool in
                group.groupName.uppercased().contains(searchKeyword.uppercased())
            })
        }
        laodGroupsData(newGroupsData: searchGroups)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}
