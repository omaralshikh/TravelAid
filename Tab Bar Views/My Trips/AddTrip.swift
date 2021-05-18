//
//  AddTrip.swift
//  TravelAid
//
//  Created by Omar on 11/1/20.
//  Copyright © 2020 Omar Alshikh. All rights reserved.
//

import SwiftUI
import CoreData

struct AddTrip: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showSongAddedAlert = false
    @State private var showInputDataMissingAlert = false
    
    @State private var TripTitle = ""
    @State private var notes = ""
    @State private var tripCost = 0.0


    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1     // Pick from Photo Library
    @State private var ratingIndex = 1
    @State private var releaseDate = Date()
    @State private var EndDate = Date()

    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
    let ratings = ["1" , "2", "3", "4", "5"]
    
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
       
        // Set maximum date to 2 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())!
        return minDate...maxDate
    }
    
    let tripCostFormatter: NumberFormatter = {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.groupingSize = 3
            return numberFormatter
        }()

    var body: some View {
        Form {
            Group {
                Section(header: Text("Trip Title")) {
                    TextField("Enter a Title for your Trip", text: $TripTitle)
                }
                Section(header: Text("Trip Cost")) {
                        TextField("Cost", value: $tripCost, formatter: tripCostFormatter)
                            .keyboardType(.numbersAndPunctuation)
                    }
                Section(header: Text("Trip Rating")) {
                    VStack {
                        Picker("Take or Pick Photo", selection: $ratingIndex) {
                            ForEach(0 ..< ratings.count, id: \.self) {
                                Text(self.ratings[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    }
                Section(header: Text("Trip Notes"), footer:
                                        Button(action: {
                                            self.dismissKeyboard()
                                        }) {
                                            Image(systemName: "keyboard")
                                                .font(Font.title.weight(.light))
                                                .foregroundColor(.blue)
                                        }
                            ) {
                                TextEditor(text: $notes)
                                    .frame(height: 100)
                                    .font(.custom("Helvetica", size: 14))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                            }
                Section(header: Text("Start Date")) {
                    DatePicker(
                        selection: $releaseDate,
                        in: dateClosedRange,
                        displayedComponents: .date) {
                            Text("Start Date")
                        }
                }
                
                Section(header: Text("End Date")) {
                    DatePicker(
                        selection: $EndDate,
                        in: dateClosedRange,
                        displayedComponents: .date) {
                            Text("End Date")
                        }
                }
            }   // End of Group
            .alert(isPresented: $showSongAddedAlert, content: { self.songAddedAlert })
            Group {
                Section(header: Text("Add Trip Photo")) {
                    VStack {
                        Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                            ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                                Text(self.photoTakeOrPickChoices[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                       
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            Text("Get Photo")
                                .padding()
                        }
                    }   // End of VStack
                }
                Section(header: Text("Album Cover Photo")) {
                    photoImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                    Spacer()
                }
            }   // End of Group
 
        }   // End of Form
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(.words)
        .disableAutocorrection(true)
        .font(.system(size: 14))
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        .navigationBarTitle(Text("Add Song"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if self.inputDataValidated() {
                    self.saveNewSong()
                    self.showSongAddedAlert = true
                } else {
                    self.showInputDataMissingAlert = true
                }
            }) {
                Text("Save")
            })
       
        .sheet(isPresented: self.$showImagePicker) {
            /*
             🔴 We pass $showImagePicker and $photoImageData with $ sign into PhotoCaptureView
             so that PhotoCaptureView can change them. The @Binding keywork in PhotoCaptureView
             indicates that the input parameter is passed by reference and is changeable (mutable).
             */
            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                             photoImageData: self.$photoImageData,
                             cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
       
    }   // End of body
   
    var photoImage: Image {
       
        if let imageData = self.photoImageData {
            // The public function is given in UtilityFunctions.swift
            let imageView = getImageFromBinaryData(binaryData: imageData, defaultFilename: "DefaultTripPhoto")
            return imageView
        } else {
            return Image("DefaultTripPhoto")
        }
    }
   
    /*
     ------------------------
     MARK: - trip Added Alert
     ------------------------
     */
    var songAddedAlert: Alert {
        Alert(title: Text("Trip Added!"),
              message: Text("New Trip is added to your Trip list."),
              dismissButton: .default(Text("OK")) {
                  // Dismiss this View and go back
                  self.presentationMode.wrappedValue.dismiss()
            })
    }
    func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
   
    /*
     --------------------------------
     MARK: - Input Data Missing Alert
     --------------------------------
     */
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: artist name, album name, song name, and genre."),
              dismissButton: .default(Text("OK")) )
    }
   
    /*
     -----------------------------
     MARK: - Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
 
        if self.TripTitle.isEmpty || self.notes.isEmpty {
            return false
        }
       
        return true
    }
   
    /*
     ---------------------
     MARK: - Save New trip
     ---------------------
     */
    func saveNewSong() {
       
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
       
        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        // Obtain DatePicker's selected date, format it as yyyy-MM-dd, and convert it to String
        let releaseDateString = dateFormatter.string(from: self.releaseDate)
        let endDateString = dateFormatter.string(from: self.EndDate)

        /*
         =====================================================
         Create an instance of the trip Entity and dress it up
         =====================================================
        */
       
        // ❎ Create a new trip entity in CoreData managedObjectContext
        let newTrip = Trip(context: self.managedObjectContext)
       
        // ❎ Dress up the new Song entity
        var Tcost = newTrip.cost!.doubleValue
        var Trating = newTrip.rating!.intValue
        newTrip.title = self.TripTitle
        newTrip.notes = self.notes
        Tcost  = self.tripCost
        newTrip.startDate = releaseDateString
        newTrip.endDate = endDateString
       // Trating = self.ratings[ratingIndex]
        
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
        */
       
        // ❎ Create a new Photo entity in CoreData managedObjectContext
        let newPhoto = Photo(context: self.managedObjectContext)
        
//        var lat = newPhoto.latitude!.doubleValue
//        var long = newPhoto.longitude!.doubleValue
//        newPhoto.dateTime = self.
//        lat = trav.photoLatitude
//        long = trav.photoLongitude
       
        // ❎ Dress up the new Photo entity
        if let imageData = self.photoImageData {
            newPhoto.tripPhoto = imageData
        } else {
            // Obtain the album cover default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "DefaultTripPhoto")
           
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
           
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            newPhoto.tripPhoto = photoData!
        }
       
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
       
        // Establish One-to-One Relationship between trip and Photo
        newTrip.photo = newPhoto
        newPhoto.Trip = newTrip
       
        /*
         =============================================
         MARK: - ❎ Save Changes to Core Data Database
         =============================================
         */
       
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of function
 
}
 
 
 
