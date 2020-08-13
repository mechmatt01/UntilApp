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
    
    let imagePicker = UIImagePickerController()
    var userImagePicked: Data?
    
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
        eventDatePicker.minimumDate = Date();
        print(Date().description)
        self.eventName.delegate = self
        self.hideKeyboardWhenTappedAround()
        eventName.addTarget(self, action: #selector(clearText), for: .touchDown);
        if(isInEditStage) {
            self.eventDatePicker.date = previousEventDate!
            self.eventName.text = previousEventName!
        }
        
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    

    @IBAction func createTheEvent(_ sender: Any) {
        if (!isInEditStage) {
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
            
            self.navigationController?.popViewController(animated: true)
        } else {
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
            popTo(HomeViewController.self)
            
        }
        
    }
    
    func popTo<T>(_ vc: T.Type) {
          let targetVC = navigationController?.viewControllers.first{$0 is T}
          if let targetVC = targetVC {
             navigationController?.popToViewController(targetVC, animated: true)
          }
       }
    
    @IBAction func backToMainMenu(_ sender: Any) {
        popTo(HomeViewController.self)
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
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }

    
    private func removeExistingImage(eventUUID: String) {
        let fileManger = FileManager.default
        let pathToFile = filePath(forKey: eventUUID)
        if fileManger.fileExists(atPath: pathToFile!.absoluteString){
            do{
                print("yes file does eist")
                try fileManger.removeItem(atPath: pathToFile!.absoluteString)
            }catch let error {
                print("error occurred, here are the details:\n \(error)")
            }
        }
        return

    }

}


