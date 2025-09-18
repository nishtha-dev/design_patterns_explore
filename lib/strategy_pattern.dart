import 'package:flutter/material.dart';

abstract class IShippingCostStrategy {
  late String label;
  double calculate(Order order);
}

class PriorityShippingStrategy implements IShippingCostStrategy {
  @override
  String label = 'Priority shipping';

  @override
  double calculate(Order order) => 9.99;
}

// context class 
class OrderSummary extends StatelessWidget {
  final Order order;
  final IShippingCostStrategy shippingCostsStrategy;

  const OrderSummary({
    required this.order,
    required this.shippingCostsStrategy,
  });

  double get shippingPrice => shippingCostsStrategy.calculate(order);
  double get total => order.price + shippingPrice;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Order summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            OrderSummaryRow(
              fontFamily: 'Roboto',
              label: 'Subtotal',
              value: order.price,
            ),
            const SizedBox(height: 10),
            OrderSummaryRow(
              fontFamily: 'Roboto',
              label: 'Shipping',
              value: shippingPrice,
            ),
            const Divider(),
            OrderSummaryRow(
              fontFamily: 'RobotoMedium',
              label: 'Order total',
              value: total,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSummaryRow extends StatelessWidget {
  final String fontFamily;
  final String label;
  final double value;

  const OrderSummaryRow({
    Key? key,
    required this.fontFamily,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: fontFamily),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(fontFamily: fontFamily),
          ),
        ],
      ),
    );
  }
}



enum PackageSize {
  S,
  M,
  L,
  XL,
}

class OrderItem {
  final String title;
  final double price;
  final PackageSize packageSize;

  const OrderItem({
    required this.title,
    required this.price,
    required this.packageSize,
  });

  factory OrderItem.random() {
    const packageSizeList = PackageSize.values;

    return OrderItem(
      title: 'faker.lorem.word()',
      price: 5,
      packageSize: packageSizeList[2],
    );
  }
}

class Order {
  final List<OrderItem> items = [];

 double get price =>
      items.fold(0.0, (sum, orderItem) => sum + orderItem.price);


  void addOrderItem(OrderItem orderItem) => items.add(orderItem);
}
