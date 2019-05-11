// Project:     Capstone IOS Project
// Author:      John Diczhazy
// Date:        4/3/19
// File:        DetailViewController.swift
// Description: Detail View Controller

import UIKit
import CoreData

class DetailViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    // Create variable to hole NSManagedObjectContext instance
    var managedObjectContext: NSManagedObjectContext? = nil
    
    // Contants needed for UserDefaults
    let callFontColorPickerConstant = "callFontColorPickerValue"
    let paramFontColorPickerConstant = "paramFontColorPickerValue"
    
    // Variables needed for UserDefaults
    var defaultCallFontColor = UIColor.black
    var defaultParamFontColor = UIColor.black

    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var input_FreqLabel: UILabel!
    @IBOutlet weak var output_FreqLabel: UILabel!
    @IBOutlet weak var uplink_ToneLabel: UILabel!
    @IBOutlet weak var downlink_ToneLabel: UILabel!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var useLabel: UILabel!
    
    // Update Detail View with Repeater info
    func configureView() {
        // Update the user interface for the detail item
        if let detail = detailItem
        {
            if let label = callLabel
            {
                label.text = detail.call?.description
            }
            if let label = stateLabel
            {
                label.text = detail.state?.description
            }
            if let label = countyLabel
            {
                label.text = detail.county?.description
            }
            if let label = locationLabel
            {
                label.text = detail.location?.description
            }
            if let label = input_FreqLabel
            {
                label.text = detail.input_Frequency?.description
            }
            if let label = output_FreqLabel
            {
                label.text = detail.output_Frequency?.description
            }
            if let label = uplink_ToneLabel
            {
                label.text = detail.uplink_tone?.description
            }
            if let label = downlink_ToneLabel
            {
                label.text = detail.downlink_tone?.description
            }
            if let label = offsetLabel
            {
                label.text = detail.offset?.description
            }
            if let label = useLabel
            {
                label.text = detail.use?.description
            }
        }
    }
    
    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Change nav bar title from "Detail" to "Repeater Detail"
        self.title = "Repeater Detail"
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        
        // Get the standard user default object
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
        
        callLabel.textColor = defaultCallFontColor
        
        // Set Parameter Font Color default
        let defaultParamFontColorInt = Int(defaults.float(forKey: paramFontColorPickerConstant))
        
        if(defaultParamFontColorInt==0)
        {
            defaultCallFontColor = UIColor.black
        }
        if(defaultParamFontColorInt==1)
        {
            defaultCallFontColor = UIColor.red
        }
        else if(defaultParamFontColorInt==2)
        {
            defaultCallFontColor = UIColor.purple
        }
        else if(defaultParamFontColorInt==3)
        {
            defaultCallFontColor = UIColor.green
        }
        else if(defaultParamFontColorInt==4)
        {
            defaultParamFontColor = UIColor.blue
        }
        
        stateLabel.textColor = defaultCallFontColor
        countyLabel.textColor = defaultCallFontColor
        locationLabel.textColor = defaultCallFontColor
        input_FreqLabel.textColor = defaultCallFontColor
        output_FreqLabel.textColor = defaultCallFontColor
        uplink_ToneLabel.textColor = defaultCallFontColor
        downlink_ToneLabel.textColor = defaultCallFontColor
        offsetLabel.textColor = defaultCallFontColor
        useLabel.textColor = defaultCallFontColor
    }

     // Sent to the view controller when the app receives a memory warning.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Call configureView function, based on detailItem event
    var detailItem: Repeaters? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    // Required for Exit on Preference page
    @IBAction func myUnwindAction(sender: UIStoryboardSegue)
    {
    }
}
