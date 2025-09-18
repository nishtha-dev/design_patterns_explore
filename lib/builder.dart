// import 'package:flutter/material.dart';

// // It has product, director , builder & concrete builders 

// abstract class Ingredient {
//   @protected
//   late List<String> allergens;
//   @protected
//   late String name;

//   List<String> getAllergens() => allergens;

//   String getName() => name;
// }
// // product 
// class Burger {
//   final List<Ingredient> _ingredients = [];
//   late double _price;

//   void addIngredient(Ingredient ingredient) => _ingredients.add(ingredient);

//   String getFormattedIngredients() =>
//       _ingredients.map((x) => x.getName()).join(', ');

//   String getFormattedAllergens() => <String>{
//         for (final ingredient in _ingredients) ...ingredient.getAllergens()
//       }.join(', ');

//   String getFormattedPrice() => '\$${_price.toStringAsFixed(2)}';

//   void setPrice(double price) => _price = price;
// }
// // Abstract builder
// abstract class BurgerBuilderBase {
//   @protected
//   late Burger burger;
//   @protected
//   late double price;

//   void createBurger() => burger = Burger();

//   Burger getBurger() => burger;

//   void setBurgerPrice() => burger.setPrice(price);

//   void addBuns();
//   void addCheese();
//   void addPatties();
//   void addSauces();
//   void addSeasoning();
//   void addVegetables();
// }
// // Concrete builder
// class McChickenBuilder extends BurgerBuilderBase {
//   McChickenBuilder() {
//     price = 1.29;
//   }

//   @override
//   void addBuns() {
//     burger.addIngredient(RegularBun());
//   }

//   @override
//   void addCheese() {
//     // Not needed
//   }

//   @override
//   void addPatties() {
//     burger.addIngredient(McChickenPatty());
//   }

//   @override
//   void addSauces() {
//     burger.addIngredient(Mayonnaise());
//   }

//   @override
//   void addSeasoning() {
//     // Not needed
//   }

//   @override
//   void addVegetables() {
//     burger.addIngredient(ShreddedLettuce());
//   }
// }
// // Concrete builder
// class BigMacBuilder extends BurgerBuilderBase {
//   BigMacBuilder() {
//     price = 3.99;
//   }

//   @override
//   void addBuns() {
//     price.abs();
//     burger.addIngredient(BigMacBun());
//   }

//   @override
//   void addCheese() {
//     burger.addIngredient(Cheese());
//   }

//   @override
//   void addPatties() {
//     burger.addIngredient(BeefPatty());
//   }

//   @override
//   void addSauces() {
//     burger.addIngredient(BigMacSauce());
//   }

//   @override
//   void addSeasoning() {
//     burger.addIngredient(GrillSeasoning());
//   }

//   @override
//   void addVegetables() {
//     burger.addIngredient(Onions());
//     burger.addIngredient(PickleSlices());
//     burger.addIngredient(ShreddedLettuce());
//   }
// }

// // Director uses Concrete builder to create a product
// class BurgerMaker {
//   BurgerMaker(this.burgerBuilder);

//   BurgerBuilderBase burgerBuilder;

//   void changeBurgerBuilder(BurgerBuilderBase burgerBuilder) {
//     this.burgerBuilder = burgerBuilder;
//   }

//   Burger getBurger() => burgerBuilder.getBurger();

//   void prepareBurger() {
//     burgerBuilder.createBurger();
//     burgerBuilder.setBurgerPrice();

//     burgerBuilder.addBuns();
//     burgerBuilder.addCheese();
//     burgerBuilder.addPatties();
//     burgerBuilder.addSauces();
//     burgerBuilder.addSeasoning();
//     burgerBuilder.addVegetables();
//   }
// }


// class BuilderExample extends StatefulWidget {
//   const BuilderExample();

//   @override
//   _BuilderExampleState createState() => _BuilderExampleState();
// }

// class _BuilderExampleState extends State<BuilderExample> {
//   final _burgerMaker = BurgerMaker(HamburgerBuilder());
//   final List<BurgerMenuItem> _burgerMenuItems = [];

//   late BurgerMenuItem _selectedBurgerMenuItem;
//   late Burger _selectedBurger;

//   @override
//   void initState() {
//     super.initState();

//     _burgerMenuItems.addAll([
//       BurgerMenuItem(label: 'Hamburger', burgerBuilder: HamburgerBuilder()),
//       BurgerMenuItem(
//         label: 'Cheeseburger',
//         burgerBuilder: CheeseburgerBuilder(),
//       ),
//       BurgerMenuItem(label: 'Big Mac\u00AE', burgerBuilder: BigMacBuilder()),
//       BurgerMenuItem(
//         label: 'McChicken\u00AE',
//         burgerBuilder: McChickenBuilder(),
//       )
//     ]);

//     _selectedBurgerMenuItem = _burgerMenuItems[0];
//     _selectedBurger = _prepareSelectedBurger();
//   }

//   Burger _prepareSelectedBurger() {
//     _burgerMaker.prepareBurger();

//     return _burgerMaker.getBurger();
//   }

//   void _onBurgerMenuItemChanged(BurgerMenuItem? selectedItem) => setState(() {
//         _selectedBurgerMenuItem = selectedItem!;
//         _burgerMaker.changeBurgerBuilder(selectedItem.burgerBuilder);
//         _selectedBurger = _prepareSelectedBurger();
//       });

//   @override
//   Widget build(BuildContext context) {
//     return ScrollConfiguration(
//       behavior: const ScrollBehavior(),
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(
//           horizontal: LayoutConstants.paddingL,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Text(
//                   'Select menu item:',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ],
//             ),
//             DropdownButton(
//               value: _selectedBurgerMenuItem,
//               items: _burgerMenuItems
//                   .map<DropdownMenuItem<BurgerMenuItem>>(
//                     (BurgerMenuItem item) => DropdownMenuItem(
//                       value: item,
//                       child: Text(item.label),
//                     ),
//                   )
//                   .toList(),
//               onChanged: _onBurgerMenuItemChanged,
//             ),
//             const SizedBox(height: LayoutConstants.spaceL),
//             Row(
//               children: <Widget>[
//                 Text(
//                   'Information:',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ],
//             ),
//             const SizedBox(height: LayoutConstants.spaceM),
//             BurgerInformationColumn(burger: _selectedBurger),
//           ],
//         ),
//       ),
//     );
//   }
// }
