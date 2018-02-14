//
//  RTMainScreenViewController.swift
//  RoboTaxi_App
//
//  Created by Guillermo Moran on 2/3/18.
//  Copyright © 2018 WeGo. All rights reserved.
//

import UIKit
import MapKit

class RTMainScreenViewController: UIViewController, CLLocationManagerDelegate {
    
    let barColor = UIColor(red:0.32, green:0.36, blue:0.44, alpha:1.0)


    
    @IBOutlet weak var currentLocationBarView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var requestVehicleButton: UIButton!
    
    
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeMapView()
        UIApplication.shared.statusBarStyle = .default

        
        let buttonColor = barColor
        let cornerRadius = CGFloat(10)
        let borderWidth = CGFloat(1)
        
        requestVehicleButton.titleLabel?.textColor = .white
        requestVehicleButton.backgroundColor = barColor
        requestVehicleButton.layer.cornerRadius = cornerRadius
        requestVehicleButton.layer.borderWidth = borderWidth
        requestVehicleButton.layer.borderColor = buttonColor.cgColor
        requestVehicleButton.alpha = 0.9
        
        //Current Location Bar View
        currentLocationBarView.layer.cornerRadius = cornerRadius
        currentLocationBarView.layer.borderWidth = borderWidth
        currentLocationBarView.layer.borderColor = UIColor.white.cgColor
        currentLocationBarView.alpha = 0.9
        
        
        //Profile Button
        
        //profileButton.titleLabel?.textColor = .white
        profileButton.layer.cornerRadius = profileButton.frame.width * 0.5
        profileButton.layer.borderWidth = borderWidth
        profileButton.layer.borderColor = buttonColor.cgColor
        profileButton.alpha = 0.9
      
        
    }
    
    func initializeMapView() {
    
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
        
        self.mainMapView.delegate = self
        self.mainMapView.showsUserLocation = true
        
        //Set custom map overlay
        let tiileOverlay = PandaTiileOverlay(hasLabels: false, style: .light)
        self.mainMapView.add(tiileOverlay.overlay, level: .aboveRoads) // .aboveLabels
        
        //let coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 0.5, 0.5)
        //mainMapView.setRegion(coordinateRegion, animated: true)
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //locationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2500, 2500)
        mainMapView.setRegion(coordinateRegion, animated: false)
        locationManager.stopUpdatingLocation()
    }
    
   
    
    @IBAction func requestVehicle(_ sender: Any) {
        
        let orderController = RTVehicleOrderController.sharedInstance
        
        let newOrder = orderController.requestNewOrder()
        
        //If the order is empty, an error occured. Tell the user.
        
        if (orderController.isEmptyOrder(order: newOrder)) {
            
            let alert = UIAlertController(title: "Error", message: "An error occurred while processing your order.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let order_id = newOrder.getOrderID()
        let vehicle_id = newOrder.getVehicleID()
        let orderDate = newOrder.getOrderDate()
        
        let alert = UIAlertController(title: "Order Created!", message: "The following order has been created: \n Order ID : \(order_id) \n Vehicle ID : \(vehicle_id) \n Order Date : \(orderDate)", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        /*
        let networkController = RTNetworkController.sharedInstance
        if (networkController.testMainServerConnection()) {
            let alert = UIAlertController(title: "Not Available!", message: "RoboTaxi is not available yet!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        */
        
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

extension RTMainScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer()
        }
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
}
