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
commit message.

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

Currently, all employees within the system are warehouse employees.

### Features / Jobs to be Done

* As a warehouse employee responsible for tracking inventory (both within the
  warehouse and shipped to customers), I want to mark an order I receive back
  as "returned" so the inventory is eventually made available again for other
  customers.
* As a customer service representative responsible for high customer
  satisfaction, I want to be able to see a list of customers assigned to me
  who've had orders returned so I can fix their address after talking to them
  on the phone or over email.
* As a warehouse employee, I want to be able to restock all returned product on
  a per-product basis to reduce the number of times I have to walk to a
  specific pick location.
