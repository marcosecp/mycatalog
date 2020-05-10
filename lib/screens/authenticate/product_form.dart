import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterbook/api/book_api.dart';
import 'package:flutterbook/models/product.dart';
import 'package:flutterbook/notifiers/product_notifier.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ProductForm extends StatefulWidget {
  final bool isUpdating;
  ProductForm({@required this.isUpdating});

  @override
  _ProductFormState createState() => _ProductFormState();
}


class _ProductFormState extends State<ProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Product _currentProduct;
  String _imageUrl;
  File _imageFile;

  @override
  void initState() {
    super.initState();
    ProductNotifier productNotifier = Provider.of<ProductNotifier>(context, listen: false);


    if (productNotifier.currentProduct != null) {
      _currentProduct = productNotifier.currentProduct;
    } else {
      _currentProduct = Product();
    }
    _imageUrl = _currentProduct.image;
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text('Image Placeholder');
    } else if (_imageFile != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(_imageFile, fit: BoxFit.cover, height: 250,),
          FlatButton(
            color: Colors.white.withOpacity(0.25),
            child: Text('Cargar nueva foto', style: TextStyle(color: Colors.white),),
            onPressed: () {
              _getLocalImage();
            },
          ),
        ],
      );
    } else if (_imageUrl != null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(_imageUrl, fit: BoxFit.cover, height: 250,),
          FlatButton(
            color: Colors.white.withOpacity(0.25),
            child: Text('Cargar nueva foto', style: TextStyle(color: Colors.white),),
            onPressed: () {
              _getLocalImage();
            },
          ),
    ],
      );
    }

  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality:  50,
        maxWidth: 400,);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  _saveProduct() {
    print('saving');
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    print('form saved');

    uploadProductandImage(_currentProduct, widget.isUpdating, localFile: _imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveProduct();
          Navigator.pop(context);
        },
        child: Icon(FontAwesomeIcons.save, color: Colors.white,),
        elevation: 10,
        splashColor: Colors.yellow[100],
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: Text(widget.isUpdating ? 'Editar Producto' : 'Anadir Producto', style: TextStyle(color: Colors.yellow, fontFamily: 'Aladin', fontSize: 25,),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              _showImage(),
              SizedBox(height: 16,),
              Text(widget.isUpdating ? 'Editar' : 'Anadir', textAlign: TextAlign.center,),
              _imageFile == null && _imageUrl == null ?
              ButtonTheme(
                buttonColor: Colors.pink,
                child: RaisedButton(
                  color: Colors.pink,
                  child: Text('Add image', style: TextStyle(color: Colors.white),),
                ),
              ) : SizedBox(height: 20),
              TextFormField(
                initialValue: _currentProduct.name,
                decoration: InputDecoration(labelText: 'Nombre'),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Name is required';
                  }
                  if (val.length < 3 || val.length > 20) {
                    return 'El nombre debe llevar mas de tres y menos de 20 caracteres.';
                  }
                  return null;
                },
                onSaved: (val) {
                  _currentProduct.name = val;
                },
              ),
              TextFormField(
                initialValue: _currentProduct.description,
                decoration: InputDecoration(labelText: 'Descripcion'),
                maxLines: 4,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Description is required';
                  }
                  if (val.length < 10) {
                    return 'El nombre debe llevar mas de 10 caracteres.';
                  }
                  return null;
                },
                onSaved: (val) {
                  _currentProduct.description = val;
                },
              ),
              TextFormField(
                initialValue: _currentProduct.price.toString(),
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 20),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Precio is required';
                  }
                  return null;
                },
                onSaved: (val) {
                  _currentProduct.price = int.parse(val);
                },
              ),
              TextFormField(
                initialValue: _currentProduct.category,
                decoration: InputDecoration(labelText: 'Categoria opcional'),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                validator: (val) {
                  return null;
                },
                onSaved: (val) {
                  _currentProduct.category = val;
                },
              ),
            ],
          ),

        ),
      ),
    );
  }
}
