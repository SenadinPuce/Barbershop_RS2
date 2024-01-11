// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:barbershop_admin/models/photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
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

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ProductProvider _productProvider;
  List<ProductBrand>? _productBrandsList;
  List<ProductType>? _productTypesList;
  bool isLoading = true;
  List<Photo>? _productPhotos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _productPhotos = widget.product?.photos;

    _productProvider = context.read<ProductProvider>();
    initForm();
  }

  Future initForm() async {
    _productBrandsList = widget.productBrands;
    _productTypesList = widget.productTypes;

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

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title: 'Product details',
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    decoration:
                        const BoxDecoration(color: Colors.lightBlueAccent),
                    child: TabBar(
                      controller: _tabController,
                      indicator: const BoxDecoration(color: Colors.blue),
                      labelColor: Colors.white,
                      tabs: const [
                        Tab(
                          text: 'Edit product',
                          icon: Icon(Icons.edit_document),
                        ),
                        Tab(
                          text: 'Edit photos',
                          icon: Icon(Icons.image),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDetailsForm(),
                        _buildPhotoTab(),
                      ],
                    ),
                  ),
                ],
              ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildDetailsForm() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: FormBuilder(
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
                    FormBuilderValidators.numeric(),
                  ]),
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
              )
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
                        _formKey.currentState?.fields['productBrandId']
                            ?.reset();
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
                    Navigator.of(context).pop();
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
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() == true) {
                        try {
                          var request = Map.from(_formKey.currentState!.value);

                          Product? updatedProduct;

                          if (widget.product == null) {
                            updatedProduct =
                                await _productProvider.insert(request: request);
                          } else {
                            updatedProduct = await _productProvider.update(
                              widget.product!.id!,
                              request,
                            );
                          }

                          setState(() {
                            widget.product = updatedProduct;
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Product saved successfully."),
                            backgroundColor: Colors.green,
                          ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Failed to save product. Please try again.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("Save changes"),
                  ))
            ],
          ),
        ]),
      ),
    );
  }

  Widget _buildPhotoTab() {
    Future<void> _pickImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        try {
          var selectedImage = File(pickedFile.path);

          var updatedProduct = await _productProvider.uploadProductPhoto(
            widget.product!.id!,
            selectedImage,
          );

          setState(() {
            widget.product = updatedProduct;
            _productPhotos = updatedProduct.photos;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo updated successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        } on Exception catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update photo.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_productPhotos != null && _productPhotos!.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _productPhotos!.length,
                itemBuilder: (context, index) {
                  final photo = _productPhotos![index];

                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        tileColor: Colors.grey[200],
                        leading: Image.network(
                          photo.pictureUrl.toString(),
                          width: 80,
                          height: 80,
                        ),
                        title: Text('Photo: ${photo.fileName}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: photo.isMain == true
                                  ? null
                                  : () async {
                                      var updatedProduct =
                                          await _productProvider.setMainPhoto(
                                        widget.product!.id!,
                                        photo.id!,
                                      );

                                      setState(() {
                                        widget.product = updatedProduct;
                                        _productPhotos = updatedProduct.photos;
                                      });
                                    },
                              child: const Text('Set Main'),
                            ),
                            if (photo.isMain != true)
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  var updatedProduct =
                                      await _productProvider.deletePhoto(
                                          widget.product!.id!, photo.id!);

                                  setState(() {
                                    widget.product = updatedProduct;
                                    _productPhotos = updatedProduct.photos;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                },
              ),
            )
          else
            const Center(
              child: Text(
                'No photos yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton.icon(
                onPressed: widget.product?.id != null ? _pickImage : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: const Size(150, 40)),
                icon: const Icon(Icons.image),
                label: const Text('Upload Image'),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
