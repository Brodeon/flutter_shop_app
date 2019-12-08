import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/product.dart';
import 'package:shop_flutter_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _isInit = true;
  Product _editedProduct = Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      if (_editedProduct.id != null) {
        Provider.of<ProductsProvider>(context, listen: false).updateProduct(_editedProduct);
      } else {
        Provider.of<ProductsProvider>(context, listen: false).addProduct(_editedProduct);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
     _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    if (_isInit) {
      String id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct = Provider.of<ProductsProvider>(context).findById(id);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              TextFormField(
                initialValue: _editedProduct.title,
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  this._editedProduct = Product(title: value, id: _editedProduct.id, price: _editedProduct.price, description: _editedProduct.description, imageUrl: _editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provice a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _editedProduct.price.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price',),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  this._editedProduct = Product(title: _editedProduct.title, id: _editedProduct.id, price: double.parse(value), description: _editedProduct.description, imageUrl: _editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _editedProduct.description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  this._editedProduct = Product(title: _editedProduct.title, id: _editedProduct.id, price: _editedProduct.price, description: value, imageUrl: _editedProduct.imageUrl);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long';
                  }
                  return null;
                },
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 8, right: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: _imageUrlController.text.isEmpty? Text('Enter an URL') : Image.network(_imageUrlController.text, fit: BoxFit.cover,),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    focusNode: _imageUrlFocusNode,
                    controller: this._imageUrlController,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    onSaved: (value) {
                      this._editedProduct = Product(title: _editedProduct.title, id: _editedProduct.id, price: _editedProduct.price, description: _editedProduct.description, imageUrl: value);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      if (!value.startsWith('http') && !value.startsWith('https')) {
                        return 'Please enter a valid image URL';
                      }
                      if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                        return 'Please enter a valid image type';
                      }
                      return null;
                    },
                  ),
                ),
              ],),
            ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      ),
    );
  }
}
