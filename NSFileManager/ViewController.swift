//
//  ViewController.swift
//  NSFileManager
//
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    let fileManager = FileManager()
    let tempDirectory = NSTemporaryDirectory()
    let fileName = "customFile.txt"
    var folderPath = ""
    
    let docDir = NSURL(fileURLWithPath:
                        NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask,
                                                            true)[0])
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
//        guard let uPath = path else {
//            return
//        }
//        print(uPath)
//        addressLabel.text = uPath
    }
    
    func validateCatalog() -> String? {
        do {
            let objectsInCatalog = try fileManager.contentsOfDirectory(atPath: tempDirectory)
            
            let objects = objectsInCatalog
            
            if objects.count > 0 {
                if objects.first == fileName {
                    print("customFile.txt found")
                    return objects.first
                } else {
                    print("There's no file you're interested in")
                    return nil
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
   
    
    @IBAction func createAFileAction(_ sender: UIButton) {
        let filePath = (tempDirectory as NSString).appendingPathComponent(fileName)
        let fileContent = "Some Text Here"
        
        do {
            try fileContent.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
                addressLabel.text = "File customFile.txt was successfully created and now it's located at \(filePath)"
            } catch let error as NSError {
                addressLabel.text = "Could't create file customFile.txt because of error: \(error)"
            }
    }
    
    
    @IBAction func checkTmp(_ sender: UIButton) {
        let filesCatalog = validateCatalog() ?? "Nothing"
        addressLabel.text = filesCatalog
    }
    
    
    @IBAction func createFolder(_ sender: UIButton) {
        let docsFolderPath = NSURL(fileURLWithPath:
                                    NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                        .userDomainMask,
                                                                        true)[0])
        
        let logPath = docsFolderPath.appendingPathComponent("CustomFolder")
        
        guard  let unwrLogPath = logPath else {
            return
        }
        
        do {
            try FileManager.default.createDirectory(atPath: unwrLogPath.path, withIntermediateDirectories: true, attributes: nil)
            addressLabel.text = "\(unwrLogPath)"
            print(unwrLogPath)
        } catch let error as NSError {
            addressLabel.text = "Can't create a directory, \(error)"
        }
    }
    
    @IBAction func folderExistCheck(_ sender: UIButton) {
        let directories : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
                        
        if directories.count > 0 {
            let directory = directories[0] //Директория с документами
                folderPath = directory.appendingFormat("/" + fileName)
                print("Local path = \(folderPath)")
            } else {
                print("Could not find local directory for this folder")
                return
                }
                
                // Проверка, есть ли файл
        if fileManager.fileExists(atPath: folderPath) {
                addressLabel.text = "Folder exists - \(folderPath)"
        } else {
            addressLabel.text = "Folder does not exist"
        }
    }
    
    @IBAction func readFileButtonAction(_ sender: UIButton) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                let contentsOfFile = try NSString(contentsOf: fileURL, encoding: String.Encoding.utf8.rawValue)
                addressLabel.text = "content of the file is: \(contentsOfFile)"
            } catch let error as NSError {
                addressLabel.text = "Error! \(error)"
            }
        }
    }
    
    @IBAction func writeFileButtonACtion(_ sender: UIButton) {
        let someText = "Hello file!"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                try someText.write(to: fileURL, atomically: true, encoding: .utf8)
                addressLabel.text = "'\(someText)' added to '\(fileName)'"
            } catch {
                addressLabel.text = "Can't write"
            }
        }
    }
    
}
