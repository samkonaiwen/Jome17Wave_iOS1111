//
//  FinishedGroupsViewController.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/11.
//

import UIKit

class FinishedGroupsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var finishedGroups = [PersonalGroup]()
    let url = URL(string: "\(common_url)jome_member/GroupOperateServlet")
    
    struct PropertyKeys {
        static let finishedGroupsCell = "GroupListTableViewCell"
        static let statusCencel = " 已取消 "
        static let statusLast = " 最新發佈 "
        static let statusComing = " 即將開始 "
        static let statusFinished = " 已結束 "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "GroupListTableViewCell", bundle: nil), forCellReuseIdentifier: "GroupListTableViewCell")
        // Do any additional setup after loading the view.
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

extension FinishedGroupsViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        finishedGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.finishedGroupsCell, for: indexPath) as! GroupListTableViewCell
        cell.groupImageView.image = nil
        let group = finishedGroups[indexPath.row]
        cell.nameLabel.text = group.groupName
        cell.locationLabel.text = group.surfName
        if let date = group.assembleTime{
            cell.dateLabel.text = dateFormatter(assembleTimeStr: date)
        }
        
        /* 設定照片 */
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["groupId"] = group.groupId
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
                DispatchQueue.main.async {cell.groupImageView.image = image}
            } else {
                print(error!.localizedDescription)
            }
        }
        
        /* 設定活動狀態 */
        switch group.groupStatus {
        case 0:
            cell.statusLabel.backgroundColor = UIColor(red: 154/255, green: 208/255, blue: 234/255, alpha: 1) //淺藍
            cell.statusLabel.textColor = UIColor(red: 4/255, green: 66/255, blue: 99/255, alpha: 1) //深藍
            cell.statusLabel.text = PropertyKeys.statusCencel
        case 1:
            cell.statusLabel.backgroundColor = UIColor(red: 84/255, green: 70/255, blue: 231/255, alpha: 1) //紫
            cell.statusLabel.textColor = UIColor(red: 248/255, green: 248/255, blue: 255/255, alpha: 1) //白
            cell.statusLabel.text = PropertyKeys.statusLast
        case 2:
            cell.statusLabel.backgroundColor = UIColor(red: 244/255, green: 3/255, blue: 105/255, alpha: 1) //桃紅
            cell.statusLabel.textColor = UIColor(red: 248/255, green: 248/255, blue: 255/255, alpha: 1) //白
            cell.statusLabel.text = PropertyKeys.statusComing
        case 3:
            cell.statusLabel.backgroundColor = UIColor(red: 4/255, green: 66/255, blue: 99/255, alpha: 1) //深藍
            cell.statusLabel.textColor = UIColor(red: 248/255, green: 248/255, blue: 255/255, alpha: 1) //白
            cell.statusLabel.text = PropertyKeys.statusFinished
        default:
            print("Group Status Error")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectGroup = finishedGroups[indexPath.row]
        if let controller = storyboard?.instantiateViewController(identifier: "GroupDetailTableViewController") as? GroupDetailTableViewController{
            controller.group = selectGroup
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func dateFormatter(assembleTimeStr: String) -> String {
        var dateStr = ""
        let formatter = DateFormatter()
        if Locale.current.description.contains("TW") {
            formatter.locale = Locale(identifier: "zh_TW")
        }
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let assembleTimeDate = formatter.date(from: assembleTimeStr){
            formatter.dateFormat = "yyyy-MM-dd"
            dateStr = formatter.string(from: assembleTimeDate)
        }
        return dateStr
    }
}
