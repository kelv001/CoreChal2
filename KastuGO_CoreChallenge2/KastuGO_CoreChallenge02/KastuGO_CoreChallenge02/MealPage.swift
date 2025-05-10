//
//  MealPage.swift
//  KastuGO_CoreChallenge02
//
//  Created by Kelvin Ongko Hakim on 04/05/25.
//

import SwiftUI

class MealPageViewModel:ObservableObject {
    @Published var selectedItem: MealItem? = nil
}

struct MealPage: View {
    var meal: MealData
    
    @State private var searchText = ""
    @StateObject private var viewModel = MealPageViewModel()
    @State private var isShowingModal = false
    
    var body: some View {
        VStack {
            // Search Bar
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(20)
                
                Button(action: {
                    // Filter action
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .font(.title2)
                }
                .padding(.leading, 8)
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Category title
            HStack {
                Text("Chicken")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // List of items
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(meal.items) { item in
                        HStack {
                            if let image = item.mealimage {
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(20)
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                                    .cornerRadius(20)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline)
                                Text("Rp. \(item.price.formattedWithSeparator())")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Button(action: {
                                    // Decrease quantity action
                                }) {
                                    Image(systemName: "minus")
                                        .frame(width: 30, height: 30)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(6)
                                }
                                
                                Text("\(item.quantity)")
                                    .font(.body)
                                    .frame(minWidth: 20)
                                
                                Button(action: {
                                    // Increase quantity action
                                }) {
                                    Image(systemName: "plus")
                                        .frame(width: 30, height: 30)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .onTapGesture {
                            
                            viewModel.selectedItem = item

                            isShowingModal = true
                        }
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            
            Spacer()
            
            // Checkout Button
            Button(action: {
                // Checkout action
            }) {
                Text("CHECKOUT")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .navigationTitle(Text("\(meal.name)'s List"))
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $isShowingModal) {
            
            if let selectedItem = viewModel.selectedItem {
                
                VStack(spacing: 20) {
                    if let image = selectedItem.mealimage {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(20)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                            .cornerRadius(20)
                    }
                    
                    Text(selectedItem.name)
                        .font(.title)
                        .bold()
                    
                    Text("Delicious meal description goes here.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                .presentationDetents([.medium]) // optional, to control height
                .presentationDragIndicator(.visible) // shows swipe down indicator
            }
        }
        
    }
}

#Preview {
    MealPage(meal: MealData(name: "Meal", items: [
        MealItem(name: "Test", price: 10000, quantity: 1),
        
    ], totalPrice: 10))
}
