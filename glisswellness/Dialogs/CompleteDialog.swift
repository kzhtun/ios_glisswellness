//
//  CompleteDialog.swift
//  gliss
//
//  Created by Kyaw Zin on 10/09/2024.
//

import UIKit


class CompleteDialog: UIViewController {
    let App = UIApplication.shared.delegate as! AppDelegate
   
 
    var result: String = ""
   

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var completeLayout: UIView!
    
    @IBOutlet weak var lblSiteName: UILabel!
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var txtRemarks: UITextView!
  
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnComplete: UIButton!
    
    func callSaveAttendance(){
        let siteInfo = result.components(separatedBy: ",")
        
        var remarkStr: String
        remarkStr = txtRemarks.text ?? ""
        
        Router.sharedInstance().SaveAttendance(cocode: App.CurrentUser!.cocode, branchid: siteInfo[0] , branchcode: siteInfo[1], staffid: App.CurrentUser!.id, staffname:  App.CurrentUser!.name, checktype: App.CheckType, location: App.fullAddress, remarks: remarkStr.replaceEscapeChr) { response in
            
            if(response.responsemessage?.uppercased() == "SUCCESS"){
               
               // self.dismiss(animated: true)
                
                let alert = UIAlertController(title: Bundle.applicationName, message: "\(self.App.CheckType=="IN" ? "Check in" : "Check out") successful", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    alert.dismiss(animated: true)
                    self.dismiss(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
              
               
            }
        } failure: { error in
            print(error.description)
        }
    }
    
    
    
    @IBAction func btnComplete_TouchDown(_ sender: Any) {
        callSaveAttendance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -200 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
             if touch?.view == self.parentView {
                 self.dismiss(animated: true, completion: nil)
            }
    }
    
    
    override func viewDidLayoutSubviews() {
        setUIStyle()
        populateInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func setUIStyle(){
        completeLayout.layer.cornerRadius = 20
     
        btnComplete.layer.cornerRadius = 23
        btnComplete.layer.masksToBounds = true
    }
    
    func populateInfo(){
        let currentDate = Date()
        let formatter = DateFormatter()
      
        let siteInfo = result.components(separatedBy: ",")
        
        lblSiteName.text = siteInfo[1]
        lblName.text = App.CurrentUser!.name
        
        formatter.dateFormat =  "MMM dd,yyyy"
        lblDate.text = formatter.string(from: currentDate)
        
        formatter.dateFormat =  "HH:mm:ss"
        lblTime.text = formatter.string(from: currentDate)
        
        lblLocation.text = App.fullAddress
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




