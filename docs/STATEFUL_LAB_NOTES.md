# Stateful Lab Notes — Mini Shopping Cart

**Name:** Jimmy D. Abenoja
**Section:** IQEA3
**App:** `stateful_lab_abenoja`

## Objective

Build a small shopping cart screen that shows how a **StatefulWidget** keeps and
updates its own data, while its child widgets stay **stateless**.

## Requirements checklist

- [x] `CartScreen` is a `StatefulWidget` and owns all of the app data.
- [x] `CartItem` model holds `name`, `price`, `quantity`, and `gotIt`.
- [x] Scrollable item list with `ListView.builder`.
- [x] Every change goes through `setState()`:
  - increase / decrease quantity (1–99)
  - toggle the *got it* checkbox
  - add a new item
  - clear all checked items
- [x] Summary bar shows item count, got-it count, and the computed total.
- [x] Add-item form validates the name and the price before inserting.
- [x] `CartItemTile` is a `StatelessWidget` — it only renders data and calls
  the callbacks that the parent passes in.
- [x] Screenshot of the running app saved in `screenshot/app.png`.

## Where the state lives

| Widget            | Type           | Responsibility                                  |
| ----------------- | -------------- | ----------------------------------------------- |
| `CartScreen`      | `StatefulWidget` | list of items, text controllers, error strings, total |
| `CartItemTile`    | `StatelessWidget` | renders one row, forwards button callbacks      |

## Derived values

- Total = Σ (`price` × `quantity`) over every item, formatted to 2 decimals.
- Got-it counter = number of items whose `gotIt` is `true`.

## How to run

```bash
flutter pub get
flutter run -d chrome      # or: flutter run -d web-server --web-port=8080
```

## How to test

```bash
flutter test
```

The widget tests cover the initial render, the quantity buttons, form
validation, adding an item, the got-it counter, and *Clear checked*.

## Screenshot

![App screenshot](../screenshot/app.png)
