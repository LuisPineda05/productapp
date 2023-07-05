import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:productapp/data/models/product.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/helpers/db_helper.dart';

import '../data/helpers/http_helper.dart';

class ListProducts2 extends StatefulWidget {
  const ListProducts2({super.key});

  @override
  State<ListProducts2> createState() => _ListProducts2State();
}

void saveData(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String> getData(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? value = prefs.getString(key);

  return value ?? "0";
}

String price = "";
String stock = "";

class _ListProducts2State extends State<ListProducts2> {
  List<Product>? products = [];
  HttpHelper? httpHelper;
  DbHelper2? dbHelper;

  Future initialize() async {
    await dbHelper?.openDb();

    saveData("price", (await dbHelper!.getTotalPrice()).toString());
    saveData("stock", (await dbHelper!.getTotalStock()).toString());

    price = (await getData("price"));
    stock = (await getData("stock"));

    products = List.empty();
    products = await dbHelper!.fetchAll();
    setState(() {
      products = products;
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper2();
    httpHelper = HttpHelper();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Products on DB",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 189, 95, 45),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Price: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  price!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, right: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Volver'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Stock: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  stock!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products!.length,
                itemBuilder: (context, index) {
                  return ProductItem(product: products![index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  const ProductItem({super.key, required this.product});
  final Product product;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isInDb = false;
  DbHelper2? dbHelper;

  void toggleFavorite() {
    setState(() {
      isInDb = !isInDb;
    });
  }

  @override
  void initState() {
    dbHelper = DbHelper2();
    produdctIsInDb();
    super.initState();
  }

  produdctIsInDb() async {
    await dbHelper?.openDb();
    final result = await dbHelper?.isIn(widget.product);
    setState(() {
      isInDb = result!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  widget.product.thumbnail,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: widget.product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    toggleFavorite();
                    if (!isInDb) {
                      dbHelper?.delete(widget.product);
                    } else {
                      dbHelper?.insert(widget.product);
                    }
                    saveData("price", dbHelper!.getTotalPrice().toString());
                    saveData("stock", dbHelper!.getTotalStock().toString());
                    setState(() {
                      price = dbHelper!.getTotalPrice().toString();
                      stock = dbHelper!.getTotalStock().toString();
                    });
                  },
                  child: Icon(
                    isInDb ? Icons.favorite : Icons.favorite_border,
                    color: isInDb ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: 'Description: ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: widget.product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: 'Price: ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: widget.product.price.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: 'Stock: ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: widget.product.stock.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
