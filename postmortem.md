# Post-Mortem Report

## Overview

This post-mortem documents three major updates to the system:

1. Replacing the costly SQL view `product_on_shelf_quantities` with a `products.on_shelf` counter cache.
2. Identifying and documenting a logic bug in `Order#fulfillable?`.
3. Implementing a new feature to support processing and restocking returned (undeliverable) orders, and supporting customer service workflows.

---

## Counter Cache: `products.on_shelf`

### Problem

The system previously used a SQL view called `product_on_shelf_quantities` to determine inventory levels. As the business scaled, this view became a significant performance bottleneck.

### Solution

#### Schema Changes

- Added `on_shelf` column to the `products` table to store inventory count directly.

#### Migration Strategy

1. Created a migration to populate the `on_shelf` column from the `product_on_shelf_quantities` view.
2. Dropped the `product_on_shelf_quantities` view in a follow-up migration.
3. Removed the `ProductOnShelfQuantity` model.

#### Code Changes

* Invoked `update_on_shelf_counter` in:

  * `ReceiveProductService`
  * `RestockReturnedProductService`
  * `ShipInventoryService`

### Result

* Improved query performance by removing reliance on a costly view.
* Ensured accuracy and consistency using `with_lock` for atomic counter updates.
* Fully removed legacy view and model.

---

## `Order#fulfillable?` Bug

### Problem

The `Order#fulfillable?` method incorrectly returned `true` for orders that were already `fulfilled` or `returned`.

### Documentation Fix

Added a comment above the method:

```ruby
# bug: An order which has already been fulfilled or returned is being considered as fulfillable.
# it can be fixed as follow:
#   def fulfillable?
#     !fulfilled? && !returned? && line_items.all?(&:fulfillable?)
#   end
```

### Result

* The bug is now documented for future developers.
* Clarifies the expected behavior and logic for order fulfillment.

---

## New Feature: Returned Orders Workflow

### Business Need

* Some customers report not receiving orders due to bad addresses.
* Need to track returned items and notify customer support to take action.

---

### Functional Additions

#### Roles & Access Control

* Introduced two roles: `warehouse_employee` and `customer_service_employee`.
* Enforced role exclusivity: no employee can hold both roles.
* Access-controlled routes using:

#### Handling Returned Orders

* Added new status `returned` in `InventoryStatusChange`.

* Implemented `ReturnOrderService`:

  * Marks order as returned.
  * "Returned items are not included in the on_shelf count until explicitly restocked"
  * Changes `inventory.status` to `returned`.
  * Creates a `ReturnedOrderHistory` record per product.

---

#### Restocking Returned Products

* Implemented `RestockReturnedProductService`:

  * Restocks products on a per-product basis.
  * Sets inventory status to `on_shelf`.
  * Updates `Product#on_shelf` count via `update_on_shelf_counter`.

---

#### Customer Support Workflow

* Scope to fetch returned orders:

* Added `AddressesController`:

  * CS can mark a customer’s address as fixed.
  * Once marked fixed, address changes are irreversible.

---

### Testing & QA

* Verified inventory updates at each transition (`received`, `shipped`, `returned`, `restocked`).
* Validated access control for both roles.
* Ensured that once an address is marked fixed, it cannot be changed again.
