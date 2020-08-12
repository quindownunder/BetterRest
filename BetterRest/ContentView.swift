//
//  ContentView.swift
//  BetterRest
//
//  Created by Matthew Richardson on 10/8/20.
//  Copyright © 2020 Matthew Richardson. All rights reserved.
//

import SwiftUI

struct ContentView: View {
        
    func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute],from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            alertMesssage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is.."
            
        } catch {
            alertTitle = "Error"
            alertMesssage = "Sorry, something went wrong"
        }
        showingAlert = true
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var sleepTime: String {
        
        var result = ""
        
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute],from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            result = formatter.string(from: sleepTime)
            
        } catch {
            result = "error"
        }
        return result
    }
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMesssage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")) {
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("How much coffee?")) {
                    
                    Picker(selection: $coffeeAmount, label: Text("Please enter number of coffees")) {
                        ForEach(1..<21) {
                            Text("\($0)")
                        }
                    }
                }
                
                Section(header: Text("Your ideal bedtime is..")) {
                    Text("\(sleepTime)")
                        .font(.largeTitle)
                }
            }
            .navigationBarTitle("BetterRest")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
