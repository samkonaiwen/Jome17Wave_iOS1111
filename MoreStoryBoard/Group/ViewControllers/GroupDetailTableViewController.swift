//
//  GroupDetailTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/18.
//

import UIKit

class GroupDetailTableViewController: UITableViewController {
    var group: PersonalGroup!
    let url = URL(string: "\(common_url)jome_member/GroupOperateServlet")
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var groupLImitLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var groupStatusLabel: UILabel!
    
    struct PropertyKeys {
        static let allGroupsCell = "GroupListTableViewCell"
        static let statusCencel = " 已取消 "
        static let statusLast = " 最新發佈 "
        static let statusComing = " 即將開始 "
        static let statusFinished = " 已結束 "
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGroup()
        loadImage()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        loadGroup()
        loadImage()
    }
    
    func loadGroup() {
        memberLabel.text = "\(group.nickname)"
        groupNameLabel.text = group.groupName
        dateLabel.text = group.assembleTime
        locationLabel.text = group.surfName
        groupLImitLabel.text = "\(String(group.groupLimit ?? 0))人"
        memoLabel.text = group.notice
        
        /* 設定活動狀態 */
        switch group.groupStatus {
        case 0:
            groupStatusLabel.backgroundColor = UIColor(red: 154/255, green: 208/255, blue: 234/255, alpha: 1) //淺藍
            groupStatusLabel.textColor = UIColor(red: 4/255, green: 66/255, blue: 99/255, alpha: 1) //深藍
            groupStatusLabel.text = PropertyKeys.statusCencel
        case 1:
            groupStatusLabel.backgroundColor = UIColor(red: 84/255, green: 70/255, blue: 231/255, alpha: 1) //紫
            groupStatusLabel.textColor = UIColor(red: 248/255, green: 248/255, blue: 255/255, alpha: 1) //白
            groupStatusLabel.text = PropertyKeys.statusLast
        case 2:
            groupStatusLabel.backgroundColor = UIColor(red: 244/255, green: 3/255, blue: 105/255, alpha: 1) //桃紅
            groupStatusLabel.textColor = UIColor(red: 248/255, green: 248/255, blue: 255/255, alpha: 1) //白
            groupStatusLabel.text = PropertyKeys.statusComing
        case 3:
            groupStatusLabel.backgroundColor = UIColor(red: 4/255, green: 66/255, blue: 99/255, alpha: 1) //深藍
            groupStatusLabel.textColor = UIColor(red: 248/255, green: 248/255, blue: 255/255, alpha: 1) //白
            groupStatusLabel.text = PropertyKeys.statusFinished
        default:
            print("Group Status Error")
        }
    }

    func loadImage() {
        /* 設定照片 */
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["groupId"] = group.groupId
        requestParam["imageSize"] = view.frame.width
        var image: UIImage?
        executeTask(url!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {self.groupImageView.image = image}
            } else {
                print(error!.localizedDescription)
            }
        }
    }


    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
