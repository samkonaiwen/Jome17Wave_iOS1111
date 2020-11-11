//
//  MapTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by SAM on 2020/11/3.
//

import UIKit

class MapAllTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var mapTableView: UITableView!
    
    var maps = [Map]()
    let url_server = URL(string: common_url + "SURF_POINTServlet")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "MapListTableViewCell", bundle: nil), forCellReuseIdentifier: "MapListTableViewCell")
    }
    
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showAllMaps), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllMaps()
//        setupSearchBar()
    }
    
    @objc func showAllMaps() {
//        var requestParam = [String: Any]()
//        requestParam ["action"] = "getAll"
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([Map].self, from: data!) {
                        self.maps = result
                        
//                        self.maps = result.filter({ (map) -> Bool in
//                            map.side?.first == "北"
//                        })
                        
                        DispatchQueue.main.async {
                            if let control = self.tableView.refreshControl {
                                if control.isRefreshing {
                                    control.endRefreshing()
                                }
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return maps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "MapListTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MapListTableViewCell
        let map = maps[indexPath.row]
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["SURF_POINT_ID"] = map.id
        
        requestParam["imageSize"] = cell.frame.width
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {cell.ivMap.image = image}
            } else {
                print(error!.localizedDescription)
            }
        }
        
        cell.lbName.text = map.name
        cell.lbSide.text = map.side
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, bool) in
            let mapUpdateVC = self.storyboard?.instantiateViewController(withIdentifier: "MapUpdateTableViewController") as! MapUpdateTableViewController
            let map = self.maps[indexPath.row]
            mapUpdateVC.map = map
            self.navigationController?.pushViewController(mapUpdateVC, animated: true)
        }
        edit.backgroundColor = UIColor.lightGray
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, bool) in
            var requestParam = [String: Any]()
            requestParam["action"] = "mapDelete"
            requestParam["mapId"] = self.maps[indexPath.row].id
            executeTask(self.url_server!, requestParam) { (data, response, error) in
                if error == nil {
                    if data != nil {
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                if count != 0 {
                                    self.maps.remove(at: indexPath.row)
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
        }
        delete.backgroundColor = UIColor.red
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        // true代表滑到底視同觸發第一個動作；false代表滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectsdMap = maps[indexPath.row]
        if let viewController = storyboard?.instantiateViewController(identifier: "MapDetailTableViewController") as? MapDetailTableViewController {
            viewController.map = selectsdMap
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
//    let searchBar = UISearchBar()
//
//    func setupSearchBar() {
//        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//        searchBar.showsCancelButton = true
//        searchBar.delegate = self
//
//        mapTableView.delegate = self
//        mapTableView.dataSource = self
//
//        searchBar.searchTextField.clearButtonMode = .whileEditing
//        searchBar.placeholder = "收尋浪點"
//        self.mapTableView.tableHeaderView = searchBar
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let text = searchBar.text ?? ""
//        if text == "" {
//            showAllMaps()
//        } else {
//            maps = maps.filter({ (maps) -> Bool in
//                return maps.name.uppercased().contains(searchText.uppercased())
//            })
//        }
//        mapTableView.reloadData()
//    }

    // 關閉虛擬鍵盤
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }

    // 按取消按鈕，關閉虛擬鍵盤
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        view.endEditing(true)
//    }
    
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

    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "mapDetail" {
//            let indexPath = self.tableView.indexPathForSelectedRow!
//            let map = maps[indexPath.row]
//            let controller = segue.destination as! MapDetailTableViewController
//            controller.map = map
//        }
//    }
}
