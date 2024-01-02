# Techieminions Technical Interview

## Current Application Features

The inventory management Rails application provides high-level workflows
through product and inventory management, with behind-the-scenes order
fulfillment and lightweight employee authentication.

The product currently allows for:

* Browsing available products on the homepage
* Employee sign-in via an access code
* Employees can view recent and fulfillable orders
* Employees can fulfill orders that have appropriate in-stock inventory
* Employees can refill inventory on a per-product basis

The application's [README](./README.md) covers developer setup instructions.

## New Feature Guidance

The new features outlined below may require new database fields, restructuring
of existing values, or additional impacts either within or outside the system
(technical vs process). Consider following existing developer practices as
makes sense.

Please capture any outstanding side-effects of changes (e.g. customer support
needing to collect further information, downtime for any migrations, changes to
employee processes, or messaging around new functionality) in the corresponding
commit message. Also, make sure to add/fix test cases for the changes & new code.

## Getting Familiar

### `on_shelf` counter cache

The current version of the application has a view `product_on_shelf_quantities`
to easily refer to the amount of units available in the inventory in SQL.
However, the business is growing and that view is starting to become costly.

Implement a counter cache stored in a new column `products.on_shelf`, drop the
view, and update the existing queries. You can assume downtime to initialize the
cache, but its maintenance should be robust and free of race conditions.

### `Order#fulfillable?` needs a fix

If you study the current model, you'll see the method `Order#fulfillable?` has a
logic bug. Write a comment above the method definition explaining what has been
overlooked and possible ways to address it.

You do not need to write the fix.

## New Feature: Handle Undeliverable Orders

### Scenario

We've seen a couple of customer complaints about not receiving items on Twitter
in the past week. In the past, it's been a bad shipping address. Can we surface
these customers so our customer support team can reach out to apologize and get
an up-to-date address/additional shipping directions?

### Technical Guidance

Currently, inventory is tracked as either on-shelf or shipped. Similar to order
fulfillment, there should be a mechanism by which a fulfilled (shipped) order
can be brought through a "return" process which is handled by a particular
employee.

Once an order is marked as returned, the physical products will need to be
placed back on the shelf; until that happens, they should not show as available
inventory.

### Features / Jobs to be Done

* Currently, all employees within the system are warehouse employees, customer
  service employees have not been modelled yet. You should modify the system to
  have both roles. Please, take into account that no employee has two roles.
* As a warehouse employee responsible for tracking inventory (both within the
  warehouse and shipped to customers), I want to mark an order I receive back
  as "returned" so the inventory is eventually made available again for other
  orders. You can assume all returned products are in perfect condition and can
  be added to the inventory.
* As a warehouse employee, I want to be able to restock all returned product on
  a per-product basis to reduce the number of times I have to walk to a
  specific pick location.
* As a customer service representative responsible for high customer
  satisfaction, I want to be able to see a list of customers who've had orders
  returned so I can fix their address after talking to them. The list of
  customers with issues gets reduced as their addresses get fixed. Marking a
  customer's address as fixed has no undo in this sample application.
