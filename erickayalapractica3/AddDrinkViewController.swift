//
//  AddDrinkViewController.swift
//  erickayalapractica3
//
//  Created by Erick Ayala Delgadillo on 06/04/22.
//

import UIKit
import AVFoundation

class AddDrinkViewController: UIViewController , UIImagePickerControllerDelegate & UINavigationControllerDelegate {
   
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var directions: UITextView!
    @IBOutlet weak var image: UIImageView!
    let scroll = UIScrollView()
    
    var imagePath: String!
    
    var datos = Drink()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }

    @IBAction func save(_ sender: Any) {
        
        var mensaje = ""
        
        if name.text != "" && ingredients.text != "" && directions.text != "" {
            
            var tmp = [String:String]()
            
            tmp["name"] = name.text
            tmp["ingredients"] = ingredients.text
            tmp["directions"] = directions.text
            tmp["image"] = imagePath
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.addDrink(tmp)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            mensaje = "Please, you must capture all fields"
            let alert = UIAlertController(title: "Error",  message: mensaje, preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default)
            alert.addAction(action)
            self.present(alert,animated: true, completion: nil )
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnFoto(_ sender: Any) {
        // variable local
        let ipc = UIImagePickerController()
        /* para trabajar con la galería
        ipc.sourceType = .photoLibrary
        */
        ipc.delegate = self
        // permitir edición
        ipc.allowsEditing = true
        // consultamos si la cámara esta disponible
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Se requiere la llave Privacy - Camer Usage Description en el archivo info.plist
            ipc.sourceType = .camera
            // Validar permiso de uso de la cámara
            let permisos = AVCaptureDevice.authorizationStatus(for: .video)
            if permisos == .authorized {
                self.present(ipc, animated: true,  completion: nil)
            }
            else {
                if permisos == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video) { respuesta in
                        if respuesta {
                            self.present(ipc, animated: true,  completion: nil)
                        }
                        else {
                            print ("¿what can i do?")
                        }
                    }
                }
                else {  // .denied
                    let alert = UIAlertController(title: "Error", message: "Debe autorizar el uso de la cámara desde el app de configuración. Quieres hacerlo ahora?", preferredStyle:.alert)
                    let btnSI = UIAlertAction(title: "Si, por favor", style: .default) { action in
                        // lanzar el app de settings:
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                    alert.addAction(btnSI)
                    alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else {
            ipc.sourceType = .photoLibrary
            self.present(ipc, animated: true,  completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print ("seleccionó")
        if let imagen = info[.editedImage] as? UIImage {
            // Cambiar la resolución de la imagen
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), true, 0.75)
            imagen.draw(in: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
            let nuevaImagen = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            image.frame.size.width = 100
            image.frame.size.height = 100
            image.layer.cornerRadius = 50
            image.image = nuevaImagen
            
            self.imagePath = (info[.imageURL] as? String)
            
            if picker.sourceType == .camera {

                AlbumDrinks.instance.guardar(imagen)
            }
        }
        picker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("canceló")
        picker.dismiss(animated: true, completion: nil)
    }
     
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
