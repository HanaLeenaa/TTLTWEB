package com.example.web_console_handheld.model;

import java.io.Serializable;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
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

    public long getTotalPrice() {
        long total = 0;
        for (CartItem item : cartItems.values()) {
            total += item.getProduct().getPriceValue() * item.getQuantity();
        }
        return total;
    }

    public String getTotalPriceFormatted() {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###", symbols);
        return df.format(getTotalPrice());
    }

    public void increase(int productID){
        CartItem item = cartItems.get(productID);
        if (item != null){
        item.increaseQuantity(1);
    }
    }
    public void decrease(int productID){
        CartItem item = cartItems.get(productID);
        if (item != null){
            if (item.getQuantity() > 1){
                item.setQuantity(item.getQuantity() - 1);

            }else{
                cartItems.remove(productID);
            }
        }
    }
    public void deleteProduct(int id) {
        cartItems.remove(id);
    }

    public void clear() {
        cartItems.clear();
    }
    public void remove(int productId) {
        if (cartItems != null) {
            cartItems.remove(productId);
        }
    }

}
