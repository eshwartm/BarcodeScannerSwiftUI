//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Eshwar Ramesh on 9/4/20.
//  Copyright © 2020 Eshwar Ramesh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let item1 = CartItem(itemTitle: "Apple Apple Apple Apple Apple AppleAppleAppleAppleAppleAppleAppleApple", itemPrice: 23.0, itemQuantity: 2, itemThumbnailImage: "cart_item")
        let item2 = CartItem(itemTitle: "Lemon", itemPrice: 23.0, itemQuantity: 2, itemThumbnailImage: "cart_item")
        let item3 = CartItem(itemTitle: "Carrot", itemPrice: 23.0, itemQuantity: 2, itemThumbnailImage: "cart_item")
        
        let cartItems = [item1, item2, item3]
        
        return NavigationView {
            /*List(cartItems) { cartItem in
                CartItemView(item: cartItem)
            }*/
            /*List(cartItems, rowContent: CartItemView.init)
                .onAppear {

                    // this will disable highlighting the cell when is selected
                    UITableViewCell.appearance().selectionStyle = .none

                }*/
            BarcodeScannerView()
        .navigationBarTitle("Cart")
        }
    }
}

struct CartItemView: View {
    var item: CartItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(item.itemThumbnailImage)
                    
                VStack(alignment: .leading) {
                    Text("\(item.itemTitle)")
                        .padding(.bottom)
                    Text(String(format:"%.2f", item.itemPrice))
                    
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 20) {
                    HStack {
                        Button(action: {
                            print("quantity alert")
                        }) {
                            Image("minus")
                        }.buttonStyle(PlainButtonStyle())
                        Text("\(item.itemQuantity)")
                        Button(action: {
                            print("quantity alert")
                        }) {
                            Image("plus")
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                    Button(action: {
                        print("cart remove alert")
                    }) {
                        Image(systemName: "trash")
                        .foregroundColor(.red)
                    }
                }
            }.padding()
        }
    }
}

struct CartItem: Identifiable {
    var id = UUID()
    var itemTitle: String
    var itemPrice: Double
    var itemQuantity: Int
    var itemThumbnailImage: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
