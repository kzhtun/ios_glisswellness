//
//  RegisterViewController.swift
//  gliss
//
//  Created by Kyaw Zin on 07/09/2024.
//

import UIKit
import AEOTPTextField

class RegisterViewController: UIViewController {
    let App = UIApplication.shared.delegate as! AppDelegate
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    var OTP: String = ""
    var countdownTimer: Timer!
    var totalTime = 60
   
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var registerSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var OTPLayout: UIView!
    
    @IBOutlet weak var txtOTP: AEOTPTextField!
  
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var btnVerify: UIButton!
    
    @IBOutlet weak var RegisterLayout: UIView!
    
    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtMobile: UITextField!
    

    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBAction func btnVerify_TouchDown(_ sender: Any) {
        registerSpinner.isHidden = false
      
        if(OTP == txtOTP.text){
           callUpdateUser()
        }else{
            let alert = UIAlertController(title: Bundle.applicationName, message: "Invalid OTP", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] (action: UIAlertAction!) in
                txtOTP.clearOTP()
               endTimer()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func callUpdateUser(){
        
        if(txtMobile.text!.isEmpty){
            txtMobile.text = " "
        }
            
        Router.sharedInstance().UpdateUser(username: txtUserName.text!, email: txtEmail.text!, mobile: txtMobile.text!, deviceid: getDeviceID(), fcmtoken: "-") { [self] response in
            if(response.responsemessage?.uppercased() == "SUCCESS"){
                let alert = UIAlertController(title: Bundle.applicationName, message: "Registered successful", preferredStyle: UIAlertController.Style.alert)
              
                   callValidateDevice()
            }
        } failure: { error in
            print(error.description)
         
        }
    }
    
    func callValidateDevice(){
        Router.sharedInstance().ValidateDevice(deviceid: getDeviceID()) { [self] response in
            if(response.responsemessage?.uppercased() == "SUCCESS"){
                App.CurrentUser = response.user
                let vc = self.storyBoard.instantiateViewController(withIdentifier: "CheckInViewController") as! CheckInViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
           }
        } failure: { error in
            print(error.description)
        }

    }
    
    
    func validateInputs()->Bool{
        if(txtUserName.text!.isEmpty){
            let confirmAlert = UIAlertController(title: Bundle.applicationName, message: "User name can not be left blank.", preferredStyle: UIAlertController.Style.alert)
            
            confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(confirmAlert, animated: true, completion: nil)
            return false;
        }
        
        if(txtEmail.text!.isEmpty){
            let confirmAlert = UIAlertController(title: Bundle.applicationName, message: "Email can not be left blank.", preferredStyle: UIAlertController.Style.alert)
            
            confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(confirmAlert, animated: true, completion: nil)
            return false;
        }
        
        if(!isValidEmail(email: txtEmail.text!)){
            let confirmAlert = UIAlertController(title: Bundle.applicationName, message: "Invalid email address", preferredStyle: UIAlertController.Style.alert)
            
            confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            }))
            self.present(confirmAlert, animated: true, completion: nil)
            return false;
        }
        
        return true
    }
  
    func callSendOTP(){
        startTimer()
        Router.sharedInstance().SendOTP(username: txtUserName.text!, email: txtEmail.text!) { response in
            if(response.responsemessage?.uppercased() == "SUCCESS"){
                self.OTP = response.token
            }else{
                self.OTP = ""
            }
        } failure: { error in
            print(error.description)
        }
    }
    
    func callValidateUser(){
        btnSubmit.setEnabled(enabled: false)
        
        spinner.isHidden = false
        
        Router.sharedInstance().ValidateUser(username: txtUserName.text!.trimmingCharacters(in: .whitespacesAndNewlines))
        { [self] response in
            if(response.responsemessage?.uppercased() == "SUCCESS"){
            
                // Layout show/hide
                self.RegisterLayout.isHidden = true
                self.OTPLayout.isHidden = false
                registerSpinner.isHidden = true
              
                btnSubmit.setEnabled(enabled: true)
                
                callSendOTP()
            }else{
                let confirmAlert = UIAlertController(title: Bundle.applicationName, message: "Invalid username", preferredStyle: UIAlertController.Style.alert)
                
                confirmAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    let startPosition = self.txtUserName.beginningOfDocument
                    let endPosition = self.txtUserName.endOfDocument
                    self.txtUserName.selectedTextRange = self.txtUserName.textRange(from: startPosition, to: endPosition)
                }))
                btnSubmit.setEnabled(enabled: true)
                
                self.present(confirmAlert, animated: true, completion: nil)
            }
        } failure: { error in
            print(error.description)
            self.btnSubmit.setEnabled(enabled: true)
            self.spinner.isHidden = true
        }
    }

    
    
    @IBAction func btnSubmit_TouchDown(_ sender: Any) {
        
        if(validateInputs()){
            callValidateUser()
        }
    }
    
    func setUIStyle(){
        print("setStyle")
        self.spinner.isHidden = true
        
        // Register Layout
        RegisterLayout.layer.cornerRadius = 24
       // RegisterLayout.layer.masksToBounds = true
        
        txtUserName.layer.cornerRadius = 16
        txtUserName.layer.masksToBounds = true
        txtUserName.setLeftPaddingPoints(8)
        
        txtEmail.layer.cornerRadius = 16
        txtEmail.layer.masksToBounds = true
        txtEmail.setLeftPaddingPoints(8)
        
        txtMobile.layer.cornerRadius = 16
        txtMobile.layer.masksToBounds = true
        txtMobile.setLeftPaddingPoints(8)
        
        btnSubmit.layer.cornerRadius = 23
        btnSubmit.layer.masksToBounds = true
        
        //Normal
//        btnSubmit.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        btnSubmit.setTitle("Button",for: .normal)
//        btnSubmit.setTitleColor(UIColor.white,for: .normal)
//        
//        //Press
//        btnSubmit.setTitle("Pressed",for: .highlighted)
//        btnSubmit.setTitleColor(UIColor.blue,for: .highlighted)
//        //Disabled
//        btnSubmit.setTitle("Disabled",for: .disabled)
//        btnSubmit.setTitleColor(UIColor.lightGray,for: .disabled)
     
        
        // OTP Layout
        OTPLayout.layer.cornerRadius = 24
        txtOTP.otpDelegate = self
        
        // custom otp properties
        txtOTP.otpDelegate = self
        txtOTP.otpFontSize = 20
       // txtOTP.otpTextColor =
        txtOTP.otpCornerRaduis = 10
        txtOTP.otpFilledBorderColor = .blue
       // txtOTP.otpFilledBorderWidth = 30
        txtOTP.configure(with: 4)
        
        btnVerify.layer.cornerRadius = 23
        btnVerify.layer.masksToBounds = true
        
        // Layout Show/Hide
        RegisterLayout.isHidden = false
        RegisterLayout.alpha = 1
        OTPLayout.isHidden = true
       
        
        
        // set Gesture
        self.timerLabel.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.timerLabelResend))
        self.timerLabel.addGestureRecognizer(tap)
        
        
        // TESTING DATA
//        txtUserName.text = "Cloris Won Siew Lin"
//        txtEmail.text = "kzhtun@gmail.com"
        
        
    }
    
    @objc func timerLabelResend(_ gestureRecognizer: UITapGestureRecognizer) {
        if(timerLabel.text?.uppercased() == "RESEND"){
            callSendOTP()
           
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUIStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Register Screen Loaded")
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


extension RegisterViewController: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print(code)
    }
    
    
    func startTimer() {
        endTimer()
        let fire = Date().addingTimeInterval(1)
        let deltaT : TimeInterval = 1.0
        var runningTime = self.totalTime
        
        countdownTimer = nil
        
        self.countdownTimer = Timer(fire: fire, interval: deltaT, repeats: true, block: { (t: Timer) in
            self.timerLabel.text = "Your OTP will expire in \(runningTime) seconds."
            if runningTime != 0 {
                runningTime -= 1
            } else {
                self.endTimer()
                self.timerLabel.text = "Resend"
            }
        })
        
        RunLoop.main.add(self.countdownTimer!, forMode: RunLoop.Mode.common)
    }
   

    func endTimer() {
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil
        self.timerLabel.text = "Resend"
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }

}
