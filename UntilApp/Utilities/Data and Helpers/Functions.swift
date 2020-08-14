//
//  Functions.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/14/20.
// Used for system wide functions

import Foundation


func filePath(forKey key: String) -> URL? {
    let fileManager = FileManager.default
    guard let documentURL = fileManager.urls(for: .documentDirectory,
                                            in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
    
    return documentURL.appendingPathComponent(key + ".png")
}


//used to remove an image based on the eventUUID
func removeExistingImage(eventUUID: String) {
    let fileManger = FileManager.default
    let pathToFile = filePath(forKey: eventUUID)
    if fileManger.fileExists(atPath: pathToFile!.absoluteString){
        do{
            //file exists
            try fileManger.removeItem(atPath: pathToFile!.absoluteString)
        }catch let error {
            print("error occurred, here are the details:\n \(error)")
        }
    }

}
