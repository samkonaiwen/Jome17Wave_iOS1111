//
//  InsertGroupTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by Karena on 2020/11/13.
//

import UIKit

class InsertGroupTableViewController: UITableViewController {
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var captainLabel: UILabel!
    @IBOutlet weak var groupTitleTextField: UITextField!
    @IBOutlet weak var groupLimitTextField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    var member: Member?
    var insertGruop: PersonalGroup?
    var locations = [Map]()
    var selectLocation = ""
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocations()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        /* 即使iPhone語言設為繁體中文，地區設為台灣，Locale.current仍為en_TW，導致date picker(Locale設為default)無法切換成中文日期。只好檢查Locale.current文字有包含TW者就將date picker的Locale設為zh_TW */
        print("Locale.current: \(Locale.current)")
        if Locale.current.description.contains("TW") {
            datePicker.locale = Locale(identifier: "zh_TW")
        }
        
        // 增加一個觸控事件
        let tap = UITapGestureRecognizer(target: self, action:#selector(InsertGroupTableViewController.hideKeyboard(_:)))
        tap.cancelsTouchesInView = false

        // 加在最基底的 self.view 上
        self.view.addGestureRecognizer(tap)
    }
    
    // 按空白處會隱藏編輯狀態
    @objc func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let member = member{
            captainLabel.text = member.account
            insertGruop?.memberId = member.memberId
            insertGruop?.nickname = member.nickname
            insertGruop?.memberGender = member.gender
        }
    }
    
    @IBAction func unwindToInsertGroupView(_ unwindSegue: UIStoryboardSegue) { }
    
    
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
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: datePicker.date)
        insertGruop?.assembleTime = dateString
    }
    
    func loadLocations() {
        let url = URL(string: "\(common_url)SURF_POINTServlet")
        let requestParam = ["action":"getAll"]
        executeTask(url!, requestParam) { (data, response, error) in
            if let data = data,
               let result = try? JSONDecoder().decode([Map].self, from: data){
                    self.locations = result
                
                    DispatchQueue.main.async {
                        //pickerView重整？
                    }
            }
        }
    }
}

extension InsertGroupTableViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.setPickerView()
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setPickerView() {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
//        //初始化pickerView上方的toolBar
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = .systemBlue
//        toolBar.sizeToFit()
//        //加入toolbar的按鈕跟中間的空白
//        let doneButton = UIBarButtonItem(title: "確認", style: .plain, target: self, action: #selector(submit))
//        //將doneButton設定跟pickerView一樣的tag，submit方法裡可以比對要顯示哪個textField的text
//        doneButton.tag = pickerView.tag
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        //設定toolBar可以使用
//        toolBar.isUserInteractionEnabled = true
//
//        //初始化textField，要先加入subView，才能設定他的inputView跟inputAccessoryView
//        locationTextField = UITextField(frame: CGRect.zero)
//        view.addSubview(locationTextField)
        locationTextField.inputView = pickerView
//        locationTextField.inputAccessoryView = toolBar
        //彈出pickerField
        locationTextField.becomeFirstResponder()
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
//        setColor(row: row)
        let location = locations[row]
        insertGruop?.surfName = location.name
        insertGruop?.surfPointId = row + 1
        locationTextField.text = location.name
        
    }
    
    
}

