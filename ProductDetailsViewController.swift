//
//  ProductDetailsViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/15/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class ProductDetailsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var Categories: UIPickerView!
    
    let locationManager = CLLocationManager ()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var productName: UITextField!
    
    @IBOutlet weak var amountNumber: UITextField!
    
    @IBOutlet weak var otherInformation: UITextField!
    
    var categoryListArray = ["Study","cloth","food"]
    
    var categorySelected = ""
    
    var productStorage = [NSManagedObject]()
    
    var latitude = ""
    
    var longitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Map portion as an input
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        //self.mapView.delegate = self
        
        //self.mapView.mapType = MKMapType.Standard
        
        /*let Aachen = CLLocationCoordinate2D(latitude: 50.774362, longitude: 6.088964)
        self.mapView.region = MKCoordinateRegionMakeWithDistance(Aachen, 1000, 1000)*/
    
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }else if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        
        /*if CLLocationManager.locationServicesEnabled (){
            self.locationManager.startUpdatingLocation()
        }*/
        
        // category drop down box
        Categories.delegate = self
        Categories.dataSource = self
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryListArray[row]
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryListArray.count
    }
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        NSLog("didSelect----\(categoryListArray [row])")
        categorySelected = categoryListArray [row]
    }
    
    func locationManager(manager : CLLocationManager,didChangeAuthorizationStatus status:CLAuthorizationStatus){

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last
        
        latitude = "\(location!.coordinate.latitude)"
        print (latitude)
        
        longitude = "\(location!.coordinate.longitude)"
        print (longitude)
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    
    @IBAction func storeValueToDb(sender: UIButton) {
        NSLog("inside of storeValueToDb")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        //let userEntity = NSEntityDescription.entityForName("MCPLabUser", inManagedObjectContext: managedContext)
       // let user =  NSManagedObject(entity: userEntity!, insertIntoManagedObjectContext: managedContext)
        
        //user.setValue(NSUserDefaults.standardUserDefaults().stringForKey("userEmail"), forKey:"name")
        
        let entity = NSEntityDescription.entityForName("ProductInventory", inManagedObjectContext: managedContext)
        let product = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        product.setValue(productName!.text!, forKey: "name")
        product.setValue(categorySelected, forKey: "category")
        product.setValue(amountNumber!.text!, forKey: "amount")
        product.setValue(latitude, forKey: "userLocLatitude")
        product.setValue(longitude, forKey: "userLocLongitude")
        product.setValue(NSUserDefaults.standardUserDefaults().stringForKey("userEmail"), forKey: "requestedUser")

        product.setValue(otherInformation!.text!, forKey: "other")
        
        //user.setValue(NSSet(object: product), forKey: "products")
        do{
            try product.managedObjectContext?.save()
            let myAlert = UIAlertController(title:"Alert", message:"product Added!!!",preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                action in self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
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
