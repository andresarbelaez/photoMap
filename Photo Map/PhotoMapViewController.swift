//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!

    
    var originalImage: UIImage?
    
    var editedImage: UIImage?
    
    var latitude: NSNumber?
    var longitude: NSNumber?
    
    
    @IBAction func onCameraButton(sender: AnyObject) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            vc.sourceType = UIImagePickerControllerSourceType.Camera
            
        } else {
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("myAnnotationView")
        if (annotationView == nil){
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotationView")
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height: 50))
        }
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = UIImage(named: "camera")
        
        return annotationView
    }
    
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        
        self.latitude = latitude
        self.longitude = longitude
        
        self.navigationController?.popToViewController(self, animated: true)
        
        let pinLocation = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pinLocation
        annotation.title = "Yes"
        let annotationView = mapView(mapView, viewForAnnotation: annotation)
        mapView.addAnnotation(annotation)
        
        
    }

    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        
        let originalOptionalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let originalOptionalImage = originalOptionalImage {
            self.originalImage = originalOptionalImage
        }
        
        let editedOptionalImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if let editedOptionalImage = editedOptionalImage {
            self.editedImage = editedOptionalImage
        }
        
        //add code to do something with the edited image
        
        
        //dismiss the vc
        dismissViewControllerAnimated(true) { 
            self.performSegueWithIdentifier("tagSegue", sender: nil)
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let vc = segue.destinationViewController as! LocationsViewController
        
        vc.delegate = self
        mapView.delegate = self
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
