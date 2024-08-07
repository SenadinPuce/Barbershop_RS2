import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../models/brand.dart';
import '../models/product.dart';
import '../models/type.dart';
import '../providers/product_provider.dart';
import '../utils/util.dart';
import '../widgets/CustomPhotoFormField.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product-details';
  final Product? product;
  final List<ProductBrand>? productBrands;
  final List<ProductType>? productTypes;

  const ProductDetailsScreen({
    super.key,
    this.product,
    this.productBrands,
    this.productTypes,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ProductProvider _productProvider;
  List<ProductBrand>? _productBrandsList;
  List<ProductType>? _productTypesList;
  File? _image;
  String? _base64Image;
  Product? _editedProduct;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    _productProvider = context.read<ProductProvider>();
    initForm();
  }

  Future initForm() async {
    _productBrandsList = widget.productBrands;
    _productTypesList = widget.productTypes;

    if (widget.product?.photo != null) {
      _base64Image = widget.product?.photo;
    }

    _initialValue = {
      'name': widget.product?.name,
      'description': widget.product?.description,
      'price': formatNumber(widget.product?.price).toString(),
      'productTypeId': widget.product != null
          ? _productTypesList
              ?.firstWhere(
                  (element) => element.name == widget.product?.productType)
              .id
          : null,
      'productBrandId': widget.product != null
          ? _productBrandsList
              ?.firstWhere(
                  (element) => element.name == widget.product?.productBrand)
              .id
          : null,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildForm(),
              const SizedBox(height: 20),
              _buildButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(children: [
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                name: 'name',
                validator: FormBuilderValidators.required(),
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: FormBuilderTextField(
                name: 'price',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.match(
                    r'^\d{1,3}(?:[ ,]?\d{3})*(\.\d{1,2})?$',
                    errorText: 'Enter a valid decimal number',
                  ),
                ]),
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            CustomPhotoFormField(
              name: 'photo',
              validator: (value) {
                if (_base64Image == null) {
                  return 'Please select an image';
                }
                return null;
              },
              onImageSelected: getImage,
              base64Image: _base64Image,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        FormBuilderTextField(
          name: 'description',
          maxLines: 5,
          validator: FormBuilderValidators.required(),
          decoration: InputDecoration(
              labelText: 'Description',
              hintText: _initialValue['description'] != null
                  ? ''
                  : 'Enter your description here',
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          children: [
            Expanded(
                child: FormBuilderDropdown<int>(
              name: 'productBrandId',
              validator: FormBuilderValidators.required(),
              decoration: InputDecoration(
                  labelText: 'Product brand',
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState?.fields['productBrandId']?.reset();
                    },
                  ),
                  hintText: 'Select brand'),
              items: _productBrandsList!
                  .map((item) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: item.id,
                        child: Text(item.name ?? ""),
                      ))
                  .toList(),
            )),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: FormBuilderDropdown<int>(
              name: 'productTypeId',
              validator: FormBuilderValidators.required(),
              decoration: InputDecoration(
                  labelText: 'Product type',
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState?.fields['productTypeId']?.reset();
                    },
                  ),
                  hintText: 'Select type'),
              items: _productTypesList!
                  .map((item) => DropdownMenuItem(
                        alignment: AlignmentDirectional.center,
                        value: item.id,
                        child: Text(item.name ?? ""),
                      ))
                  .toList(),
            )),
          ],
        ),
      ]),
    );
  }

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = File(result.files.single.path!);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: _isSending
              ? null
              : () {
                  if (_editedProduct != null) {
                    Navigator.of(context).pop(true);
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
          child: const Text(
            "Close",
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          onPressed: _isSending
              ? null
              : () async {
                  if (_formKey.currentState?.saveAndValidate() == true) {
                    try {
                      setState(() {
                        _isSending = true;
                      });
                      var request = Map.from(_formKey.currentState!.value);

                      request['photo'] = _base64Image;
                      request['price'] =
                          request['price'].toString().replaceAll(' ', '');

                      if (widget.product == null) {
                        _editedProduct =
                            await _productProvider.insert(request: request);
                      } else {
                        _editedProduct = await _productProvider.update(
                          widget.product!.id!,
                          request,
                        );
                      }

                      if (!context.mounted) return;
                      Navigator.of(context).pop(true);
                    } catch (e) {
                      setState(() {
                        _isSending = false;
                      });       

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Failed to save product. Please try again.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.red,
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                            textColor: Colors.white,
                          ),
                        ),
                      );
                    }
                  }
                },
          child: _isSending
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(),
                )
              : const Text("Save changes"),
        )
      ],
    );
  }
}
