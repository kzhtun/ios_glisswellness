//
//  CheckInViewController.swift
//  gliss
//
//  Created by Kyaw Zin on 07/09/2024.
//

import UIKit
import QRScanner

class CheckInViewController: UIViewController {
    let App = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var CheckInLayout: UIView!
    @IBOutlet weak var btnCheckIn: UIButton!
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    
    @IBAction func btnCheckIn_TouchDown(_ sender: Any) {
        let qr = QRScannerViewController()
        qr.squareView.lineColor = UIColor.red
        let item = UIBarButtonItem(title: "Photo album", style: UIBarButtonItem.Style.plain, target: qr, action: #selector(QRScannerViewController.openAlbum))
        qr.navigationItem.rightBarButtonItem = item
        qr.delegate = self
        App.CheckType = "IN"
        present(qr, animated: true, completion: nil)
       
    }
    
    @IBAction func btnCheckOut_TouchDown(_ sender: Any) {
        let qr = QRScannerViewController()
        qr.squareView.lineColor = UIColor.red
        let item = UIBarButtonItem(title: "Photo album", style: UIBarButtonItem.Style.plain, target: qr, action: #selector(QRScannerViewController.openAlbum))
        qr.navigationItem.rightBarButtonItem = item
        qr.delegate = self
        App.CheckType = "OUT"
        present(qr, animated: true, completion: nil)
    }
    
    @IBAction func btnExit_TouchDown(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
    }
    
    func dismissParentViewController(){
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIStyle()

    }
    
    func setUIStyle(){
        CheckInLayout.layer.cornerRadius = 24
    
        
        btnCheckIn.layer.cornerRadius = 23
        btnCheckIn.layer.masksToBounds = true
        
        btnCheckOut.layer.cornerRadius = 23
        btnCheckOut.layer.masksToBounds = true
        
        btnExit.layer.cornerRadius = 23
        btnExit.layer.masksToBounds = true
    }

    func populateCompleteDialog(result: String){
        let vc = CompleteDialog()
        
        vc.result = result
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated:  true, completion: nil)
    }
}


extension CheckInViewController:QRScannerDelegate{
    func qrScannerDidFail(scanner: QRScannerViewController, error: QRScannerError) {
        let alert = UIAlertController(title: "Fail!", message: String(describing: error), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: nil))
        scanner.present(alert, animated: true, completion: nil)
    }
    
    func qrScannerDidSuccess(scanner: QRScannerViewController, result: String) {
        print("success",result)
        scanner.dismiss(animated: true)
        populateCompleteDialog(result: result)
//        let alert = UIAlertController(title: "Success!", message: result, preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: nil))
//        scanner.present(alert, animated: true, completion: nil)
       
    }
}

