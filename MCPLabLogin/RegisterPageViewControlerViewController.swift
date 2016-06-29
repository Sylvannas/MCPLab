//
//  RegisterPageViewControlerViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/4/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreData

class RegisterPageViewControlerViewController: UIViewController {
    // MARK Properties
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK Actions
    
    @IBAction func registerButtonTaped(sender: AnyObject) {
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        // check for empty fields
        if(userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty )
        {
            // Display alert Message
            displayMyAlertMessage("All fields are required")
            return
        }
        
        if(userPassword != userRepeatPassword){
            
            //Display Alert message
            displayMyAlertMessage("password do not match")
            
        }
        
        // storeData
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let userRegistrationEntity = NSEntityDescription.entityForName("UserRegistration",inManagedObjectContext: managedContext)
        let userRegistration = NSManagedObject(entity: userRegistrationEntity!, insertIntoManagedObjectContext: managedContext)
        
        userRegistration.setValue(userEmail, forKey: "email")
        userRegistration.setValue(userPassword, forKey: "password")
        userRegistration.setValue(userRepeatPassword, forKey: "repeatPassword")
        
        do{
            try userRegistration.managedObjectContext?.save()
        }
        
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        /*NSUserDefaults.standardUserDefaults().setObject(userEmail,forKey: "userEmail")
        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey: "userPassword")
        NSUserDefaults.standardUserDefaults().synchronize()*/
        
        //Display Alert MEssage with Confirmation
        var myAlert = UIAlertController(title:"Alert", message:"Registration is successful. Thank you",preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            action in self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    
    func displayMyAlertMessage(userMessage : String){
        let myAlert = UIAlertController(title: "ALERT!", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
       
        let okAction = UIAlertAction(title:"OK",style: UIAlertActionStyle.Default, handler: nil)
        
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion:nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
