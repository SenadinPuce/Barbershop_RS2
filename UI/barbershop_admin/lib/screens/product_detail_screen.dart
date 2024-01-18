// ignore_for_file: use_build_context_synchronously

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
import '../widgets/master_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  Product? product;
  List<ProductBrand>? productBrands;
  List<ProductType>? productTypes;

  ProductDetailScreen({
    Key? key,
    this.product,
    this.productBrands,
    this.productTypes,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ProductProvider _productProvider;
  List<ProductBrand>? _productBrandsList;
  List<ProductType>? _productTypesList;
  File? _image;
  String? _base64Image;
  Product? editedProduct;
  bool isLoading = true;

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
      'photo': widget.product?.photo,
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

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: 'Product details',
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildForm(),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: OutlinedButton(
                              onPressed: () {
                                if (editedProduct != null) {
                                  Navigator.of(context).pop(true);
                                } else {
                                  Navigator.of(context).pop(false);
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.blue),
                              ),
                              child: const Text("Close"),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                              width: 150,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () async {
                                  if (_formKey.currentState
                                          ?.saveAndValidate() ==
                                      true) {
                                    try {
                                      var request = Map.from(
                                          _formKey.currentState!.value);

                                      request['photo'] = _base64Image;

                                      if (widget.product == null) {
                                        editedProduct = await _productProvider
                                            .insert(request: request);
                                      } else {
                                        editedProduct =
                                            await _productProvider.update(
                                          widget.product!.id!,
                                          request,
                                        );
                                      }

                                      setState(() {});

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 8.0),
                                            Text("Product saved successfully.")
                                          ],
                                        ),
                                        duration: const Duration(seconds: 1),
                                        backgroundColor: Colors.green,
                                        action: SnackBarAction(
                                          label: 'Dismiss',
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                          },
                                          textColor: Colors.white,
                                        ),
                                      ));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                child: const Text("Save changes"),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
        ));
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
                      r'^(?=\D*(?:\d\D*){1,12}$)\d+(?:\.\d{1,4})?$',
                      errorText: 'Enter a valid decimal number'),
                ]),
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Column(
              children: [
                InputDecorator(
                  decoration: InputDecoration(
                    label: const Text(
                      'Image',
                      style: TextStyle(color: Colors.blue),
                    ),
                    errorText: null,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: _base64Image != null
                      ? SizedBox(
                          height: 150,
                          width: 120,
                          child: imageFromBase64String(_base64Image!),
                        )
                      : const SizedBox(
                          height: 150,
                          width: 150,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No image selected',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.add_photo_alternate,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 3),
                InkWell(
                  onTap: getImage,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo, color: Colors.orange),
                        SizedBox(width: 8.0),
                        Text(
                          'Select image',
                          style: TextStyle(color: Colors.orange),
                        ),
                        SizedBox(width: 8.0),
                        Icon(Icons.file_upload, color: Colors.orange),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
        const SizedBox(
          height: 50,
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
}
