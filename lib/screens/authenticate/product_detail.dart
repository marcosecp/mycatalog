import 'package:flutter/material.dart';
import 'package:flutterbook/notifiers/product_notifier.dart';
import 'package:flutterbook/screens/authenticate/product_form.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return ProductForm(isUpdating: true);
            },),
          );
        },
        child: Icon(FontAwesomeIcons.feather, color: Colors.white,),
        elevation: 10,
        splashColor: Colors.yellow[100],
      ),
      body: Column(
        children: <Widget>[
          Stack(children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10),),
                child: Image.network(productNotifier.currentProduct.image != null ? productNotifier.currentProduct.image  : 'https://cdn.sallysbakingaddiction.com/wp-content/uploads/2017/09/best-pumpkin-cake-600x900.jpg',  height: 240, width: MediaQuery.of(context).size.width, fit: BoxFit.cover
                ),),
            Container(
              height: 240.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0),),
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: FractionalOffset.center,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.white70.withOpacity(0.0),
                        Colors.black,
                      ],
                      stops: [
                        0.0,
                        1.0
                      ])),
            ),
            Positioned(
              left: 10, top: 15,
              child: IconButton(
                icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white70,),
              onPressed: () {
                  Navigator.pop(context);
              },),
            ),
            Positioned(
              left: 10,
              top: 190,
              child: Text(productNotifier.currentProduct.name, style: TextStyle(
                color: Colors.white, fontSize: 30, fontFamily: 'Aladin',
              ),),
            ),
          ],
          ),
        ],
      ),
    );
  }
}
