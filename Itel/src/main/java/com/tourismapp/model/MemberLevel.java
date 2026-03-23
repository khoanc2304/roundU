/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.tourismapp.model;

import com.tourismapp.common.MembershipLevel;
import java.math.BigDecimal;

/**
 *
 * @author Admin
 */
public class MemberLevel {

    private int levelId;
    private MembershipLevel levelName;
    private BigDecimal discountPercent;

    public MemberLevel() {
    }

    public MemberLevel(int levelId, MembershipLevel levelName, BigDecimal discountPercent) {
        this.levelId = levelId;
        this.levelName = levelName;
        this.discountPercent = discountPercent;
    }

    public MemberLevel(int levelId) {
        this.levelId = levelId;
    }

    public int getLevelId() {
        return levelId;
    }

    public void setLevelId(int levelId) {
        this.levelId = levelId;
    }

    public MembershipLevel getLevelName() {
        return levelName;
    }

    public void setLevelName(MembershipLevel levelName) {
        this.levelName = levelName;
    }

    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent;
    }

    @Override
    public String toString() {
        return "MembershipLevel{" + "levelId=" + levelId + ", levelName=" + levelName + ", discountPercent=" + discountPercent + '}';
    }

}
