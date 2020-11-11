//
//  MapWestTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by SAM on 2020/11/11.
//

import UIKit

class MapWestTableViewController: UITableViewController {
    
    var westSurf = [Map]()
    let url_server = URL(string: common_url + "SURF_POINTServlet")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "MapListTableViewCell", bundle: nil), forCellReuseIdentifier: "MapListTableViewCell")
    }
    
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(showWestSurf), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showWestSurf()
    }
    
    @objc func showWestSurf() {
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([Map].self, from: data!) {
                        self.westSurf = result
                        
                        self.westSurf = result.filter({ (map) -> Bool in
                            map.side?.first == "西"
                        })
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
        return westSurf.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "MapListTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MapListTableViewCell
        let surfPoint = westSurf[indexPath.row]
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["SURF_POINT_ID"] = surfPoint.id
        
        requestParam["imageSize"] = view.frame.width
        var image: UIImage?
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                }
                if image == nil {
                    image = UIImage(named: "noImage.jpg")
                }
                DispatchQueue.main.async {
                    cell.ivMap.image = image
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        cell.lbName.text = surfPoint.name
        cell.lbSide.text = surfPoint.side
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectsdMap = westSurf[indexPath.row]
        if let viewController = storyboard?.instantiateViewController(identifier: "MapDetailTableViewController") as? MapDetailTableViewController {
            viewController.map = selectsdMap
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    

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
