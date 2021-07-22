import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_store/constants.dart';
import 'package:your_store/services/firebase_services.dart';
import 'package:your_store/widgets/custom_action_bar.dart';
import 'package:your_store/widgets/image_swipe.dart';
import 'package:your_store/widgets/product_size.dart';

class ProductPage extends StatefulWidget {
  final String? productId;
  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  FirebaseServices _firebaseServices = FirebaseServices();

  String? _selectedProductSize = "0";

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }

  final SnackBar _snackBar = SnackBar(content: Text("Product added to the cart."),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: _firebaseServices.productRef.doc(widget.productId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              //Firebase document data map
             final documentData = snapshot.data!.data()!;

              //List of images
              List imageList = documentData["images"];
              List productSize = documentData["size"];

              //Set an initial size
              _selectedProductSize = productSize[0];

              return ListView(
                padding: EdgeInsets.all(0),
                children: [
                  ImageSwipe(
                    imageList: imageList,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 24.0,
                      right: 24.0,
                      bottom: 4.0,
                    ),
                    child: Text(
                      documentData["name"] ?? "",
                      style: Constants.boldHeading,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      documentData["price"] ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      documentData["desc"] ?? "",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      "Select Size",
                      style: Constants.regularDarkText,
                    ),
                  ),
                  ProductSize(
                    productSize: productSize,
                    onSelected: (size){
                      _selectedProductSize = size;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 65.0,
                          height: 65.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFDCDCDC),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          alignment: Alignment.center,
                          child: Image(
                            image: AssetImage("assets/images/tab_saved.png"),
                            height: 22.0,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await _addToCart();
                              ScaffoldMessenger.of(context).showSnackBar(_snackBar);
                            },
                            child: Container(
                              width: 65.0,
                              margin: EdgeInsets.only(
                                left: 16.0,
                              ),
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Text(
                                "Add To Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            //Loading State
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        CustomActionBar(
          hasBackArrow: true,
          hasTitle: false,
          hasBackground: false,
        ),
      ],
    ));
  }
}
