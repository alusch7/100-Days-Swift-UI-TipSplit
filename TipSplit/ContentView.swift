//
//  ContentView.swift
//  TipSplit
//
//  Created by Alden Luscher on 2022-02-23.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2 //this is really the index not number of people, so will show up as 4 people
    @State private var tipPercentage = 10
    @FocusState private var amountIsFocused: Bool
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: (Double,Double) {
        //calculate total per person function
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let perPerson = (checkAmount*(tipSelection/100) + checkAmount)/peopleCount
        let total = (checkAmount*(tipSelection/100)+checkAmount)
        return (total,perPerson)
    }
    
    var body: some View {
        NavigationView {
            ZStack { //Don't include this in the future
                Form {
                    Section {
                        //This binds to check amount, "Amount" is what's shown in gray text if nothing is there, is in the format of the local currency, and if that currency data isn't available, falls back on USD
                        TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                            //forces it to be a decimal keyboard
                            .keyboardType(.decimalPad)
                            //Determines if the text field has focus or not
                            .focused($amountIsFocused, equals: true)
                        Picker("Number of people", selection: $numberOfPeople) {
                            ForEach(2..<100) {
                                Text("\($0) people")
                            }
                        }
                    }
                    Section {
                        Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) { //Identify each number by itself (each number is unique)
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented) //changes how choosing the tip appears
                    } header: {
                        Text("Tip Percentage")
                    } //Adding a header on top of the tip chooser
                    
                    Section {
                        Text(totalPerPerson.0, format: .currency(code: Locale.current.currencyCode ?? "USD")).foregroundColor(tipPercentage == 0 ? .red : .black)
                    } header: {
                        Text("Total Amount With Tip")
                    }
                    Section {
                        Text(totalPerPerson.1, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    } header: {
                        Text("Amount per person")
                    }
                    .navigationTitle("WeSplit") //Must be attached to the form
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            //Spacer()
                            Button("Done") {
                                amountIsFocused = false
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
