import 'package:flutter/material.dart';
import 'package:your_store/constants.dart';
import 'package:your_store/screens/product_page.dart';

class ProductCart extends StatelessWidget {
  final String? productId;
  final Function? onPressed;
  final String? imageUrl;
  final String? title;
  final String? price;
ProductCart({this.onPressed, this.imageUrl, this.title, this.price, this.productId,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductPage(
                  productId: productId,
                )));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0)),
        height: 350.0,
        margin: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 24.0,
        ),
        child: Stack(
          children: [
            Container(
              height: 350.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: imageUrl == null ? Placeholder()
                    : Image.network(
                  "$imageUrl",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title! ,
                      style: Constants.regularHeading,
                    ),
                    Text(
                      price!,
                      style: TextStyle(
                        fontSize: 21.0,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
