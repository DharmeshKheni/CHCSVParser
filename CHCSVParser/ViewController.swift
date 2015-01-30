//
//  ViewController.swift
//  CHCSVParser
//
//  Created by Anil on 28/01/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, CHCSVParserDelegate {

    var currentRow = NSMutableArray()
    var dict : NSMutableDictionary = NSMutableDictionary()
    @IBOutlet weak var txtRo: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMarks: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func parserDidBeginDocument(parser: CHCSVParser!) {
        
        currentRow = NSMutableArray()
    }
    
    func parserDidEndDocument(parser: CHCSVParser!) {

        for var i = 0; i < currentRow.count; ++i {
            
            println((currentRow.objectAtIndex(i).valueForKey("0")),
                (currentRow.objectAtIndex(i).valueForKey("1")),
                (currentRow.objectAtIndex(i).valueForKey("2")))
            
            }
    }
    
    func parser(parser: CHCSVParser!, didFailWithError error: NSError!) {
        
        println("Parse failed with error: \(error.localizedDescription), \(error.userInfo)")
    }
    func parser(parser: CHCSVParser!, didBeginLine recordNumber: UInt) {
        
        dict = NSMutableDictionary()
    }
    func parser(parser: CHCSVParser!, didReadField field: String!, atIndex fieldIndex: Int) {
        
        dict.setObject(field, forKey: String(fieldIndex))
    }
    func parser(parser: CHCSVParser!, didEndLine recordNumber: UInt) {
        
        currentRow.addObject(dict)
        dict = ["":""]
    }
    @IBAction func btnWrite(sender: AnyObject) {
        
        var parser : CHCSVParser = CHCSVParser(CSVString: NSHomeDirectory().stringByAppendingPathComponent("fav.csv"))
        parser.delegate = self
        parser.parse()
        
        var csvWriter : CHCSVWriter = CHCSVWriter(forWritingToCSVFile: NSHomeDirectory().stringByAppendingPathComponent("fav.csv"))
        csvWriter.writeField("Roll Number")
        csvWriter.writeField("Name")
        csvWriter.writeField("Marks")
        csvWriter.finishLine()
        
        for var i = 0; i < currentRow.count; ++i{
    
            csvWriter.writeField(currentRow.objectAtIndex(i).valueForKey("0"))
            csvWriter.writeField(currentRow.objectAtIndex(i).valueForKey("1"))
            csvWriter.writeField(currentRow.objectAtIndex(i).valueForKey("2"))
            
            }
        csvWriter.writeField(txtRo.text)
        csvWriter.writeField(txtName.text)
        csvWriter.writeField(txtMarks.text)
        
        csvWriter.closeStream()
        
        var alert : UIAlertController = UIAlertController(title: "Success", message: "Your Data has been suceesFully saved", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        self.txtRo.text = ""
        self.txtName.text = ""
        self.txtMarks.text = ""
    }
    
    
    
    @IBAction func btnDismissKeyboardClicked(sender: AnyObject) {
        
        txtRo.resignFirstResponder()
        txtName.resignFirstResponder()
        txtMarks.resignFirstResponder()
        
    }
}


