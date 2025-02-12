//
//  RideDetailsViewController.swift
//  OcoryDriver
//
//  Created by nile on 01/10/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import  Alamofire

class RideDetailsViewController: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet weak var mStatusLBL: UILabel!
    @IBOutlet weak var mDistanceLBL: UILabel!
    @IBOutlet weak var mTipAmountLBL: UILabel!
    @IBOutlet weak var dateAndTime_lbl: UILabel!
    @IBOutlet weak var amount_lbl: UILabel!
    @IBOutlet weak var pickUpAddress_lbl: UILabel!
    @IBOutlet weak var dropAddress_lbl: UILabel!
    @IBOutlet weak var yourRideWith_lbl: UILabel!
    @IBOutlet weak var paymentStatus_lbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var kDestinationLatLongTap = ""
    var kCurrentLocaLatLongTap = ""

    //MARK:- Variables
    var ridesStatusData : CompletedRidesData?
    var ridedetail : RidesData?
    var screen = ""
    
    var picupAdd = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "Ride Details"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.isNavigationBarHidden = false
        if screen == "accept"{
            Fridedetail()
        }else{
            self.setData()
        }
        
    }
    
    //MARK:- User Defined Func
    func Fridedetail(){
        self.mStatusLBL.text = self.ridedetail?.status ?? ""
        self.mDistanceLBL.text = self.ridedetail?.distance ?? ""
        self.mTipAmountLBL.text = "$ " + (self.ridedetail?.tip_amount ?? "0.0")
       // "$ " + (self.ridesStatusData?.tip_amount)! ?? "0.0"
        self.dateAndTime_lbl.text = self.ridedetail?.time ?? ""
        self.amount_lbl.text = "$ " + (self.ridedetail?.amount ?? "")
        self.pickUpAddress_lbl.text = self.ridedetail?.pickupAdress ?? ""
        self.dropAddress_lbl.text = self.ridedetail?.dropAddress ?? ""
        self.paymentStatus_lbl.text = self.ridedetail?.status ?? ""
        self.yourRideWith_lbl.text = "Your ride is with " + (self.ridedetail?.driverName ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let lattitude : Double = Double("\(self.ridedetail?.pickupLat ?? "")")!
            let longi : Double = Double("\(self.ridedetail?.pickupLong ?? "")")!
            
            let camera = GMSCameraPosition.camera(withLatitude:lattitude, longitude:longi, zoom: 5.0)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longi)
            self.mapView.delegate = self
            marker.isDraggable = true
            marker.map = self.mapView
            self.reverseGeocoding(marker: marker)
            self.mapView.animate(to: camera)
        })
    }
    
    //MARK:- User Defined Func
    func setData(){
        self.mStatusLBL.text = self.ridesStatusData?.status ?? ""
        self.mDistanceLBL.text = self.ridesStatusData?.distance ?? ""
        self.mTipAmountLBL.text = "$ " + (self.ridesStatusData?.tip_amount ?? "0.0")
       // "$ " + (self.ridesStatusData?.tip_amount)! ?? "0.0"
        self.dateAndTime_lbl.text = self.ridesStatusData?.time ?? ""
        self.amount_lbl.text = "$ " + (self.ridesStatusData?.amount ?? "")
        
        var latt = ridesStatusData?.pickupLat as! String
        var lngg = ridesStatusData?.pickupLong as! String
        let lat: Double = Double(latt)!
        let lng: Double = Double(lngg)!
        let location = CLLocation(latitude: lat, longitude: lng)
//        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//                        if error != nil {
//                            return
//                        }else{
//                            let country = placemarks?.first?.country as! String
//
//                            let city = placemarks?.first?.locality as! String
//                            let state = placemarks?.first?.administrativeArea as! String
//                            self.picupAdd.append(city)
//                            self.picupAdd.append(state)
//                            self.picupAdd.append(country)
//                            let ab = self.picupAdd.joined(separator: ", ")
//                            self.pickUpAddress_lbl.text = ab
//                            self.picupAdd.removeAll()
//                        }
//                    })
//        var Dlatt = ridesStatusData?.dropLat as! String
//        var Dlngg = ridesStatusData?.dropLong as! String
//        let Dlat: Double = Double(Dlatt)!
//        let Dlng: Double = Double(Dlngg)!
//        let Dlocation = CLLocation(latitude: Dlat, longitude: Dlng)
////        CLGeocoder().reverseGeocodeLocation(Dlocation, completionHandler: {(placemarks, error) -> Void in
////                        if error != nil {
////                            return
////                        }else{
////                            let country = placemarks?.first?.country as! String
////
////                            let city = placemarks?.first?.locality as! String
////                            let state = placemarks?.first?.administrativeArea as! String
////                            self.picupAdd.append(city)
////                            self.picupAdd.append(state)
////                            self.picupAdd.append(country)
////                            let ab = self.picupAdd.joined(separator: ", ")
////                            self.dropAddress_lbl.text = ab
////                            self.picupAdd.removeAll()
////                        }
////                    })
//
//
//        CLGeocoder().reverseGeocodeLocation(Dlocation, completionHandler: {(placemarks, error) -> Void in
//            print(location)
//            guard error == nil else {
//                print("Reverse geocoder failed with error" + error!.localizedDescription)
//                return
//            }
//            guard placemarks!.count > 0 else {
//                print("Problem with the data received from geocoder")
//                return
//            }
//
//            //  let pm = placemarks[0] as! CLPlacemark
//            let country = placemarks?.first?.country as! String
//
//            let city = placemarks?.first?.locality as! String
//            let state = placemarks?.first?.administrativeArea as! String
//            self.picupAdd.append(city)
//            self.picupAdd.append(state)
//            self.picupAdd.append(country)
//            let ab = self.picupAdd.joined(separator: ", ")
//            self.dropAddress_lbl.text = ab
//            self.picupAdd.removeAll()
//
//
//        })
//
//
        self.pickUpAddress_lbl.text = self.ridesStatusData?.short_pick_address ?? ""
        self.dropAddress_lbl.text = self.ridesStatusData?.short_drop_address ?? ""
        self.paymentStatus_lbl.text = self.ridesStatusData?.status ?? ""
        self.yourRideWith_lbl.text = "Your ride is with " + (self.ridesStatusData?.driverName ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let lattitude : Double = Double("\(self.ridesStatusData?.pickupLat ?? "")")!
            let longi : Double = Double("\(self.ridesStatusData?.pickupLong ?? "")")!
            
            let camera = GMSCameraPosition.camera(withLatitude:lattitude, longitude:longi, zoom: 5.0)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longi)
            self.mapView.delegate = self
            marker.isDraggable = true
            marker.map = self.mapView
            self.reverseGeocoding(marker: marker)
            self.mapView.animate(to: camera)
        })
    }
}

extension RideDetailsViewController : GMSMapViewDelegate{
    //Mark: Reverse GeoCoding
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                print("Response is = \(address)")
                print("Response is = \(lines)")
                
                if self.screen == "accept"{
                    let lattitude : Double = Double("\(self.ridedetail?.dropLat ?? "")")!
                    let longi : Double = Double("\(self.ridedetail?.dropLong ?? "")")!
                    self.kCurrentLocaLatLongTap =   "\(self.ridedetail?.pickupLat ?? "")" + "," + "\(self.ridesStatusData?.pickupLong ?? "")"
                    currentAddress = lines.joined(separator: "\n")
                    self.kDestinationLatLongTap =   "\(lattitude)" + "," + "\(longi)"
                    marker.title = currentAddress
                    marker.map = self.mapView
                    if self.kCurrentLocaLatLongTap != "" && self.kDestinationLatLongTap != ""{
                        self.routingLines(origin: self.kCurrentLocaLatLongTap,destination: self.kDestinationLatLongTap)
                    }
                }else{
                    let lattitude : Double = Double("\(self.ridesStatusData?.dropLat ?? "")")!
                    let longi : Double = Double("\(self.ridesStatusData?.dropLong ?? "")")!
                    self.kCurrentLocaLatLongTap =   "\(self.ridesStatusData?.pickupLat ?? "")" + "," + "\(self.ridesStatusData?.pickupLong ?? "")"
                    currentAddress = lines.joined(separator: "\n")
                    self.kDestinationLatLongTap =   "\(lattitude)" + "," + "\(longi)"
                    marker.title = currentAddress
                    marker.map = self.mapView
                    if self.kCurrentLocaLatLongTap != "" && self.kDestinationLatLongTap != ""{
                        self.routingLines(origin: self.kCurrentLocaLatLongTap,destination: self.kDestinationLatLongTap)
                    }
                }
                
            }
        }
    }
    //MARK:- routing line draw
    
    func routingLines(origin: String,destination: String){
        print("PICK UP LAT LONG======\(origin)")
        print("DROP LAT LONG======\(destination)")
        
        let googleapi =  "AIzaSyB-JC40RpeU21Ho_ex_olOh-7Cyi-IuIfQ"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(googleapi)"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    let routes = JSON["routes"] as! NSArray
                    for route in routes
                    {
                        let pathv : NSArray = routes.value(forKey: "overview_polyline") as! NSArray
                        let paths : NSArray = pathv.value(forKey: "points") as! NSArray
                        let newPath = GMSPath.init(fromEncodedPath: paths[0] as! String)
                        let polyLine = GMSPolyline(path: newPath)
                        polyLine.strokeWidth = 5
                        polyLine.strokeColor =  .black
                        let ThemeOrange = GMSStrokeStyle.solidColor( .blue)
                        let OrangeToBlue = GMSStrokeStyle.gradient(from:  .blue, to:  .blue)
                        polyLine.spans = [GMSStyleSpan(style: ThemeOrange),
                                          GMSStyleSpan(style: ThemeOrange),
                                          GMSStyleSpan(style: OrangeToBlue)]
                        let bounds = GMSCoordinateBounds(path:newPath! )
                        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 7.0))
                        polyLine.map = self.mapView
                    }
                }
            case .failure(let error): break
                self.showAlert("GetDuma Driver", message: "\(String(describing: error.errorDescription))")
            }
        }
    }
}
