//
//  InsertGroupTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/13.
//

import UIKit

class InsertGroupTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var captainLabel: UILabel!
    @IBOutlet weak var groupTitleTextField: UITextField!
    @IBOutlet weak var groupLimitTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var member: Member?
    var insertGruop: PersonalGroup?
    var locations = [Map]()
    var location: Map?
    var selectLocation = ""
    var image: UIImage?
    var dateString: String?
    var surfPointId: Int = 0
    var surfName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocations()
        setPickerView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        /* 即使iPhone語言設為繁體中文，地區設為台灣，Locale.current仍為en_TW，導致date picker(Locale設為default)無法切換成中文日期。只好檢查Locale.current文字有包含TW者就將date picker的Locale設為zh_TW */
        print("Locale.current: \(Locale.current)")
        if Locale.current.description.contains("TW") {
            datePicker.locale = Locale(identifier: "zh_TW")
        }
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let member = member{
            captainLabel.text = member.account
//            insertGruop?.memberId = member.memberId
//            insertGruop?.nickname = member.nickname
//            insertGruop?.memberGender = member.gender
        }
    }
    
    @IBAction func unwindToInsertGroupView(_ unwindSegue: UIStoryboardSegue) { }
    
    func setPickerView() {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        locationTextField.inputView = pickerView
        let tap = UITapGestureRecognizer(target: self, action: #selector(closedKeybored))
        view.addGestureRecognizer(tap)
    }
    
    @objc func closedKeybored(){
        self.view.endEditing(true)
    }
    
    
    // MARK: - Table view data source


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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
            let controller = segue.destination as? SelectMemberViewController
            controller?.selectedMember = member
    }
    
    
    @IBAction func selectDateDatePicker(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = datePicker.locale
        print("Locale.current: \(Locale.current)")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
        dateString = dateFormatter.string(from: datePicker.date)
        
        
    }
    
    /* 點擊虛擬鍵盤上return鍵會隱藏虛擬鍵盤 */
    @IBAction func pressedKeyboardReturn(_ sender: Any) { }
    
    func loadLocations() {
        let url = URL(string: "\(common_url)SURF_POINTServlet")
        let requestParam = ["action":"getAll"]
        executeTask(url!, requestParam) { (data, response, error) in
            if let data = data,
               let result = try? JSONDecoder().decode([Map].self, from: data){
                    self.locations = result
                
                    DispatchQueue.main.async {
                        self.locationTextField.reloadInputViews()
                    }
            }
        }
    }
    
    /*照片按鈕*/
    @IBAction func pressedTakeAPicture(_ sender: Any) {
        imagePicker(type: .camera)
    }
    @IBAction func pressedPickAPicture(_ sender: Any) {
        imagePicker(type: .photoLibrary)
    }
    /*照片處理*/
    func imagePicker(type: UIImagePickerController.SourceType) {
//        hideKeyboard()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = type
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = image
            groupImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fastWord(_ sender: Any) {
        groupTitleTextField.text = "衝浪衝浪吧"
        groupLimitTextField.text = "4"
        memoTextView.text = "歡迎一起來玩"
    }
    
    /*完成按鈕*/
    @IBAction func pressedDone(_ sender: Any) {
        
        if member == nil || groupTitleTextField.text == "" || dateString == "" || location == nil || groupLimitTextField.text == "" || memoTextView.text == ""{
            showAlert(word: "您尚有資料未選擇")
        }else{
            
            let title: String = groupTitleTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let now = Date()
            let formatter = DateFormatter()
//            let assembleTimeFormatter = DateFormatter()
            if Locale.current.description.contains("TW") {
                formatter.locale = Locale(identifier: "zh_TW")
//                assembleTimeFormatter.locale = Locale(identifier: "zh_TW")
            }
            formatter.dateFormat = "yyyyMMddHHmmssss"
//            assembleTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let groupId = formatter.string(from: Date())
            let groupName = title
            let assembleTime = dateString
            let surfPointId = self.surfPointId
            let surfName = self.surfName
            let groupLimit = Int(groupLimitTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let gender = member?.gender
            let notice = memoTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let attenderStatus = 1
            let role = 1
            let memberId = member?.memberId
            let nickname = member?.nickname
            var newGroup = PersonalGroup(groupId: groupId, groupName: groupName, assembleTime: assembleTime, groupEndTime: nil, signUpEnd: nil, groupLimit: groupLimit, gender: nil, notice: notice, memberId: memberId!, nickname: nickname!, memberGender: gender, attenderId: nil, attenderStatus: attenderStatus, role: role, surfName: surfName, surfPointId: surfPointId, joinCountNow: nil, groupStatus: 1)
            insertGroup(newGroup: newGroup)
        }
        
    }
    
    //showAlert
    func showAlert(word: String) {
        let alertController = UIAlertController(title: word, message: "記得在檢查一下唷！", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "好", style: UIAlertAction.Style.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //新增活動
    func insertGroup(newGroup: PersonalGroup?) {
        let url = URL(string: "\(common_url)jome_member/GroupOperateServlet")
        var requestParam = [String: Any]()
        requestParam["action"] = "creatAGroupForIOS"
        requestParam["insertGroup"] = try! String(data: JSONEncoder().encode(newGroup), encoding: .utf8)
        
        if self.image != nil {
            requestParam["imageBase64"] = self.image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        }
        executeTask(url!, requestParam) { (data, response, error) in
            
            if let data = data,
               let result = try? JSONDecoder().decode(changeResponse.self, from: data){
                let resultCode = result.resultCode
                DispatchQueue.main.async {
                    if resultCode > 0{
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showAlert(word: "新增失敗")
                    }
                }
            }
            
        }
    }
}

extension InsertGroupTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    // UIPickerViewDataSource
    /* 希望picker view一次顯示幾個欄位的選項 */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    /* 產生picker view時會自動呼叫此方法以取得選項數 */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        locations.count
    }
    
    // UIPickerViewDelegate
    /* picker view顯示時會自動呼叫此方法以取得欲顯示的選項名稱 */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        location = locations[row]
        surfName = location?.name
        surfPointId = row + 1
        locationTextField.text = location?.name
    }
}
