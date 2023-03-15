//
//  ViewController.swift
//  randomDogApp
//
//  Created by Emre on 14.03.2023.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //MARK: VARIABLES
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pickerLabel: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var getBtn: UIButton!
    var dogName = [String]()
    var tempDogName = ""
    
    
    //MARK: FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        tempDogName = "https://dog.ceo/api/breeds/image/random"
        getData()
        pickerLabel.dataSource = self
        pickerLabel.delegate = self
        view.addSubview(pickerLabel)
        getBtn.layer.cornerRadius = 12
    }

    @IBAction func getBtnClicked(_ sender: UIButton) {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.white.cgColor
        sender.layer.add(colorAnimation, forKey: "ColorPulse")
        colorAnimation.duration = 0.5
        
        let url = URL(string: tempDogName)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }else{
                do{
                    let jsonResponse =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                    let imageURL = URL(string: jsonResponse["message"] as! String)
                    if let imageData = try? Data(contentsOf: imageURL!){
                        if let image = UIImage(data: imageData){
                            DispatchQueue.main.async{
                                self.imageView.image = image
                            }
                        }
                    }
                }catch{
                    print("Error")
                }
            }
        }
            task.resume()
    }
    
    func getData(){
        let url = URL(string: "https://dog.ceo/api/breeds/list/all")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }else{
                do{
                    let jsonResponse =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                    let dog = jsonResponse["message"] as! Dictionary<String,Any>
                    self.dogName = Array(dog.keys).sorted()
                    self.insertFirstElementInSortedArray("random", inArray: &self.dogName)
                    DispatchQueue.main.async {
                        self.pickerLabel.reloadAllComponents()
                    }
                }catch{
                    print("Error")
                }
            }
        }
        task.resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return dogName.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return dogName[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameLabel.text = dogName[row].capitalized
        if dogName[row] == "random"{
            tempDogName = "https://dog.ceo/api/breeds/image/random"
        }else{
            tempDogName = "https://dog.ceo/api/breed/\(dogName[row])/images/random"
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = UILabel()
            label.textColor = UIColor.white
            label.text = dogName[row]
            label.font = .systemFont(ofSize: 25)
            label.textAlignment = .center
            return label
    }
    func insertFirstElementInSortedArray(_ element: String, inArray array: inout [String]) {
        var index = 0
        while index < array.count && array[index] < element {
            index += 1
        }
        array.insert(element, at: index)
        if let firstElement = array.first, firstElement != element {
            array.removeFirst()
            array.insert(element, at: 0)
        }
    }
}


