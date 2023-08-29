import 'dart:convert';

import 'package:apiexample/Models/productmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<ProductsModel> getproductapi() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      return ProductsModel.fromJson(data);
    } else {
      return ProductsModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<ProductsModel>(
                future: getproductapi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.products?.length ?? 0,
                      itemBuilder: (context, index) {
                        final product = snapshot.data?.products?[index];
                        if (product != null) {
                          // Build your list item using the 'product' object
                          return ListTile(
                            title: Text(product.title ?? 'No Title'),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.description ??
                                    'No Description Found'),
                                Text(product.price.toString()),
                                Text(product.discountPercentage.toString()),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: product.images!.length,
                                    itemBuilder: (context, positioned) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .25,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .5,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(product
                                                      .images![positioned]))),
                                        ),
                                      );
                                    },
                                  ),
                                  // Other widgets for displaying product information
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                product.thumbnail ?? '',
                              ),
                            ),
                          );
                        } else {
                          return const Text('Data Not Found');
                        }
                      },
                    );
                  } else {
                    return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Loading')
                        ]);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
