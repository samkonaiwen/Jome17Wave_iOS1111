//
//  MapUpdateTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by SAM on 2020/11/9.
//

import UIKit

class MapUpdateTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfSide: UITextField!
    @IBOutlet weak var tfLatitude: UITextField!
    @IBOutlet weak var tfLongitude: UITextField!
    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var tfLevel: UITextField!
    @IBOutlet weak var tfTidal: UITextField!
    @IBOutlet weak var tfDirection: UITextField!
    @IBOutlet weak var ivMap: UIImageView!
    let url_server = URL(string: common_url + "SURF_POINTServlet")
    var map: Map!
    var imageUpload: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = map.name
        showMap()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(clickUpdate))
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    @IBAction func clickTakePicture(_ sender: Any) {
        imagePicker(type: .camera)
    }
    
    @IBAction func clickPickPicture(_ sender: Any) {
        imagePicker(type: .photoLibrary)
    }
    
    func imagePicker(type: UIImagePickerController.SourceType) {
        hideKeyboard()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageUpload = mapImage
            ivMap.image = mapImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func showMap() {
        tfName.text = map.name
        tfSide.text = map.side
        tfLatitude.text = String(map.latitude ?? 1)
        tfLongitude.text = String(map.longitude ?? 1)
        tfType.text = map.type
        tfLevel.text = map.level
        tfTidal.text = map.tidal
        tfDirection.text = map.direction
        
        var requestParam = [String: Any]()
        requestParam["action"] = "getImage"
        requestParam["SURF_POINT_ID"] = map.id
        
        requestParam["imageSize"] = view.frame.width
        executeTask(url_server!, requestParam) { (data, response, error) in
            var image: UIImage?
            if data != nil {
                image = UIImage(data: data!)
            }
            if image == nil {
                image = UIImage(named: "noImage.jpg")
            }
            DispatchQueue.main.async {
                self.ivMap.image = image
            }
        }
    }
    
    @objc func clickUpdate() {
        let id = map.id
        let name = tfName.text == nil ? "" : tfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let side = tfSide.text == nil ? "" : tfSide.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let latitude = Double(tfLatitude.text ?? "")
        let longitude = Double(tfLongitude.text ?? "")
        let type = tfType.text == nil ? "" : tfType.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let level = tfLevel.text == nil ? "" : tfLevel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let tidal = tfTidal.text == nil ? "" : tfTidal.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let direction = tfDirection.text == nil ? "" : tfDirection.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let map = Map(id: id, name: name, side: side, latitude: latitude, longitude: longitude, type: type, direction: direction, level: level, tidal: tidal)
        
        var requestParam = [String: String] ()
        requestParam["action"] = "mapUpdate"
        requestParam["map"] = try! String(data: JSONEncoder().encode(map), encoding: .utf8)
        if self.imageUpload != nil {
            requestParam["imageBase64"] = self.imageUpload!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                if count != 0 {
                                    self.navigationController?.popViewController(animated: true)
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
    
    
    @IBAction func didEndOnExit(_ sender: Any) {
    }
    
}

extension MapUpdateTableViewController {
    func hideKeyboard() {
        tfName.resignFirstResponder()
        tfSide.resignFirstResponder()
        tfLatitude.resignFirstResponder()
        tfLongitude.resignFirstResponder()
        tfType.resignFirstResponder()
        tfLevel.resignFirstResponder()
        tfTidal.resignFirstResponder()
        tfDirection.resignFirstResponder()
    }
}

