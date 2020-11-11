//
//  MapInsertTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by SAM on 2020/11/5.
//

import UIKit
import CoreLocation

class MapInsertTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    var image: UIImage?
    
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
            image = mapImage
            ivMap.image = mapImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickInsert(_ sender: Any) {
        let name = tfName.text == nil ? "" : tfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let side = tfSide.text == nil ? "" : tfSide.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let latitude = Double(tfLatitude.text ?? "")
        let longitude = Double(tfLongitude.text ?? "")
        let type = tfType.text == nil ? "" : tfType.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let level = tfLevel.text == nil ? "" : tfLevel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let tidal = tfTidal.text == nil ? "" : tfTidal.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let direction = tfDirection.text == nil ? "" : tfDirection.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let map = SurfPoint(name: name, side: side, latitude: latitude, longitude: longitude, type: type, direction: direction, level: level, tidal: tidal)
        
        var requestParam = [String: String]()
        requestParam["action"] = "mapInsert"
        requestParam["map"] = try! String(data: JSONEncoder().encode(map), encoding: .utf8)
        
        if self.image != nil {
            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
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
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

}

extension MapInsertTableViewController {
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
