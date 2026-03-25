/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.dto;

/**
 *
 * @author Admin
 */
public class StatisticReview {
    private int totalCount;
    private double averageRating;
    private int count1Star;
    private int count2Star;
    private int count3Star;
    private int count4Star;
    private int count5Star;

    public StatisticReview() {
    }

    public StatisticReview(int totalCount, double averageRating,
                           int count1Star, int count2Star, int count3Star,
                           int count4Star, int count5Star) {
        this.totalCount = totalCount;
        this.averageRating = averageRating;
        this.count1Star = count1Star;
        this.count2Star = count2Star;
        this.count3Star = count3Star;
        this.count4Star = count4Star;
        this.count5Star = count5Star;
    }

    // Getters and Setters
    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public int getCount1Star() {
        return count1Star;
    }

    public void setCount1Star(int count1Star) {
        this.count1Star = count1Star;
    }

    public int getCount2Star() {
        return count2Star;
    }

    public void setCount2Star(int count2Star) {
        this.count2Star = count2Star;
    }

    public int getCount3Star() {
        return count3Star;
    }

    public void setCount3Star(int count3Star) {
        this.count3Star = count3Star;
    }

    public int getCount4Star() {
        return count4Star;
    }

    public void setCount4Star(int count4Star) {
        this.count4Star = count4Star;
    }

    public int getCount5Star() {
        return count5Star;
    }

    public void setCount5Star(int count5Star) {
        this.count5Star = count5Star;
    }

    @Override
    public String toString() {
        return "StatisticReview{" +
                "totalCount=" + totalCount +
                ", averageRating=" + averageRating +
                ", count1Star=" + count1Star +
                ", count2Star=" + count2Star +
                ", count3Star=" + count3Star +
                ", count4Star=" + count4Star +
                ", count5Star=" + count5Star +
                '}';
    }
}

