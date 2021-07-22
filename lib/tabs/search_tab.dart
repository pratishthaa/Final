import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:your_store/constants.dart';
import 'package:your_store/services/firebase_services.dart';
import 'package:your_store/widgets/custom_input.dart';
import 'package:your_store/widgets/product_cart.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();
  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchString.isEmpty)
            Center(
              child: Container(
                child: Text(
                  "Search Results",
                  style: Constants.regularDarkText,
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productRef.orderBy("name").startAt(
                  [_searchString]).endAt(["$_searchString\uf8ff"]).get(),
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
                      top: 130.0,
                      bottom: 12.0,
                    ),
                    children: snapshot.data!.docs.map((document) {
                      return ProductCart(
                        title: document["name"],
                        imageUrl: document["images"[0]],
                        price: "\$${document["price"]}",
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
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0,
            ),
            child: CustomInput(
              hintText: "Search hear...",
              onSubmitted: (value) {
                  setState(() {
                    _searchString = value;
                  });
              },
            ),
          ),
        ],
      ),
    );
  }
}
