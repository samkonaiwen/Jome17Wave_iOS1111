//
//  MapDetailTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by SAM on 2020/11/4.
//

import UIKit

class MapDetailTableViewController: UITableViewController {
    
    let url_server = URL(string: common_url + "SURF_POINTServlet")
    
    var map: Map!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSide: UILabel!
    @IBOutlet weak var lbLatitude: UILabel!
    @IBOutlet weak var lbLongitude: UILabel!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var lbLevel: UILabel!
    @IBOutlet weak var lbTidal: UILabel!
    @IBOutlet weak var lbDirection: UILabel!
    @IBOutlet weak var ivMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = map.name
        lbName.text = map.name
        lbSide.text = map.side
        lbLatitude.text = String(map.latitude ?? 1)
        lbLongitude.text = String(map.longitude ?? 1)
        lbType.text = map.type
        lbLevel.text = map.level
        lbTidal.text = map.tidal
        lbDirection.text = map.direction
        
        showImage()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: animated)
            }
    }
    
    func showImage() {
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["SURF_POINT_ID"] = map.id
        
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
                DispatchQueue.main.async {self.ivMap.image = image}
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
