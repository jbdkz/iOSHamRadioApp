// Project:     Capstone IOS Project
// Author:      John Diczhazy
// Date:        4/3/19
// File:        PreferencesViewController.swift
// Description: Preferences View Controller

import UIKit
import CoreData

class PreferencesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Delcare constants for the key value pairs
    let callFontColorPickerConstant = "callFontColorPickerValue"
    let paramFontColorPickerConstant = "paramFontColorPickerValue"

    // Create variable to hole NSManagedObjectContext instance
    var managedObjectContext: NSManagedObjectContext? = nil

    @IBOutlet weak var callFontColorPicker: UIPickerView!
    @IBOutlet weak var paramFontColorPicker: UIPickerView!

    // Create arrays for pickers
    var callFontColorPickerData: [String] = [String]()
    var paramFontColorPickerData: [String] = [String]()

    // Return number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Return number of rows in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0){
            return callFontColorPickerData.count
        } else {
            return paramFontColorPickerData.count
        }
    }

    // Return picker title for row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if (pickerView.tag == 0){
            return callFontColorPickerData[row]
        } else {
            return paramFontColorPickerData[row]
        }
    }

    @IBAction func savePrefsBtn(_ sender: UIButton) {
        // Get the standard  user default object
        let defaults = UserDefaults.standard

        // Set the default values
        defaults.setValue((callFontColorPicker.selectedRow(inComponent: 0).description), forKey: callFontColorPickerConstant)
        defaults.setValue((paramFontColorPicker.selectedRow(inComponent: 0).description), forKey: paramFontColorPickerConstant)

        // Display alert confirmation
        let alertController = UIAlertController(title: "Preferences Saved!", message:
            "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect data
        self.callFontColorPicker.delegate = self
        self.callFontColorPicker.dataSource = self
        self.paramFontColorPicker.delegate = self
        self.paramFontColorPicker.dataSource = self


        // Create picker data in arrays
        callFontColorPickerData = ["Red","Black","Purple","Green","Blue"]
        paramFontColorPickerData = ["Black","Red","Purple","Green","Blue"]

        // Get the standard  user default object
        let defaults = UserDefaults.standard

        // Set the value for the defaultColor
        let defaultCallFontColor = Int(defaults.float(forKey: callFontColorPickerConstant))
        let defaultParamFontColor = Int(defaults.float(forKey: paramFontColorPickerConstant))

        callFontColorPicker.selectRow(defaultCallFontColor, inComponent:0, animated:true)
        paramFontColorPicker.selectRow(defaultParamFontColor, inComponent:0, animated:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteAllRepeaterData(_ sender: UIButton)
    {
        // Create the AlertController
        let alertController = UIAlertController(title: "Delete",
                                                message: "Delete ALL Repeater Data Confirmation",
                                                preferredStyle: UIAlertControllerStyle.alert)

        let firetAction = UIAlertAction(title: "OK",
                                        style: UIAlertActionStyle.default,
                                        handler: {(alertAction: UIAlertAction!) in
                                            //delete entry on confirmation
                                            self.deleteData()
        })

        // Alerts can only have one cancel action
        // It is bolded and always comes last
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertActionStyle.cancel,
                                         handler: {(alertAction: UIAlertAction!) in
                                            print()
        })

        // Add the action to the Alert
        alertController.addAction(firetAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func deleteData() {
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Repeaters")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
                try? context.save()
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
