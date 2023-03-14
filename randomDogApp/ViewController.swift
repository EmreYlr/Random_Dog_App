//
//  ViewController.swift
//  randomDogApp
//
//  Created by Emre on 14.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getBtnClicked(_ sender: UIButton) {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
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
    
}

