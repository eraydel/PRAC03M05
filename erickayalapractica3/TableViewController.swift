//
//  TableViewController.swift
//  erickayalapractica3
//
//  Created by Erick Ayala Delgadillo on 26/03/22.
//

import UIKit

class TableViewController: UITableViewController {
    
    var datos = [[String:Any]]() // dado que el archivo Drinks es un arreglo de diccionarios que contiene los drinks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    
    /*
     Method: getData
     Created by: Erick Ayala
     Created at: 25/03/2022
     */
    func getData(){
        if let filePath = Bundle.main.url(forResource: "Drinks", withExtension: "plist"){
            do{
                let bytes = try Data(contentsOf: filePath)
                let tmp   = try PropertyListSerialization.propertyList(from: bytes, options: .mutableContainers, format: nil)
                datos = tmp as! [[String:Any]]
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get the name attribute
        let elDict = datos[indexPath.row]
        let drinkName  = (elDict["name"] as? String ) ?? "\(indexPath)"
        
        let imageDrink = (elDict["image"] as? String) ?? "\(indexPath)"
        let image =  UIImage(named: imageDrink.lowercased()) ?? UIImage()
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableView", for: indexPath) 
        
        
        cell.textLabel?.text = drinkName
        cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        cell.imageView?.frame.size.width = 40
        cell.imageView?.frame.size.height = 40
        cell.imageView?.layer.cornerRadius = 20
        cell.imageView?.clipsToBounds = true
        cell.imageView?.image = image.resizeImageWithHeight(newW: 40, newH: 40)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datos.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "details", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! ViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            let theDrink = datos[indexPath.row]
            detailsVC.drink = theDrink //agregar comom miembro de la clase VC a drinkName
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage{
    func resizeImageWithHeight(newW: CGFloat, newH: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: newW, height: newH))
        self.draw(in: CGRect(x: 0, y: 0, width: newW, height: newH))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
