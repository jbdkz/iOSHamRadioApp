// Project:     Capstone IOS Project
// Author:      John Diczhazy
// Date:        4/3/19
// File:        MasterViewController.swift
// Description: Master View Controller

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // Constant required for identify Custom Cell
    let cellTableIdentifier = "Cell"
    
    // Contants needed for UserDefaults
    let callFontColorPickerConstant = "callFontColorPickerValue"
    let paramFontColorPickerConstant = "paramFontColorPickerValue"
    
    // Variables needed for UserDefaults
    var defaultCallFontColor = UIColor.black
    var defaultParamFontColor = UIColor.black

    // Variable for test data
    var count:Int = 0
    
    // Create variable to hold DetailViewController instance
    var detailViewController: DetailViewController? = nil
    
    // Create variable to hole NSManagedObjectContext instance
    var managedObjectContext: NSManagedObjectContext? = nil
    
    // Holds index data
    var stateIndex = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change nav bar title from "Master" to "Repeater App"
        self.title = "Repeater App"
        
        // Register CustomCell
        tableView.register(CustomCell.self,forCellReuseIdentifier: cellTableIdentifier)
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        // Get the standard  user default object
        let defaults = UserDefaults.standard
        
        // Set Call Sign Font Color default
        let defaultCallFontColorInt = Int(defaults.float(forKey: callFontColorPickerConstant))
        
        if(defaultCallFontColorInt==0)
        {
            defaultCallFontColor = UIColor.red
        }
        if(defaultCallFontColorInt==1)
        {
            defaultCallFontColor = UIColor.black
        }
        else if(defaultCallFontColorInt==2)
        {
            defaultCallFontColor = UIColor.purple
        }
        else if(defaultCallFontColorInt==3)
        {
            defaultCallFontColor = UIColor.green
        }
        else if(defaultCallFontColorInt==4)
        {
            defaultCallFontColor = UIColor.blue
        }
        
        // Set Parameter Font Color default
        let defaultParamFontColorInt = Int(defaults.float(forKey: paramFontColorPickerConstant))
        
        if(defaultParamFontColorInt==0)
        {
            defaultParamFontColor = UIColor.black
        }
        else if(defaultParamFontColorInt==1)
        {
            defaultParamFontColor = UIColor.red
        }
        else if(defaultParamFontColorInt==2)
        {
            defaultParamFontColor = UIColor.purple
        }
        else if(defaultParamFontColorInt==3)
        {
            defaultParamFontColor = UIColor.green
        }
        else if(defaultParamFontColorInt==4)
        {
            defaultParamFontColor = UIColor.blue
        }
        
        // Reload the data into the TableView
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Adds Repeater to Table View, save in Core Data
    @objc
    func insertNewObject(_ sender: Any)
    {
        
        // Create an Alert with a textFields
        let alertController = UIAlertController(title: "Add Repeater",
                                                message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a default action for the Alert
        let defaultAction = UIAlertAction(
            title: "Create",
            style: UIAlertActionStyle.default,
            handler: {(alertAction: UIAlertAction!) in
                // get the input from the alert controller
                let context = self.fetchedResultsController.managedObjectContext
                let newRepeater = Repeaters(context: context)
                
                newRepeater.call = (alertController.textFields![0]).text!
                newRepeater.state = (alertController.textFields![1]).text!
                newRepeater.county = (alertController.textFields![2]).text!
                newRepeater.location = (alertController.textFields![3]).text!
                newRepeater.input_Frequency = (alertController.textFields![4]).text!
                newRepeater.output_Frequency = (alertController.textFields![5]).text!
                newRepeater.uplink_tone = (alertController.textFields![6]).text!
                newRepeater.downlink_tone = (alertController.textFields![7]).text!
                newRepeater.offset = (alertController.textFields![8]).text!
                newRepeater.use = (alertController.textFields![9]).text!
                
                // Save the context.
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
                // Reload the data into the TableView
                self.tableView.reloadData()
                
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Call Sign"
            textField.text = self.generateTestData(textFieldType: "Call")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "Call Sign is a required field!"
                }
            }
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="State"
            textField.text = self.generateTestData(textFieldType: "State")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "State is a required field!"
                }
            }
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="County"
            textField.text = self.generateTestData(textFieldType: "County")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "County is a required field!"
                }
            }
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="City"
            textField.text = self.generateTestData(textFieldType: "City")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "City is a required field!"
                }
            }
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Input Frequency"
            textField.text = self.generateTestData(textFieldType: "Input Frequency")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "Input Frequency is a required field!"
                }
            }
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Output Frequency"
            textField.text = self.generateTestData(textFieldType: "Output Frequency")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "Output Frequency is a required field!"
                }
            }
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Uplink Tone"
            textField.text = self.generateTestData(textFieldType: "Uplink Tone")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "Uplink Tone is a required field!"
                }
            }
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Downlink Tone"
            textField.text = self.generateTestData(textFieldType: "Downlink Tone")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "Downlink Tone is a required field!"
                }
            }
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Offset"
            textField.text = self.generateTestData(textFieldType: "Offset")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "Offset is a required field!"
                }
            }
        })
        
        // Add the textField to the Alert. Create a closure to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Use"
            textField.text = self.generateTestData(textFieldType: "Use")
            textField.keyboardType=UIKeyboardType.emailAddress
            
            // Add Observer to sense when value has changed
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                defaultAction.isEnabled = textField.hasText
                if textField.hasText {
                    alertController.view.tintColor = UIColor.black
                    alertController.message = ""
                } else {
                    alertController.view.tintColor = UIColor.red
                    alertController.message = "Use is a required field!"
                }
            }
        })
        
        // Cancel button
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler:nil)
        
        // Add the actions to the Alert
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        // Display the Alert
        present(alertController, animated: true, completion: nil)
    }
    
    // Function creates test data in Insert Alert Controller
    func generateTestData(textFieldType: String)->String
    {
        // Increment count
        count += 1
        
        // Get the textfields and assign test data
        if textFieldType == "Call"
        {
            let randomIndex1 = Int(arc4random_uniform(UInt32(99)))
            return "N8BC\(randomIndex1)"
        }
        else if textFieldType == "State"
        {
            let stateArr = ["Ohio","Pennsylvania","Michigan","Indiana","Illinois","Tennessee"]
            let randomIndex2 = Int(arc4random_uniform(UInt32(stateArr.count)))
            return stateArr[randomIndex2]
        }
        else if textFieldType == "County"
        {
            let countyArr = ["Lorain","Holmes","Guernsey","Ashtabula","Athens","Huron"]
            let randomIndex3 = Int(arc4random_uniform(UInt32(countyArr.count)))
            return countyArr[randomIndex3]
        }
        else if textFieldType == "City"
        {
            let cityArr = ["Mentor","Columbus","Cincinnati","Sandusky","Toledo","Mansfield"]
            let randomIndex4 = Int(arc4random_uniform(UInt32(cityArr.count)))
            return cityArr[randomIndex4]
        }
        else if textFieldType == "Input Frequency"
        {
            return String(147.164+(Double(count)*0.001))
        }
        else if textFieldType == "Output Frequency"
        {
            return String(147.764+(Double(count-1)*0.001))
        }
        else if textFieldType == "Uplink Tone"
        {
            return String(110.8+(Double(count)*0.1))
        }
        else if textFieldType == "Downlink Tone"
        {
            return String(110.9+(Double(count-1)*0.1))
        }
        else if textFieldType == "Offset"
        {
            let randomIndex5 = Int(arc4random_uniform(UInt32(2)))
            var offset = ""
            if (randomIndex5 % 2 == 0){
                offset = "-"
            } else {
                offset = "+"
            }
            return offset
        }
        else if textFieldType == "Use"
        {
            let randomIndex6 = Int(arc4random_uniform(UInt32(2)))
            var use = ""
            if (randomIndex6 % 2 == 0){
                use = "CLOSED"
            } else {
                use = "OPEN"
            }
            return use
        }
        else
        {
            return "none"
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    // Returns number of section in the Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    // Sets Section Titles in Table View
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            
            // clear stateIndex array
            stateIndex = []
            
            // populate state section names in stateIndex array
            for section in sections {
                stateIndex += [section.name]
            }
            
            return String(currentSection.name)
        }
        return nil
    }
    
    // Display Table View Index
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // Remove duplicate states
        let mySet = Set<String>(stateIndex)
        
        //return index sort alphabetically
        return Array(mySet).sorted()
    }
    
    // Returns number of row in each Table View section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    // Display row data in Table View using Custom Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath) as! CustomCell
        let repeater = fetchedResultsController.object(at: indexPath)
        cell.call = repeater.call!
        cell.city = repeater.location!
        cell.callFontColor = defaultCallFontColor
        cell.paramFontColor = defaultParamFontColor
        return cell
    }
    
    // Asks the data source to verify that the given row is editable.
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            // Create an Alert with a textFields
            let alertController = UIAlertController(title: "Update Repeater",
                                                    message: "",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            // Provides Table View and Core Data update functionality
            let defaultAction = UIAlertAction(
                title: "Update",
                style: UIAlertActionStyle.default,
                handler: {(alertAction: UIAlertAction!) in
                    let object = self.fetchedResultsController.object(at: indexPath)
                    
                    // Get input from the Alert controller
                    let state: String = (alertController.textFields![1]).text!
                    let county: String = (alertController.textFields![2]).text!
                    let location: String = (alertController.textFields![3]).text!
                    let input_Freq: String = (alertController.textFields![4]).text!
                    let output_Freq: String = (alertController.textFields![5]).text!
                    let uplink_Tone: String = (alertController.textFields![6]).text!
                    let downlink_Tone: String = (alertController.textFields![7]).text!
                    let offset: String = (alertController.textFields![8]).text!
                    let use: String = (alertController.textFields![9]).text!
                    
                    // Update Values in Fetched Results Controller
                    object.setValue(state, forKey: "state")
                    object.setValue(county, forKey: "county")
                    object.setValue(location, forKey: "location")
                    object.setValue(input_Freq, forKey: "input_Frequency")
                    object.setValue(output_Freq, forKey: "output_Frequency")
                    object.setValue(uplink_Tone, forKey: "uplink_tone")
                    object.setValue(downlink_Tone, forKey: "downlink_tone")
                    object.setValue(offset, forKey: "offset")
                    object.setValue(use, forKey: "use")
                    
                    // If no error, update Core Data Entity
                    let context = self.fetchedResultsController.managedObjectContext
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                    
                    // Reload the data into the TableView
                    self.tableView.reloadData()
            })
            
            // Add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Call Sign"
                textField.keyboardType=UIKeyboardType.emailAddress
                //  Don't let user edit this textField
                textField.isUserInteractionEnabled = false
                
            })
            
            // Add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="State"
                textField.keyboardType=UIKeyboardType.emailAddress
                
                // Add Observer to sense when value has changed
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    defaultAction.isEnabled = textField.hasText
                    if textField.hasText {
                        alertController.view.tintColor = UIColor.black
                        alertController.message = ""
                    } else {
                        alertController.view.tintColor = UIColor.red
                        alertController.message = "State is a required field!"
                    }
                }
            })
            
            // Add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="County"
                textField.keyboardType=UIKeyboardType.emailAddress
                
                // Add Observer to sense when value has changed
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    defaultAction.isEnabled = textField.hasText
                    if textField.hasText {
                        alertController.view.tintColor = UIColor.black
                        alertController.message = ""
                    } else {
                        alertController.view.tintColor = UIColor.red
                        alertController.message = "County is a required field!"
                    }
                }
            })
            
            // Add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="City"
                textField.keyboardType=UIKeyboardType.emailAddress
                
                // Add Observer to sense when value has changed
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    defaultAction.isEnabled = textField.hasText
                    if textField.hasText {
                        alertController.view.tintColor = UIColor.black
                        alertController.message = ""
                    } else {
                        alertController.view.tintColor = UIColor.red
                        alertController.message = "City is a required field!"
                    }
                }
            })
            
            // add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Input Frequency"
                textField.keyboardType=UIKeyboardType.emailAddress
                
                // Add Observer to sense when value has changed
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    defaultAction.isEnabled = textField.hasText
                    if textField.hasText {
                        alertController.view.tintColor = UIColor.black
                        alertController.message = ""
                    } else {
                        alertController.view.tintColor = UIColor.red
                        alertController.message = "Input Frequency is a required field!"
                    }
                }
            })
            
            // Add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Output Frequency"
                textField.keyboardType=UIKeyboardType.emailAddress
                
                // Add Observer to sense when value has changed
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    defaultAction.isEnabled = textField.hasText
                    if textField.hasText {
                        alertController.view.tintColor = UIColor.black
                        alertController.message = ""
                    } else {
                        alertController.view.tintColor = UIColor.red
                        alertController.message = "Output Frequency is a required field!"
                    }
                }
            })
            
            // Add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Uplink Tone"
                textField.keyboardType=UIKeyboardType.emailAddress
                
                // Add Observer to sense when value has changed
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    defaultAction.isEnabled = textField.hasText
                    if textField.hasText {
                        alertController.view.tintColor = UIColor.black
                        alertController.message = ""
                    } else {
                        alertController.view.tintColor = UIColor.red
                        alertController.message = "Uplink Tone is a required field!"
                    }
                }
            })
            
            // Add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Downlink Tone"
                textField.keyboardType=UIKeyboardType.emailAddress
                
                // Add Observer to sense when value has changed
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    defaultAction.isEnabled = textField.hasText
                    if textField.hasText {
                        alertController.view.tintColor = UIColor.black
                        alertController.message = ""
                    } else {
                        alertController.view.tintColor = UIColor.red
                        alertController.message = "Downlink Tone is a required field!"
                    }
                }
            })
            
            // Add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Offset"
                textField.keyboardType=UIKeyboardType.emailAddress
                
                // Add Observer to sense when value has changed
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    defaultAction.isEnabled = textField.hasText
                    if textField.hasText {
                        alertController.view.tintColor = UIColor.black
                        alertController.message = ""
                    } else {
                        alertController.view.tintColor = UIColor.red
                        alertController.message = "Offset is a required field!"
                    }
                }
            })
            
            // Add the textField to the Alert. Create a closure to handle the configuration
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder="Use"
                textField.keyboardType=UIKeyboardType.emailAddress
                
                // Add Observer to sense when value has changed
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    defaultAction.isEnabled = textField.hasText
                    if textField.hasText {
                        alertController.view.tintColor = UIColor.black
                        alertController.message = ""
                    } else {
                        alertController.view.tintColor = UIColor.red
                        alertController.message = "Use is a required field!"
                    }
                }
            })
            
            // Cancel button
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.cancel,
                handler:nil)
            
            // Add the actions to the Alert Controller
            alertController.addAction(defaultAction)
            alertController.addAction(cancelAction)
            
            // Return a single Repeater object
            let object = self.fetchedResultsController.object(at: indexPath)
            
            (alertController.textFields![0]).text = object.call
            (alertController.textFields![1]).text = object.state
            (alertController.textFields![2]).text = object.county
            (alertController.textFields![3]).text = object.location
            (alertController.textFields![4]).text = object.input_Frequency
            (alertController.textFields![5]).text = object.output_Frequency
            (alertController.textFields![6]).text = object.uplink_tone
            (alertController.textFields![7]).text = object.downlink_tone
            (alertController.textFields![8]).text = object.offset
            (alertController.textFields![9]).text = object.use
            
            // Display the Alert Controller
            self.present(alertController, animated: true, completion: nil)
        }
        editAction.backgroundColor = .blue
        
        // Create Delete Action
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let context = self.fetchedResultsController.managedObjectContext
            
            // Create the Alert Controller
            let alertController = UIAlertController(title: "Delete",
                                                    message: "Delete Confirmation",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            // Create a default action button with title delete and no handler
            let firetAction = UIAlertAction(title: "OK",
                                            style: UIAlertActionStyle.default,
                                            handler: {(alertAction: UIAlertAction!) in
                                                //Delete entry from Table View and Core Data, upon confirmation
                                                context.delete(self.fetchedResultsController.object(at: indexPath))
                                                do {
                                                    try context.save()
                                                } catch {
                                                    let nserror = error as NSError
                                                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                                                }
                                                
            })
            
            // Alerts can only have one cancel action. It is bolded and always comes last
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: UIAlertActionStyle.cancel,
                                             handler: {(alertAction: UIAlertAction!) in
                                                print()
            })
            
            // Add the action to the Alert
            alertController.addAction(firetAction)
            alertController.addAction(cancelAction)
            
            // Present or display the Alert
            self.present(alertController, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = .red
        
        return [editAction,deleteAction]
    }

    // Provides Delete functionality in Table View.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Segeue for navigation to Detail view, required with use of Custom Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender:tableView)
    }
    
    // Remnant of Standard Cell, still required
    func configureCell(_ cell: UITableViewCell, withEvent event: Repeaters) {
        //cell.textLabel!.text = event.call!.description
    }
    
    // MARK: - Fetched results controller
    // Required for getting data from Core Data Entity
    var fetchedResultsController: NSFetchedResultsController<Repeaters> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Repeaters> = Repeaters.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "state", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "state", cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Repeaters>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Used for the insertion and deletion of Section Headers
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    // Used for the insertion, deletion, and updating of objects in Table View
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Repeaters)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Repeaters)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
     // In the simplest, most efficient, case, reload the table view.
     tableView.reloadData()
     }
     */
    
}

