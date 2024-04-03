import 'package:barbershop_mobile/models/brand.dart';
import 'package:barbershop_mobile/models/product.dart';
import 'package:barbershop_mobile/models/type.dart';
import 'package:barbershop_mobile/providers/cart_provider.dart';
import 'package:barbershop_mobile/providers/product_brand_provider.dart';
import 'package:barbershop_mobile/providers/product_provider.dart';
import 'package:barbershop_mobile/providers/product_type_provider.dart';
import 'package:barbershop_mobile/screens/cart_screen.dart';
import 'package:barbershop_mobile/screens/product_details_screen.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:barbershop_mobile/widgets/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductsListScreen extends StatefulWidget {
  static const routeName = '/products';
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final GlobalKey<FormFieldState> _typeKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _brandKey = GlobalKey<FormFieldState>();

  late ProductProvider _productProvider;
  late ProductBrandProvider _productBrandProvider;
  late ProductTypeProvider _productTypeProvider;
  late CartProvider _cartProvider;

  List<Product>? _products;
  List<ProductBrand>? _productBrandsList;
  List<ProductType>? _productTypesList;

  TextEditingController _productNameController = TextEditingController();
  String? _sortBy = "name";
  ProductBrand? _selectedBrand;
  ProductType? _selectedType;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    _productProvider = context.read<ProductProvider>();
    _productBrandProvider = context.read<ProductBrandProvider>();
    _productTypeProvider = context.read<ProductTypeProvider>();
    _cartProvider = context.read<CartProvider>();

    if (_productBrandsList == null) {
      var brands = await _productBrandProvider.get();
      _productBrandsList = List.from(brands);
    }

    if (_productTypesList == null) {
      var types = await _productTypeProvider.get();
      _productTypesList = List.from(types);
    }

    var productsData = await _productProvider.get(
      filter: {
        'name': _productNameController.text,
        'productBrandId': _selectedBrand?.id,
        'productTypeId': _selectedType?.id,
        'sortBy': _sortBy,
        'includeProductTypes': true,
        'includeProductBrands': true,
      },
    );

    setState(() {
      _products = productsData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildProductSearch(),
          _buildView(),
          const SizedBox(
            height: 80,
          )
        ],
      )),
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
      Positioned(
        bottom: 16.0,
        right: 16.0,
        child: FloatingActionButton.extended(
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CartScreen()));
          },
          backgroundColor: Colors.amber[700],
          label: const Text("Your Cart"),
          icon: const Icon(
            Icons.shopping_bag_outlined,
          ),
        ),
      )
    ]);
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: Text(
          "Products",
          style: GoogleFonts.tiltNeon(color: Colors.black, fontSize: 35),
        ),
      ),
    );
  }

  Widget _buildProductSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
                controller: _productNameController,
                onSubmitted: (value) async {
                  setState(() {
                    isLoading = true;
                  });
                  loadData();
                },
                decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey)))),
          ),
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: Column(children: [
              IconButton(
                icon: const Icon(Icons.sort_outlined),
                onPressed: () {
                  _showSortModal(context);
                },
              ),
              const Text("Sort by")
            ])),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
            child: Column(children: [
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () {
                  _showFiltersModal(context);
                },
              ),
              const Text("Filters")
            ])),
      ],
    );
  }

  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Alphabetical'),
              value: 'name',
              groupValue: _sortBy,
              onChanged: (value) {
                _updateSortBy(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Price: Low to High'),
              value: 'priceAsc',
              groupValue: _sortBy,
              onChanged: (value) {
                _updateSortBy(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Price: High to Low'),
              value: 'priceDesc',
              groupValue: _sortBy,
              onChanged: (value) {
                _updateSortBy(value!);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _updateSortBy(String? value) {
    setState(() {
      _sortBy = value;
      isLoading = true;
    });
    loadData();
  }

  void _showFiltersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Select Type',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<ProductType>(
                    key: _typeKey,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Select type',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedType = null;
                            _typeKey.currentState?.reset();
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    value: _selectedType,
                    items: _productTypesList?.map((ProductType type) {
                          return DropdownMenuItem<ProductType>(
                            value: type,
                            child: Text(type.name.toString()),
                          );
                        }).toList() ??
                        [],
                    onChanged: (ProductType? newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                  ),
                  const Divider(),
                  const Text(
                    'Select Brand',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField<ProductBrand>(
                    key: _brandKey,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Select brand',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedBrand = null;
                            _brandKey.currentState?.reset();
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    value: _selectedBrand,
                    items: _productBrandsList?.map((ProductBrand brand) {
                          return DropdownMenuItem<ProductBrand>(
                            value: brand,
                            child: Text(brand.name.toString()),
                          );
                        }).toList() ??
                        [],
                    onChanged: (ProductBrand? newValue) {
                      setState(() {
                        _selectedBrand = newValue;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey),
                          child: const Text('Close'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            Navigator.pop(context);
                            loadData();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('Search'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildView() {
    if (isLoading) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.5),
          children: _buildProductsCardList(),
        ),
      );
    }
  }

  List<Widget> _buildProductsCardList() {
    List<Widget> list = _products!
        .map((p) => Card(
              elevation: 3,
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                child: Column(children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                      product: p,
                                    )));
                      },
                      child: imageFromBase64String(p.photo!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.name ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatNumber(p.price)} \$',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onPressed: () {
                      _cartProvider.addToCart(p);
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                  ),
                ]),
              ),
            ))
        .cast<Widget>()
        .toList();

    return list;
  }
}
