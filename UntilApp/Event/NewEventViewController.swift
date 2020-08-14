//
//  NewEventViewController.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/7/20.
//

import UIKit
class NewEventViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var backgroundPhoto: UIImageView!
    @IBOutlet weak var newEventLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    var userImagePicked: Data?
    
    
    //makes sure to pass in edit stage if through a segue
    var isInEditStage = false;
    var previousEventName: String?;
    var previousEventDate: Date?;
    var eventId: UUID?;
    
    @IBAction func loadImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventName.delegate = self
        self.hideKeyboardWhenTappedAround()
        eventName.addTarget(self, action: #selector(clearText), for: .touchDown);
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventDatePicker.minimumDate = Date();
        eventDatePicker.setValue(UIColor.white, forKey: "textColor")
        if(isInEditStage) {
            self.eventDatePicker.date = previousEventDate!
            self.eventName.text = previousEventName!
            self.newEventLabel.text = "Edit Event";
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

    @IBAction func createTheEvent(_ sender: Any) {
        if (!isInEditStage) {
            //creating a new event
            let uniqueIdentifier = UUID()
            if let pngRepresentation = userImagePicked{
                let imageFilePath = filePath(forKey: uniqueIdentifier.uuidString)
                do {
                    try pngRepresentation.write(to: imageFilePath!, options: .atomic)
                    print("file wrote")
                } catch let err {
                    print(err)
                    
                }
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "addAnEvent"), object: self, userInfo: ["eventName": eventName.text!, "eventTime": eventDatePicker.date, "uuid": uniqueIdentifier])
            self.dismiss(animated: true, completion: nil)
        } else {
            //editing existing event
            removeExistingImage(eventUUID: eventId!.uuidString)
            if let pngRepresentation = userImagePicked{
                let imageFilePath = filePath(forKey: eventId!.uuidString)
                do {
                    try pngRepresentation.write(to: imageFilePath!, options: .atomic)
                    print("file wrote")
                } catch let err {
                    print(err)
                    
                }
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "changeAnEvent"), object: self, userInfo: ["eventName": eventName.text!, "eventTime": eventDatePicker.date, "uuid": eventId ?? ""])
            
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @IBAction func backToMainMenu(_ sender: Any) {
        
        //runs both depending on the context of how the user managed to view this controller
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @objc func clearText() {
        if(self.eventName.text == "Event Name") {
            self.eventName.text = "";
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            backgroundPhoto.contentMode = .scaleAspectFit
            backgroundPhoto.image = pickedImage
            
            userImagePicked = pickedImage.pngData()            
        }
     
        dismiss(animated: true, completion: nil)
    }

    
    

}


