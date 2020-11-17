//
//  MemberDetailTableViewController.swift
//  Jome17Wave_iOS
//
//  Created by 洪展彬 on 2020/11/16.
//

import UIKit

class MemberDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet var memberLabels: [UILabel]!
    @IBOutlet var showCells: [UITableViewCell]!
    
    var joMember: JomeMember?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let member = joMember else {
            print("joMember is nil!")
            return }
        
        memberLabels[0].text = transGender2Icon(member.gender!)
        memberLabels[1].text = member.memberId
        memberLabels[2].text = member.account
        memberLabels[3].text = member.password
        memberLabels[4].text = member.nickname
        memberLabels[5].text = member.phoneNumber
//        memberLabels[6].text =
        
        
        

        
    }
    
    func transGender2Icon(_ gender: Int) -> String {
        var icon: String = ""
        switch gender {
        case 1:
            icon = String("🙎‍♂️")
        case 2:
            icon = String("🙎‍♀️")
        case 3:
            icon = String("😁")
        default: break
            
        }
        return icon
    }
    







}
