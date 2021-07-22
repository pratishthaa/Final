import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:your_store/widgets/custom_action_bar.dart';
import 'package:your_store/widgets/product_cart.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productRef =
  FirebaseFirestore.instance.collection("Products");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productRef.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                //Display data in List View
                return ListView(
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children:
                  snapshot.data!.docs.map((QueryDocumentSnapshot document) {
                    // Map<String, dynamic> data = document.data();
                    final dynamic data = document.data();

                    return ProductCart(
                      title: data["name"],
                      imageUrl: data["images"][0],
                      price: "₹${data["price"]}",
                      productId: document.id,
                    );
                  }).toList(),
                );
              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            title: "Home",
            hasBackArrow: false,
          ),
        ],
      ),
    );
  }
}