//
//  AddTripViewController.swift
//  InSat
//
//  Created by Dmitry Pavlov on 22.01.2020.
//  Copyright © 2020 Dmitry Pavlov. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {

    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var courierTF: UITextField!
    @IBOutlet weak var destinationTF: UITextField!
    @IBOutlet weak var comeToDestinationLabel: UILabel!
    
    var activeTextField = UITextField()
    
    var destinations = [Destination]()
    var couriers = [Courier]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView(){
        courierTF.delegate = self
        destinationTF.delegate = self
        startDateTF.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        toolBar.sizeToFit()
        toolBar.setItems([
        UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelAction)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneAction))], animated: false)
        toolBar.isUserInteractionEnabled = true
        let datePicker = UIDatePicker()
        datePicker.accessibilityIdentifier = "date"
        datePicker.datePickerMode = .date
        
//        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        startDateTF.inputView = datePicker
        startDateTF.inputAccessoryView = toolBar
        destinations = CoreDataManager.shared.readDestinations()
        couriers = CoreDataManager.shared.readCouriers()
        
        let destinationPicker = UIPickerView()
        destinationPicker.accessibilityIdentifier = "destination"
        destinationPicker.delegate = self
        destinationPicker.dataSource = self
        destinationTF.inputView = destinationPicker
        destinationTF.inputAccessoryView = toolBar
        
        let courierPicker = UIPickerView()
        courierPicker.accessibilityIdentifier = "courier"
        courierPicker.delegate = self
        courierPicker.dataSource = self
        courierTF.inputView = courierPicker
        courierTF.inputAccessoryView = toolBar
    }
    
    @objc func doneAction() {
        guard let inputView = activeTextField.inputView else {return}
        switch activeTextField {
        case startDateTF:
            if let v = inputView as? UIDatePicker{
                startDateTF.text = MyDateFormatter.shared.formatDateAsNumbers(date: v.date)
            }
        case destinationTF:
            if let v = inputView as? UIPickerView{
                destinationTF.text = destinations[v.selectedRow(inComponent: 0)].destination
            }
        case courierTF:
            if let v = inputView as? UIPickerView{
                courierTF.text = couriers[v.selectedRow(inComponent: 0)].name
            }
        default:
            activeTextField.resignFirstResponder()
        }
        activeTextField.resignFirstResponder()
    }
    @objc func cancelAction(){
        activeTextField.resignFirstResponder()
    }
}

extension AddTripViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}

extension AddTripViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.accessibilityIdentifier{
        case "destination":
            return destinations[row].destination
        case "courier":
            return couriers[row].name
        default:
            return nil
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch pickerView.accessibilityIdentifier{
//        case "destination":
//            destinationTF.text = destinations[row].destination
//        case "courier":
//            courierTF.text = couriers[row].name
//        default:
//            return
//        }
//    }
}

extension AddTripViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.accessibilityIdentifier{
        case "destination":
            return destinations.count
        case "courier":
            return couriers.count
        default:
            return 1
        }
    }
    
    
}
