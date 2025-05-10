//
//  ContentView.swift
//  KastuGO_CoreChallenge02
//
//  Created by Kelvin Ongko Hakim on 03/05/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var meals: [MealData] = [
        MealData(name: "Kelvin’s Meal", items: sampleItems1, totalPrice: 35000),
        MealData(name: "Sam’s Meal", items: sampleItems2, totalPrice: 28000),
    ]
    
    @State var isAddingMeal = false
    @State var newMealName = ""
    @State private var selectedMeal: MealData? = nil
    
    var body: some View {
        
        NavigationStack {
            VStack {
                HStack {
                    
                    Text("KastuGO")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Spacer()
                    
//                    Button(action: {
//                        print("Menu tapped")
//                    }) {
//                        Image(systemName: "heart.circle")
//                            .imageScale(.large)
//                            .padding(.trailing)
//                    }
                    
                    Button(action: {
                        print("Menu tapped")
                    }) {
                        Image(systemName: "book.pages.fill")
                            .imageScale(.large)
                            .padding(.trailing)
                    }
                    
                    Button(action: {
                        print("Menu tapped")
                    }) {
                        Image(systemName: "clock")
                            .imageScale(.large)
                            .padding(.trailing)
                    }
                    .padding()
                }
                
                
                //List for Meals
                List {
                    ForEach($meals) { $meal in
                        NavigationLink(destination: MealPage(meal: meal)) {
                            MealCard(meal: $meal)
                        }
                        .buttonStyle(.plain) // ← this hides the arrow
                        .listRowInsets(EdgeInsets()) // remove default insets
                        .listRowBackground(Color.clear) // make the row background transparent
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 8) // add vertical padding between each card
                        
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                if let index = meals.firstIndex(where: { $0.id == meal.id }) {
                                    meals.remove(at: index)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .contentShape(Rectangle()) // ensures the tap area matches only the visible area
                    
                    }
                    //add meal button
                    Button(action: {
                        isAddingMeal = true
                        newMealName = ""
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .listRowSeparator(.hidden) // ← hide separator on button row too
                        .padding(.vertical, 10)
                        
                    }
                    .listStyle(.plain)
                    .background(Color(.systemBackground))
                    
                    .padding(.horizontal)
                    .sheet(isPresented: $isAddingMeal) {
                        NavigationView {
                            Form {
                                TextField("New Meal Name", text: $newMealName)
                            }
                            .navigationTitle("Add Meal")
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Cancel") {
                                        isAddingMeal = false
                                    }
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Add") {
                                        let newMeal = MealData(name: newMealName, items: [], totalPrice: 0)
                                        meals.append(newMeal)
                                        isAddingMeal = false
                                    }
                                    .disabled(newMealName.isEmpty)
                                }
                            }
                        }
                    }
                    Spacer()
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain) // use plain style (no sections, no grouped background)
                .listRowSeparator(.hidden)
                .background(Color(.systemBackground)) // match the overall screen background
                
                
                
                
                //CheckOut Button
                Button(action: {
                    print("Checkout tapped")
                }) {
                    Text("CHECKOUT")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        
    }
}


// MARK: - Reusable Meal Card
struct MealCard: View {
    @Binding var meal: MealData
    @State var isExpanded = false
    @State var isEditingName = false
    @State var tempName = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                
                Text(meal.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Button(action: {
                    tempName = meal.name
                    isEditingName = true
                }) {
                    Image(systemName: "pencil")
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
                
                    .sheet(isPresented: $isEditingName) {
                        NavigationView {
                            Form {
                                TextField("Meal name", text: $tempName)
                            }
                            .navigationTitle("Edit Name")
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Cancel") {
                                        isEditingName = false
                                    }
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Save") {
                                        meal.name = tempName
                                        isEditingName = false
                                    }
                                }
                            }
                        }
                    }
            }
            
            if isExpanded {
                Text("Item list")
                    .font(.subheadline)
                
                ForEach(meal.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text("Rp. \(item.price.formattedWithSeparator())")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text("\(item.quantity)x")
                    }
                }
            } else {
                Text("\(meal.items.count) Item")
                    .font(.subheadline)
            }
            
            Divider()
            
            HStack {
                Text("Total Rp. \(meal.totalPrice.formattedWithSeparator())")
                    .bold()
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.right")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// MARK: - Models
struct MealData: Identifiable {
    let id = UUID()
    var name: String
    var items: [MealItem]
    var totalPrice: Int
    
}

struct MealItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let quantity: Int
    var mealimage: Image?
    
}

let sampleItems1 = [
    MealItem(name: "Item A", price: 5000, quantity: 1, mealimage: Image("phototest")),
    MealItem(name: "Item B", price: 10000, quantity: 1, mealimage: Image("phototest2")),
    MealItem(name: "Item C", price: 5000, quantity: 1),
    MealItem(name: "Item D", price: 8000, quantity: 1),
    MealItem(name: "Item E", price: 7000, quantity: 1)
]

let sampleItems2 = [
    MealItem(name: "Nasi", price: 5000, quantity: 1),
    MealItem(name: "Ayam Asam Manis", price: 10000, quantity: 1),
    MealItem(name: "Sayur Asem", price: 5000, quantity: 1),
    MealItem(name: "Mie Goreng", price: 8000, quantity: 1)
]

// MARK: - Helper Formatter
extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
#Preview {
    ContentView()
}
