import 'package:flutter/material.dart';
import 'package:flutterbook/api/book_api.dart';
import 'package:flutterbook/notifiers/product_notifier.dart';
import 'package:flutterbook/screens/authenticate/product_detail.dart';
import 'package:flutterbook/screens/authenticate/product_form.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  @override
  void initState() {
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    getProducts(productNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context, listen: true);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productNotifier.currentProduct = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return ProductForm(isUpdating: false);
            },),
          );
        },
        child: Icon(FontAwesomeIcons.plus, color: Colors.white,),
        elevation: 10,
        splashColor: Colors.yellow[100],
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8,),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  borderRadius: BorderRadius.all(Radius.circular(10.0),),
                    ),
                margin: EdgeInsets.only(top: 8, left: 10, right: 10,),
                padding: EdgeInsets.only(bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        productNotifier.currentProduct = productNotifier.productList[index];
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return ProductDetail();
                            },),
                        );
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(productNotifier.productList[index].image != null ? productNotifier.productList[index].image : 'https://cdn.sallysbakingaddiction.com/wp-content/uploads/2017/09/best-pumpkin-cake-600x900.jpg', fit: BoxFit.cover, height: 180, width: 325,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(productNotifier.productList[index].name, style: TextStyle(fontSize: 22, color: Colors.black, fontFamily: 'RobotoSlab'),),
                              Text(productNotifier.productList[index].description, style: TextStyle(fontSize: 16, color: Colors.black54, fontFamily: 'Roboto'),),
                            ],
                          ),
                          Spacer(),
                          Text('\$${productNotifier.productList[index].price.toString()}', style: TextStyle(fontSize: 18, color: Colors.black87, fontFamily: 'Roboto'),),
                        ],
                      ),
                    ),
                    ],
                ),

              ),
            );
          },
          itemCount: productNotifier.productList.length),
    );
  }
}
