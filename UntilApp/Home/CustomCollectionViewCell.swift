//
//  CustomCollectionViewCell.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/11/20.
//

import UIKit

@IBDesignable class CustomCollectionViewCell: UICollectionViewCell {
    //checks that event acutally eists
    var event: Event? {
        didSet {
            let imageFile = filePath(forKey: event!.id.uuidString);
            if let fileData = FileManager.default.contents(atPath: imageFile!.path) {
                let image = UIImage(data: fileData)
                let imageView = returnImageView(image: image!)
                self.contentView.addSubview(imageView)
                
                //change color based on light or dark image
                let averageRed, averageGreen, averageBlue, averageAlpha: CGFloat
                (averageRed, averageGreen, averageBlue, averageAlpha) = image!.averageColor!.rgba as (CGFloat, CGFloat, CGFloat, CGFloat)
                if (averageRed > 0.5 && averageGreen > 0.5 && averageBlue > 0.5 && averageAlpha > 0.5) {
                    //mostly white image
                    let labels = [eventName, daysLabel, hoursLabel, minutesLabel, secondsLabel, daysMinutesAndSecondsLabel];
                    labels.forEach{
                        $0!.textColor = .black
                    }
                }
            } else {
                //no image file
                self.backgroundColor = .green
            }
            self.eventName.text = event!.eventName
            let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
        }
    }
    let formatter = DateFormatter()
    let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var daysMinutesAndSecondsLabel: UILabel!
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
    
    //returns an image that will become the background
    func returnImageView(image: UIImage) -> UIImageView{
        let imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.center = self.contentView.center
        imageView.layer.zPosition = -1
        return imageView

    }
}
