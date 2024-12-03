package com.nbicocchi.product.controller;

import com.nbicocchi.product.persistence.model.Product;
import com.nbicocchi.product.service.ProductService;
import java.util.Optional;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/products")
public class ProductController {
  ProductService productService;

  public ProductController(ProductService productService) {
    this.productService = productService;
  }

  @GetMapping("/{uuid}")
  public Product findByUuid(@PathVariable String uuid) {
    return productService
        .findByUuid(uuid)
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
  }

  @GetMapping
  public Iterable<Product> findAll() {
    return productService.findAll();
  }

  @PostMapping
  public Product create(@RequestBody Product product) {
    return productService.save(product);
  }

  @PutMapping("/{uuid}")
  public Product update(@PathVariable String uuid,
                        @RequestBody Product product) {
    Optional<Product> optionalProject = productService.findByUuid(uuid);
    optionalProject.orElseThrow(
        () -> new ResponseStatusException(HttpStatus.NOT_FOUND));
    product.setId(optionalProject.get().getId());
    return productService.save(product);
  }

  @DeleteMapping("/{uuid}")
  public void delete(@PathVariable String uuid) {
    Optional<Product> optionalProject = productService.findByUuid(uuid);
    optionalProject.orElseThrow(
        () -> new ResponseStatusException(HttpStatus.NOT_FOUND));
    productService.delete(optionalProject.get());
  }
}
