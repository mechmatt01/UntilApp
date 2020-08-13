//
//  CustomCollectionViewCell.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/11/20.
//

import UIKit

@IBDesignable class CustomCollectionViewCell: UICollectionViewCell {
    var event: Event? {
        didSet {
            let imageFile = self.filePath(forKey: event!.id.uuidString);
            if let fileData = FileManager.default.contents(atPath: imageFile!.path) {
                let image = UIImage(data: fileData)
                let imageView = UIImageView(frame: contentView.bounds)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.image = image
                imageView.center = self.contentView.center
                imageView.layer.zPosition = -1
                self.contentView.addSubview(imageView)
            }
            self.eventName.text = event!.eventName
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
    }
    let formatter = DateFormatter()
    let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib();

    }
    
    
    @objc func update() {
        formatter.dateFormat = "yyyy-MM-dd"
        
        let currentdate = Date()
        let itemsOfDate = Calendar.current.dateComponents(components, from: currentdate, to: event!.eventTime)
        
        daysLabel.text = "\(itemsOfDate.day!)"
        hoursLabel.text = "\(itemsOfDate.hour!)"
        minutesLabel.text = "\(itemsOfDate.minute!)"
        secondsLabel.text = "\(itemsOfDate.second!)"
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 10;
        self.clipsToBounds = true;

    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
}
