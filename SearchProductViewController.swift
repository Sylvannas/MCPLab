//
//  SearchProductViewController.swift
//  MCPLabLogin
//
//  Created by Khan hafizur rahman on 6/21/16.
//  Copyright © 2016 Khan hafizur rahman. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
class SearchProductViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var LocationName: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var surroundingDistance: UIPickerView!
    var surroundingDistancesArray = ["5","10","15"]
    let locationManager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //map view Delegate Code
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        // menu item Code
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // pickerViewCode
        surroundingDistance.delegate = self
        surroundingDistance.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return surroundingDistancesArray[row]
    }
   
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return surroundingDistancesArray.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }
    
    @IBAction func SearchItem(sender: UIButton) {
        NSLog("search button pressed")
        /*
         1. store pickerValue selected value
         2. get current user location latitude and longitude in func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
         3. create similar type of objects like eifel tower
         4. instead of 400 we will use value from step1
         let EiffelTower = CLLocationCoordinate2D(latitude: 48.858093, longitude: 2.294694)
         self.mapView.region = MKCoordinateRegionMakeWithDistance(EiffelTower, 400, 400)
        */
        
        let productForSearch = productName.text!
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ProductInventory")
        
        let predicate = NSPredicate(format: "%K == %@", "name",productForSearch)
        fetchRequest.predicate = predicate
        
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                print("result ->\(managedObject.valueForKey("name"))")
                print("location ->\(managedObject.valueForKey("userLocLatitude"))")
                let latitude = ((managedObject.valueForKey("userLocLatitude") as? NSString)?.doubleValue)!
                let longitude = ((managedObject.valueForKey("userLocLongitude") as? NSString)?.doubleValue)!
                let interestingPosition = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let pointAnnotation = MKPointAnnotation ()
                pointAnnotation.coordinate = interestingPosition
                let coords = CLLocationCoordinate2DMake(latitude, longitude)
                selectedPin = MKPlacemark(coordinate: coords, addressDictionary: nil)
                pointAnnotation.title = "Interesting Pos"
                self.mapView.addAnnotation(pointAnnotation)
                self.mapView.setCenterCoordinate(interestingPosition, animated: true)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
  
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title! == "Interesting Pos"{
            NSLog("interesting!!!!!!!!!!")
            let aView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: nil)
            aView.pinTintColor = UIColor.blueColor()
            aView.animatesDrop = true
            aView.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
            button.addTarget(self, action: #selector(SearchProductViewController.getDirections), forControlEvents: .TouchUpInside)
            aView.leftCalloutAccessoryView = button
            return aView
        }
       return nil
    }
    // Mark : Location Delegate Method
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude,longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        //self.locationManager.stopUpdatingLocation()
        
    }

    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("mapError\(error.localizedDescription)")
    }
    
    override func viewDidAppear(animated: Bool) {
        
        NSLog("inside viewDidAppear method!!!!")
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        if(!isUserLoggedIn){
            self.performSegueWithIdentifier("loginView2", sender: self)
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
