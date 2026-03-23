package com.tourismapp.model;

import com.tourismapp.common.PaymentMethod;
import com.tourismapp.common.Status;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payment {

    private int paymentId;
    private Orders order;
    private LocalDateTime paymentDate;
    private PaymentMethod paymentMethod;
    private BigDecimal amount;
    private Status status;

    public Payment() {
    }

    public Payment(int paymentId, Orders order, LocalDateTime paymentDate,
            PaymentMethod paymentMethod, BigDecimal amount, Status status) {
        this.paymentId = paymentId;
        this.order = order;
        this.paymentDate = paymentDate;
        this.paymentMethod = paymentMethod;
        this.amount = amount;
        this.status = status;
    }
    
    public Payment(Orders order, LocalDateTime paymentDate,
            PaymentMethod paymentMethod, BigDecimal amount, Status status) {
        this.order = order;
        this.paymentDate = paymentDate;
        this.paymentMethod = paymentMethod;
        this.amount = amount;
        this.status = status;
    }
    
    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public Orders getOrder() {
        return order;
    }

    public void setOrder(Orders order) {
        this.order = order;
    }

    public LocalDateTime getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDateTime paymentDate) {
        this.paymentDate = paymentDate;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Payment{"
                + "paymentId=" + paymentId
                + ", order=" + (order != null ? order.getOrderId() : "null")
                + ", paymentDate=" + paymentDate
                + ", paymentMethod=" + paymentMethod
                + ", amount=" + amount
                + ", status=" + status
                + '}';
    }
}
