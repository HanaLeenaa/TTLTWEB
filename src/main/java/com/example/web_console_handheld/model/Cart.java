package com.example.web_console_handheld.model;

import java.io.Serializable;
import java.util.*;

public class Cart implements Serializable {
    Map<Integer, CartItem> cartItems;

    public Cart(){
        cartItems = new HashMap<>();
    }
    public Map<Integer, CartItem> getCartItems() {
        return cartItems;
    }
    public void addProduct(Product p, int quantity){
        int id = p.getID();
        if (cartItems.containsKey(id))
            cartItems.get(id).increaseQuantity(quantity);
        else cartItems.put(id, new CartItem(p, quantity));

    }
}
