//
//  MapViewController.swift
//  Jome17Wave_iOS
//
//  Created by SAM on 2020/11/11.
//

import UIKit

class MapViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let url_server = URL(string: common_url + "SURF_POINTServlet")
    var maps = [Map]()
    var allSurf = [Map]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllSurf()
    }
    
    @IBAction func changePage(_ sender: UISegmentedControl) {
        let x = CGFloat(sender.selectedSegmentIndex) * scrollView.bounds.width
        let offset = CGPoint(x: x, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    @objc func showAllSurf() {
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONDecoder().decode([Map].self, from: data!) {
                        self.maps = result
                        
                        DispatchQueue.main.async {
                            self.getAllSurf(newSurf: self.maps)
                            
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        if text == "" {
            allSurf = maps
        } else {
            allSurf = maps.filter({ (map) -> Bool in
                map.name.uppercased().contains(text.uppercased())
            })
        }
        getAllSurf(newSurf: allSurf)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func getAllSurf(newSurf: [Map]) {
        let allSurfTableController = self.children[0] as? MapAllTableViewController
        allSurfTableController?.maps = newSurf
        allSurfTableController?.mapTableView.reloadData()

        var northSurf = [Map]()
        for surf in newSurf {
            if surf.side == "北部浪點" {
                northSurf.append(surf)
            }
        }
        let northSurfTableController = self.children[1] as? MapNorthTableViewController
        northSurfTableController?.northSurf = northSurf
        northSurfTableController?.northTableView.reloadData()

        var eastSurf = [Map]()
        for surf in newSurf {
            if surf.side == "東部浪點" {
                eastSurf.append(surf)
            }
        }
        let eastSurfTableController = self.children[2] as? MapEastTableViewController
        eastSurfTableController?.eastSurf = eastSurf
        eastSurfTableController?.eastTableView.reloadData()

        var southSurf = [Map]()
        for surf in newSurf {
            if surf.side == "南部浪點" {
                southSurf.append(surf)
            }
        }
        let southSurfTableController = self.children[3] as? MapSouthTableViewController
        southSurfTableController?.southSurf = southSurf
        southSurfTableController?.southTableView.reloadData()

        var westSurf = [Map]()
        for surf in newSurf {
            if surf.side == "西部浪點" {
                westSurf.append(surf)
            }
        }
        let westSurfTableController = self.children[4] as? MapWestTableViewController
        westSurfTableController?.westSurf = westSurf
        westSurfTableController?.westTableView.reloadData()
    }
    
    @IBAction func unwindToMapViewController(_ unwindSegue: UIStoryboardSegue) {
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

extension MapViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        segmentedControl.selectedSegmentIndex = index
    }
}
