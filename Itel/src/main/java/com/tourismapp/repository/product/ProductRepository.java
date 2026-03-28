package com.tourismapp.repository.product;

import com.tourismapp.common.Status;
import com.tourismapp.entity.Brand;
import com.tourismapp.entity.Category;
import com.tourismapp.entity.Product;
import com.tourismapp.entity.ProductImage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import java.util.stream.Collectors;

@Repository
public class ProductRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final String GET_ACTIVE_PRODUCTS = "SELECT * FROM Product WHERE status = 'active';";
    private static final String GET_ALL_PRODUCTS = "SELECT * FROM Product;";
    private static final String FIND_PRODUCT_BY_ID = "SELECT * FROM Product WHERE product_id = ?";
    private static final String CREATE_PRODUCT = "INSERT INTO Product (name, description, price, stock_quantity, category_id, brand_id, image_url) VALUES (?, ?, ?, ?, ?, ?, ?);";
    private static final String EDIT_PRODUCT = "UPDATE Product SET name = ?, description = ?, price = ?, stock_quantity = ?, category_id = ?, brand_id = ?, image_url = ?, status = ?, updated_at = GETDATE() WHERE product_id = ?";
    private static final String DELETE_PRODUCT = "UPDATE Product SET status = 'inactive' WHERE product_id = ?;";
    private static final String GET_PRODUCT_NEXT_ID = "SELECT MAX(product_id) FROM Product";
    private static final String SEARCH_PRODUCTS_BY_NAME = "SELECT * FROM Product WHERE name LIKE ?";
    private static final String SEARCH_ACTIVE_PRODUCTS_BY_NAME = "SELECT * FROM Product WHERE name LIKE ? AND status = 'active';";

    private static final String GET_PRODUCT_IMAGES_BY_ID = "SELECT * FROM ProductImages WHERE product_id = ?";
    private static final String GET_INFO_PRODUCT_BY_ID = "SELECT a.name, pd.attribute_value, a.unit FROM ProductDetail pd JOIN Attribute a ON pd.attribute_id = a.attribute_id WHERE pd.product_id = ?;";
    private static final String GET_PRODUCTS_BY_CATEGORY = "SELECT * FROM Product WHERE category_id = ?";
    private static final String MAP_CATEGORY_ID = "SELECT category_id FROM Category WHERE LOWER(name) = LOWER(?)";
    private static final String MAP_BRAND_ID = "SELECT brand_id FROM Brand WHERE LOWER(name) = LOWER(?)";
    private static final String GET_PRODUCT_DETAIL_BY_ID_TOP_5 = "SELECT p.attribute_value, a.unit FROM ProductDetail p JOIN Attribute a ON p.attribute_id = a.attribute_id WHERE p.product_id = ?;";

    private static final String FILTER_PRODUCTS_BY_CRITERIA = "SELECT DISTINCT p.* FROM Product p LEFT JOIN ProductDetail pd ON p.product_id = pd.product_id WHERE p.category_id = ? AND p.price BETWEEN ? AND ? AND (p.brand_id IN (SELECT brand_id FROM Brand WHERE name IN (?)) OR p.brand_id IS NULL) AND (pd.attribute_id = 1 AND pd.attribute_value IN (?))";
    private static final String GET_PRODUCTS_BY_CATEGORY_PAGINATED = "SELECT * FROM Product WHERE category_id = ? AND status = 'active' ORDER BY product_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";
    private static final String UPDATE_PRODUCT_STOCK = "UPDATE Product SET stock_quantity = ? WHERE product_id = ?";

    private static final String GET_SIMILAR_PRODUCTS_BY_PRICE = "SELECT TOP %d * FROM Product WHERE price BETWEEN ? AND ? AND product_id != ? AND status = 'active' ORDER BY ABS(price - ?) ASC;";
    private static final String GET_SIMILAR_PRODUCTS_BY_CATEGORY = "SELECT TOP %d * FROM Product WHERE category_id = ? AND product_id != ? AND status = 'active';";
    private static final String GET_SIMILAR_PRODUCTS_BY_BRAND = "SELECT TOP %d * FROM Product WHERE brand_id = ? AND product_id != ? AND status = 'active' ORDER BY ABS(price - ?) ASC;";

    private final RowMapper<Product> productRowMapper = (rs, rowNum) -> mapProduct(rs);

    public Product mapProduct(ResultSet rs) throws SQLException {
        return new Product(
                rs.getInt("product_id"),
                rs.getString("name"),
                rs.getString("description"),
                rs.getBigDecimal("price"),
                rs.getInt("stock_quantity"),
                new Category(rs.getInt("category_id")),
                new Brand(rs.getInt("brand_id")),
                rs.getString("image_url"),
                Status.valueOf(rs.getString("status").toUpperCase()),
                rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null,
                rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null
        );
    }

    public List<Product> getSimilarProductsByCategory(int categoryId, int excludeProductId, int limit) {
        String sql = String.format(GET_SIMILAR_PRODUCTS_BY_CATEGORY, limit);
        return jdbcTemplate.query(sql, productRowMapper, categoryId, excludeProductId);
    }

    public List<Product> getSimilarProductsByPrice(BigDecimal productPrice, int excludeProductId, int limit) {
        BigDecimal minPrice = productPrice.multiply(BigDecimal.valueOf(0.9));
        BigDecimal maxPrice = productPrice.multiply(BigDecimal.valueOf(1.1));
        String sql = String.format(GET_SIMILAR_PRODUCTS_BY_PRICE, limit);
        return jdbcTemplate.query(sql, productRowMapper, minPrice, maxPrice, excludeProductId, productPrice);
    }

    public List<Product> getSimilarProductsByBrand(int brandId, BigDecimal productPrice, int excludeProductId, int limit) {
        String sql = String.format(GET_SIMILAR_PRODUCTS_BY_BRAND, limit);
        return jdbcTemplate.query(sql, productRowMapper, brandId, excludeProductId, productPrice);
    }

    public List<Product> getActiveProducts() {
        return jdbcTemplate.query(GET_ACTIVE_PRODUCTS, productRowMapper);
    }

    public List<Product> getAllProducts() {
        return jdbcTemplate.query(GET_ALL_PRODUCTS, productRowMapper);
    }

    public Optional<Product> findProductById(int productId) {
        List<Product> products = jdbcTemplate.query(FIND_PRODUCT_BY_ID, productRowMapper, productId);
        return products.isEmpty() ? Optional.empty() : Optional.of(products.get(0));
    }

    public boolean createProduct(Product product) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        int affectedRows = jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(CREATE_PRODUCT, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setInt(5, product.getCategory().getCategoryId());
            ps.setInt(6, product.getBrand().getBrandId());
            ps.setString(7, product.getImageUrl());
            return ps;
        }, keyHolder);

        if (affectedRows > 0 && keyHolder.getKey() != null) {
            product.setProductId(keyHolder.getKey().intValue());
            return true;
        }
        return false;
    }

    public boolean editProduct(Product product) {
        int rowsUpdated = jdbcTemplate.update(EDIT_PRODUCT,
                product.getName(),
                product.getDescription(),
                product.getPrice(),
                product.getStockQuantity(),
                product.getCategory().getCategoryId(),
                product.getBrand().getBrandId(),
                product.getImageUrl(),
                product.getStatus().name().toLowerCase(),
                product.getProductId());
        return rowsUpdated > 0;
    }

    public boolean deleteProduct(int id) {
        int rowsUpdated = jdbcTemplate.update(DELETE_PRODUCT, id);
        return rowsUpdated > 0;
    }

    public int getNextProductId() {
        Integer maxId = jdbcTemplate.queryForObject(GET_PRODUCT_NEXT_ID, Integer.class);
        return maxId != null ? maxId + 1 : 1;
    }

    public List<Product> searchProductsByName(String q) {
        return jdbcTemplate.query(SEARCH_PRODUCTS_BY_NAME, productRowMapper, "%" + q + "%");
    }

    public List<Product> searchActiveProductsByName(String q) {
        return jdbcTemplate.query(SEARCH_ACTIVE_PRODUCTS_BY_NAME, productRowMapper, "%" + q + "%");
    }

    public Optional<List<ProductImage>> getProductImagesById(int productId) {
        List<ProductImage> productImages = jdbcTemplate.query(GET_PRODUCT_IMAGES_BY_ID, (rs, rowNum) -> new ProductImage(
                rs.getInt("image_id"),
                new Product(productId),
                rs.getString("image_url")
        ), productId);
        return Optional.of(productImages);
    }

    public Map<String, String> getInforProductById(int productId) {
        Map<String, String> infoMap = new LinkedHashMap<>();
        jdbcTemplate.query(GET_INFO_PRODUCT_BY_ID, rs -> {
            String attributeName = rs.getString("name");
            String attributeValue = rs.getString("attribute_value");
            String unit = rs.getString("unit");
            if (unit != null && !unit.isBlank()) {
                attributeValue = attributeValue + " " + unit;
            }
            infoMap.put(attributeName, attributeValue != null ? attributeValue : "No value available");
        }, productId);
        return infoMap;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        return jdbcTemplate.query(GET_PRODUCTS_BY_CATEGORY, productRowMapper, categoryId);
    }

    public Integer mapCategoryId(String name) {
        List<Integer> ids = jdbcTemplate.queryForList(MAP_CATEGORY_ID, Integer.class, name);
        return ids.isEmpty() ? null : ids.get(0);
    }

    public Integer mapBrandId(String name) {
        List<Integer> ids = jdbcTemplate.queryForList(MAP_BRAND_ID, Integer.class, name);
        return ids.isEmpty() ? null : ids.get(0);
    }

    public List<String> getProductDetailByIdTop5(int productId) {
        return jdbcTemplate.query(GET_PRODUCT_DETAIL_BY_ID_TOP_5, (rs, rowNum) -> {
            String value = rs.getString("attribute_value");
            String unit = rs.getString("unit");
            return (unit != null && !unit.isBlank()) ? value + " " + unit : value;
        }, productId);
    }

    public List<Product> filterProductsByCriteria(int categoryId, String brands, String cpus, int minPrice, int maxPrice) {
        List<String> brandList = (brands != null && !brands.isEmpty()) ? Arrays.asList(brands.split(",")) : new ArrayList<>();
        List<String> cpuList = (cpus != null && !cpus.isEmpty())
                ? Arrays.stream(cpus.split(","))
                        .map(cpu -> cpu.contains("Series") ? cpu.replace(" Series", "") : cpu)
                        .collect(Collectors.toList())
                : new ArrayList<>();

        String brandInClause = brandList.isEmpty() ? "'__EMPTY__'" : String.join(",", Collections.nCopies(brandList.size(), "?"));
        String cpuInClause = cpuList.isEmpty() ? "'__EMPTY__'" : String.join(",", Collections.nCopies(cpuList.size(), "?"));

        String sql = "SELECT DISTINCT p.* FROM Product p LEFT JOIN ProductDetail pd ON p.product_id = pd.product_id " +
                     "WHERE p.category_id = ? AND p.price BETWEEN ? AND ? " +
                     "AND (p.brand_id IN (SELECT brand_id FROM Brand WHERE name IN (" + brandInClause + ")) OR p.brand_id IS NULL) " +
                     "AND (pd.attribute_id = 1 AND pd.attribute_value IN (" + cpuInClause + "))";

        List<Object> params = new ArrayList<>();
        params.add(categoryId);
        params.add(minPrice);
        params.add(maxPrice);
        params.addAll(brandList);
        params.addAll(cpuList);

        return jdbcTemplate.query(sql, productRowMapper, params.toArray());
    }

    public List<Product> getProductsByCategoryPaginated(int categoryId, int offset, int size) {
        return jdbcTemplate.query(GET_PRODUCTS_BY_CATEGORY_PAGINATED, productRowMapper, categoryId, offset, size);
    }

    public boolean updateProductStock(int productId, int newStock) {
        int rowsUpdated = jdbcTemplate.update(UPDATE_PRODUCT_STOCK, newStock, productId);
        return rowsUpdated > 0;
    }
}
