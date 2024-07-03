import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/brand.dart';
import '../models/product.dart';
import '../models/type.dart';
import '../providers/product_brand_provider.dart';
import '../providers/product_provider.dart';
import '../providers/product_type_provider.dart';
import '../utils/util.dart';
import 'product_details_screen.dart';

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
  final TextEditingController _productNameController = TextEditingController();
  List<ProductBrand>? _productBrandsList;
  int? _selectedBrandId;
  List<ProductType>? _productTypesList;
  int? _selectedTypeId;
  String? _sortBy;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    _productProvider = context.read<ProductProvider>();
    _productBrandProvider = context.read<ProductBrandProvider>();
    _productTypeProvider = context.read<ProductTypeProvider>();

    var brandsData = await _productBrandProvider.get();
    _productBrandsList = brandsData;

    var typesData = await _productTypeProvider.get();
    _productTypesList = typesData;

    setState(() {
      _productBrandsList = brandsData;
      _productTypesList = typesData;
    });

    loadProducts();
  }

  loadProducts() async {
    var productData = await _productProvider.get(filter: {
      'name': _productNameController.text,
      'productBrandId': _selectedBrandId,
      'productTypeId': _selectedTypeId,
      'sortBy': _sortBy,
      'includeProductTypes': true,
      'includeProductBrands': true,
      'includeProductPhotos': true,
    });

    setState(() {
      products = productData;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearch(),
            const SizedBox(
              height: 20,
            ),
            _buildDataListView()
          ],
        ));
  }

  Widget _buildSearch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: "Product name",
              hintText: "Enter product name",
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
            controller: _productNameController,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: InputDecoration(
              labelText: "Brand",
              hintText: 'Select brand',
              alignLabelWithHint: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedBrandId = null;
                    });
                  },
                  icon: const Icon(Icons.close)),
            ),
            value: _selectedBrandId,
            items: _productBrandsList?.map((brand) {
              return DropdownMenuItem<int>(
                alignment: AlignmentDirectional.center,
                value: brand.id,
                child: Text(brand.name.toString()),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedBrandId = newValue;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: InputDecoration(
              labelText: "Type",
              hintText: 'Select type',
              alignLabelWithHint: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedTypeId = null;
                    });
                  },
                  icon: const Icon(Icons.close)),
            ),
            value: _selectedTypeId,
            items: _productTypesList?.map((ProductType type) {
              return DropdownMenuItem<int>(
                alignment: AlignmentDirectional.center,
                value: type.id,
                child: Text(type.name.toString()),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedTypeId = newValue;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String?>(
            isExpanded: true,
            decoration: InputDecoration(
              labelText: "Sort by",
              hintText: 'Sort by',
              alignLabelWithHint: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    _sortBy = null;
                  });
                },
                icon: const Icon(Icons.close),
              ),
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
        ElevatedButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            loadProducts();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(213, 178, 99, 1),
          ),
          child: const Text("Search"),
        ),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
          ),
          onPressed: () async {
            _isLoading = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      productBrands: _productBrandsList,
                      productTypes: _productTypesList,
                    )));

            if (_isLoading) {
              setState(() {});
              loadProducts();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  textColor: Colors.white,
                ),
              ));
            }
          },
          child: const Text("Add product"),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: SingleChildScrollView(
                child: DataTable(
              showCheckboxColumn: false,
              dataRowMaxHeight: 70,
              headingRowColor: MaterialStateColor.resolveWith(
                (states) {
                  return const Color.fromRGBO(236, 239, 241, 1);
                },
              ),
              columns: const [
                DataColumn(
                  label: Expanded(
                    child: Text('Name',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('Price',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('Brand',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('Type',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('Picture',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('Edit',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text('Delete',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
              rows: (products ?? [])
                  .map((Product p) => DataRow(cells: [
                        DataCell(Text(p.name.toString())),
                        DataCell(Text(formatNumber(p.price))),
                        DataCell(Text(p.productBrand.toString())),
                        DataCell(Text(p.productType.toString())),
                        DataCell(p.photo != null
                            ? Container(
                                width: 70,
                                height: 70,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: imageFromBase64String(p.photo!),
                                ),
                              )
                            : const Text("")),
                        DataCell(IconButton(
                          icon: const Icon(
                            Icons.edit_document,
                            color: Color.fromRGBO(84, 181, 166, 1),
                          ),
                          onPressed: () {
                            _editProduct(p);
                          },
                        )),
                        DataCell(IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Color(0xfff71133),
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
    _isLoading = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
              product: p,
              productBrands: _productBrandsList,
              productTypes: _productTypesList,
            )));
    if (_isLoading) {
      setState(() {});
      loadProducts();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          textColor: Colors.white,
        ),
      ));
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
              OutlinedButton(
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

                    if (!context.mounted) return;

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
