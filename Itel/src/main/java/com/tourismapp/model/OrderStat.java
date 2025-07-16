package com.tourismapp.model;

/**
 *
 * @author NamNguyen
 */
public class OrderStat {
    private int year;
    private int month;
    private int orderCount;
    private String status;
    private Integer productId; // Sử dụng Integer để cho phép null
    private String productName;
    private java.math.BigDecimal revenue;

    public OrderStat(int year, int month, int orderCount) {
        this.year = year;
        this.month = month;
        this.orderCount = orderCount;
    }

    public int getYear() { return year; }
    public int getMonth() { return month; }
    public int getOrderCount() { return orderCount; }
    public String getStatus() { return status; }
    public Integer getProductId() { return productId; }
    public String getProductName() { return productName; }
    public java.math.BigDecimal getRevenue() { return revenue; }

    public void setStatus(String status) { this.status = status; }
    public void setProductId(Integer productId) { this.productId = productId; }
    public void setProductName(String productName) { this.productName = productName; }
    public void setRevenue(java.math.BigDecimal revenue) { this.revenue = revenue; }

    @Override
    public String toString() {
        return "OrderStat{year=" + year + ", month=" + month + ", orderCount=" + orderCount +
               ", status=" + status + ", productId=" + productId + ", productName=" + productName + ", revenue=" + revenue + "}";
    }
}