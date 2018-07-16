//
//  ViewController.swift
//  GoscaleAsignment
//
//  Created by TapashM on 14/07/18.
//  Copyright © 2018 ITC Infotech. All rights reserved.
//

import UIKit
import CoreData
import Charts

class ViewController: UIViewController {
    var days: [Date]!

    @IBOutlet weak var chartView: BarChartView!
    // MARK: - fetchedResultsController used to catched data
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<GeoLocationData> = {
        // Create Fetched Results Controller
        let fetchedResultsController = CoreDataManager.getFetchedResultsController(entityName: "GeoLocationData", predicate: nil, sortingKey: "dateTimeStamp",context: CoreDataStack.shared.persistentContainer.viewContext)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bar chart of location accuracy vs time"
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.maxVisibleCount = 60

        getGeolocationData()
    }
    
    func setChart(dataPoints: [Date], values: [Double]) {
        
        chartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = Array()
        var counter = 0.0
        
        for i in 0..<dataPoints.count {
            counter += 1.0
            let dataEntry = BarChartDataEntry(x: values[i], y: counter)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Time")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartView.data = chartData
        
    }
    
    
    private func getGeolocationData(){
        GANetwork.shared.fetchGeoLocation(param: nil, success: { [weak self](locatioAccuracy) in
            print(locatioAccuracy ?? "not get any value")
            self?.updateChartData()
        }) { (error) in
            print(error)

        }
    }
    
     func updateChartData() {
            chartView.data = nil
       let results = CoreDataManager.getGeolocationData(entityName: "GeolocationData", predicate: nil, sortingKey: "dateTimeStamp")
        
        guard let result = results else {
            return
        }
        let  dateArray = result.map({ (location: GeoLocationData) -> Date in
            location.dateTimeStamp!
        })
        let  accuracyArray = result.map({ (location: GeoLocationData) -> Double in
            location.accuracy
        })
        self.setChart(dataPoints: dateArray, values: accuracyArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            print("insert")
        case .delete:
            print("delete")

        case .move:
            break
        case .update:
            break
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}

