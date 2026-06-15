package com.example.web_console_handheld.model;

import java.sql.Timestamp;

    public class Shipment {

        private int shipmentId;
        private int orderId;

        private String ghnOrderCode;

        private double shippingFee;

        private String shippingStatus;

        private Timestamp createdAt;

        public Shipment(){

        }
        public Shipment(int shipmentId, int orderId, String ghnOrderCode, double shippingFee, String shippingStatus, Timestamp createdAt) {
            this.shipmentId = shipmentId;
            this.orderId = orderId;
            this.ghnOrderCode = ghnOrderCode;
            this.shippingFee = shippingFee;
            this.shippingStatus = shippingStatus;
            this.createdAt = createdAt;
        }

        public int getShipmentId() {
            return shipmentId;
        }

        public int getOrderId() {
            return orderId;
        }

        public String getGhnOrderCode() {
            return ghnOrderCode;
        }

        public double getShippingFee() {
            return shippingFee;
        }

        public String getShippingStatus() {
            return shippingStatus;
        }

        public Timestamp getCreatedAt() {
            return createdAt;
        }

        public void setShipmentId(int shipmentId) {
            this.shipmentId = shipmentId;
        }

        public void setOrderId(int orderId) {
            this.orderId = orderId;
        }

        public void setGhnOrderCode(String ghnOrderCode) {
            this.ghnOrderCode = ghnOrderCode;
        }

        public void setShippingFee(double shippingFee) {
            this.shippingFee = shippingFee;
        }

        public void setShippingStatus(String shippingStatus) {
            this.shippingStatus = shippingStatus;
        }

        public void setCreatedAt(Timestamp createdAt) {
            this.createdAt = createdAt;
        }
    }
