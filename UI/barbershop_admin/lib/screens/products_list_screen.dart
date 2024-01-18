// ignore_for_file: use_build_context_synchronously

import 'package:barbershop_admin/screens/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/brand.dart';
import '../models/product.dart';
import '../models/type.dart';
import '../providers/product_brand_provider.dart';
import '../providers/product_provider.dart';
import '../providers/product_type_provider.dart';
import '../utils/util.dart';
import '../widgets/master_screen.dart';
import 'product_detail_screen.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  late ProductProvider _productProvider;
  late ProductBrandProvider _productBrandProvider;
  late ProductTypeProvider _productTypeProvider;
  List<Product>? products;
  TextEditingController _productNameController = TextEditingController();
  List<ProductBrand>? _productBrandsList;
  ProductBrand? _selectedBrand;
  List<ProductType>? _productTypesList;
  ProductType? _selectedType;
  String? _sortBy;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    _productProvider = context.read<ProductProvider>();
    _productBrandProvider = context.read<ProductBrandProvider>();
    _productTypeProvider = context.read<ProductTypeProvider>();

    if (_productBrandsList == null) {
      var brands = await _productBrandProvider.get();
      _productBrandsList = List.from(brands);
    }

    if (_productTypesList == null) {
      var types = await _productTypeProvider.get();
      _productTypesList = List.from(types);
    }

    var productData = await _productProvider.get(filter: {
      'name': _productNameController.text,
      'productBrandId': _selectedBrand?.id,
      'productTypeId': _selectedType?.id,
      'sortBy': _sortBy,
      'includeProductTypes': true,
      'includeProductBrands': true,
      'includeProductPhotos': true,
    });

    setState(() {
      products = productData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Products",
      child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearch(),
              const SizedBox(
                height: 8,
              ),
              _buildDataListView()
            ],
          )),
    );
  }

  Widget _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Product name",
              contentPadding: EdgeInsets.all(0),
            ),
            controller: _productNameController,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<ProductBrand>(
            decoration: InputDecoration(
                labelText: "Brand",
                contentPadding: const EdgeInsets.all(0),
                suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedBrand = null;
                      });
                    },
                    icon: const Icon(Icons.close)),
                hintText: 'Select brand'),
            value: _selectedBrand,
            items: _productBrandsList?.map((ProductBrand brand) {
              return DropdownMenuItem<ProductBrand>(
                alignment: AlignmentDirectional.center,
                value: brand,
                child: Text(brand.name.toString()),
              );
            }).toList(),
            onChanged: (ProductBrand? newValue) {
              setState(() {
                _selectedBrand = newValue;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<ProductType>(
            decoration: InputDecoration(
                labelText: "Type",
                contentPadding: const EdgeInsets.all(0),
                suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedType = null;
                      });
                    },
                    icon: const Icon(Icons.close)),
                hintText: 'Select type'),
            value: _selectedType,
            items: _productTypesList?.map((ProductType type) {
              return DropdownMenuItem<ProductType>(
                alignment: AlignmentDirectional.center,
                value: type,
                child: Text(type.name.toString()),
              );
            }).toList(),
            onChanged: (ProductType? newValue) {
              setState(() {
                _selectedType = newValue;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String?>(
            decoration: InputDecoration(
              labelText: "Sort by",
              contentPadding: const EdgeInsets.all(0),
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    _sortBy = null;
                  });
                },
                icon: const Icon(Icons.close),
              ),
              hintText: 'Sort by',
            ),
            value: _sortBy,
            items: {
              'Alphabetical': 'name',
              'Price: Low to High': 'priceAsc',
              'Price: High to Low': 'priceDesc',
            }.entries.map<DropdownMenuItem<String>>(
                (MapEntry<String, String> entry) {
              return DropdownMenuItem<String>(
                alignment: AlignmentDirectional.center,
                value: entry.value,
                child: Text(entry.key),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _sortBy = newValue;
              });
            },
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
              setState(() {
                isLoading = true;
              });
              loadProducts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text("Search"),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: 150,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              isLoading = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                        productBrands: _productBrandsList,
                        productTypes: _productTypesList,
                      )));

              if (isLoading) {
                setState(() {
                  loadProducts();
                });
              }
            },
            child: const Text("Add new product"),
          ),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: DataTable(
              showCheckboxColumn: false,
              columns: const [
                DataColumn(
                  label:
                      Text('ID', style: TextStyle(fontStyle: FontStyle.italic)),
                ),
                DataColumn(
                  label: Text('Name',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ),
                DataColumn(
                  label: Text('Price',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ),
                DataColumn(
                  label: Text('Brand',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ),
                DataColumn(
                  label: Text('Type',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ),
                DataColumn(
                  label: Text('Picture',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ),
                DataColumn(
                  label: Text('Edit',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ),
                DataColumn(
                  label: Text('Delete',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ),
              ],
              rows: (products ?? [])
                  .map((Product p) => DataRow(cells: [
                        DataCell(Text(p.id.toString())),
                        DataCell(Text(p.name.toString())),
                        DataCell(Text(formatNumber(p.price))),
                        DataCell(Text(p.productBrand.toString())),
                        DataCell(Text(p.productType.toString())),
                        DataCell(p.photo != ""
                            ? Container(
                                padding: const EdgeInsets.all(1),
                                width: 100,
                                height: 100,
                                child: imageFromBase64String(p.photo!),
                              )
                            : const Text("")),
                        DataCell(IconButton(
                          icon: const Icon(
                            Icons.edit_document,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            _editProduct(p);
                          },
                        )),
                        DataCell(IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteProduct(p);
                          },
                        ))
                      ]))
                  .toList(),
            )),
    );
  }

  void _editProduct(Product p) async {
    isLoading = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
              product: p,
              productBrands: _productBrandsList,
              productTypes: _productTypesList,
            )));
    if (isLoading) {
      setState(() {
        loadProducts();
      });
    }
  }

  void _deleteProduct(Product p) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text(
                'Are you sure you want to delete this product? This action is not reversible.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")),
              ElevatedButton(
                child: const Text("Yes"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await _productProvider.delete(p.id!);

                    setState(() {
                      products?.removeWhere((element) => element.id == p.id);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text("Product deleted successfully.")
                        ],
                      ),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.green,
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        textColor: Colors.white,
                      ),
                    ));
                  } catch (e) {
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
                              'Failed to delete product. Please try again.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          textColor: Colors.white,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        });
  }
}
