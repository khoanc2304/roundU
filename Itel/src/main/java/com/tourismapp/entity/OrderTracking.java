package com.tourismapp.entity;

import com.tourismapp.common.Status;
import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "Order_Tracking")
public class OrderTracking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tracking_id")
    private int trackingId;
    
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Orders order;
    private Status status;
    private LocalDateTime updateDate;
    private String note;

    public OrderTracking() {}

    public OrderTracking(int trackingId, Orders order, Status status, LocalDateTime updateDate, String note) {
        this.trackingId = trackingId;
        this.order = order;
        this.status = status;
        this.updateDate = updateDate;
        this.note = note;
    }

    public int getTrackingId() {
        return trackingId;
    }

    public void setTrackingId(int trackingId) {
        this.trackingId = trackingId;
    }

    public Orders getOrder() {
        return order;
    }

    public void setOrder(Orders order) {
        this.order = order;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public LocalDateTime getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(LocalDateTime updateDate) {
        this.updateDate = updateDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Override
    public String toString() {
        return "OrderTracking{" +
                "trackingId=" + trackingId +
                ", orderId=" + (order != null ? order.getOrderId() : "null") +
                ", status=" + status +
                ", updateDate=" + updateDate +
                ", note='" + note + '\'' +
                '}';
    }
}