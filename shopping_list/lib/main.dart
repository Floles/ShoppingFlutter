import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: ShoppingList(
        products: <Product>[
          Product(name: 'Chocolat'),
          Product(name: 'Chips'),
          Product(name: 'Legumes'),
          Product(name: 'Fruits'),
        ],
      ),
    );
  }
}

class Product {
  const Product({required this.name});
  final String name;
}

typedef void ProductChanged(Product product, bool inCart);

class ListItems extends StatelessWidget {
  ListItems(
      {required this.product,
      required this.inCart,
      required this.onProductChanged})
      : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final ProductChanged onProductChanged;

  Color _getColor(BuildContext context) {
    return inCart ? Colors.orange.shade300 : Colors.teal.shade700;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return TextStyle(
      color: Colors.orange[300],
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onProductChanged(product, inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}

class ShoppingList extends StatefulWidget {
  ShoppingList({Key? key, required this.products}) : super(key: key);

  final List<Product> products;
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = Set<Product>();

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      if (!inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ma liste de shopping'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: widget.products.map((Product product) {
          return ListItems(
            product: product,
            inCart: _shoppingCart.contains(product),
            onProductChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}
