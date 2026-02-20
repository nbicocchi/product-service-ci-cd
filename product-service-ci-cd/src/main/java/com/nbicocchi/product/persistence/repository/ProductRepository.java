package com.nbicocchi.product.persistence.repository;

import com.nbicocchi.product.persistence.model.Product;
import java.util.Optional;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends CrudRepository<Product, Long> {
  Optional<Product> findByUuid(String name);
}
