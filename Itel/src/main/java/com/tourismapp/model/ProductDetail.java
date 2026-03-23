package com.tourismapp.model;

/**
 *
 * @author Admin
 */
public class ProductDetail {

    private int detailId;
    private Product product;
    private Attribute attribute;
    private String attributeValue;

    public ProductDetail() {
    }

    public ProductDetail(int detailId, Product product, Attribute attribute, String attributeValue) {
        this.detailId = detailId;
        this.product = product;
        this.attribute = attribute;
        this.attributeValue = attributeValue;
    }
    
    public ProductDetail(Product product, Attribute attribute, String attributeValue) {
        this.product = product;
        this.attribute = attribute;
        this.attributeValue = attributeValue;
    }

    public int getDetailId() {
        return detailId;
    }

    public void setDetailId(int detailId) {
        this.detailId = detailId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Attribute getAttribute() {
        return attribute;
    }

    public void setAttribute(Attribute attribute) {
        this.attribute = attribute;
    }

    public String getAttributeValue() {
        return attributeValue;
    }

    public void setAttributeValue(String attributeValue) {
        this.attributeValue = attributeValue;
    }

    @Override
    public String toString() {
        return "ProductDetail{"
                + "detailId=" + detailId
                + ", product=" + (product != null ? product.getProductId() : "null")
                + ", attribute=" + (attribute != null ? attribute.getAttributeId() : "null")
                + ", attributeValue='" + attributeValue + '\''
                + '}';
    }
}
