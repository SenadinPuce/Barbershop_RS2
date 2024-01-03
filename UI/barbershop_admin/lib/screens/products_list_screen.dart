import 'package:barbershop_admin/screens/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/brand.dart';
import '../models/product.dart';
import '../models/type.dart';
import '../providers/product_brand_provider.dart';
import '../providers/product_provider.dart';
import '../providers/product_type_provider.dart';
import '../utils/product_search_filter.dart';
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
  List<ProductBrand> _productBrandsList = [];
  List<ProductType> _productTypesList = [];
  var productsFilter = ProductSearchFilter();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    _productProvider = context.read<ProductProvider>();
    _productBrandProvider = context.read<ProductBrandProvider>();
    _productTypeProvider = context.read<ProductTypeProvider>();

    if (_productBrandsList.isEmpty) {
      var brands = await _productBrandProvider.get();
      _productBrandsList.add(ProductBrand(id: 0, name: 'All'));
      _productBrandsList.addAll(brands);
    }

    if (_productTypesList.isEmpty) {
      var types = await _productTypeProvider.get();
      _productTypesList.add(ProductType(id: 0, name: 'All'));
      _productTypesList.addAll(types);
    }

    var productData =
        await _productProvider.get(filter: productsFilter.toMap());

    setState(() {
      products = productData;
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
            onChanged: (value) {
              setState(() {
                productsFilter.name = value;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<ProductBrand>(
            items: _productBrandsList.map((ProductBrand brand) {
              return DropdownMenuItem<ProductBrand>(
                value: brand,
                child: Text(brand.name.toString()),
              );
            }).toList(),
            onChanged: (ProductBrand? newValue) {
              productsFilter.productBrandId = newValue?.id;
            },
            decoration: const InputDecoration(
              labelText: "Brand",
              contentPadding: EdgeInsets.all(0),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<ProductType>(
            items: _productTypesList.map((ProductType type) {
              return DropdownMenuItem<ProductType>(
                value: type,
                child: Text(type.name.toString()),
              );
            }).toList(),
            onChanged: (ProductType? newValue) {
              productsFilter.productTypeId = newValue?.id;
            },
            decoration: const InputDecoration(
              labelText: "Type",
              contentPadding: EdgeInsets.all(0),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            items: [
              'Sort by',
              'Alphabetical',
              'Price: Low to High',
              'Price: High to Low'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                if (newValue == 'Price: Low to High') {
                  productsFilter.sortBy = 'priceAsc';
                } else if (newValue == 'Price: High to Low') {
                  productsFilter.sortBy = 'priceDesc';
                } else if (newValue == 'Alphabetical') {
                  productsFilter.sortBy = 'name';
                } else {
                  productsFilter.sortBy = null;
                }
              });
            },
            decoration: const InputDecoration(
              labelText: "Sort by",
              contentPadding: EdgeInsets.all(0),
            ),
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductDetailScreen()));
            },
            child: const Text("Add new product"),
          ),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: SingleChildScrollView(
          child: DataTable(
        showCheckboxColumn: false,
        columns: const [
          DataColumn(
            label: Text('ID', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          DataColumn(
            label: Text('Name', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          DataColumn(
            label: Text('Price', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          DataColumn(
            label: Text('Brand', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          DataColumn(
            label: Text('Type', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          DataColumn(
            label:
                Text('Picture', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        ],
        rows: (products ?? [])
            .map((Product p) => DataRow(
                    onSelectChanged: (value) {
                      if (value == true) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                                  product: p,
                                )));
                      }
                    },
                    cells: [
                      DataCell(Text(p.id.toString())),
                      DataCell(Text(p.name.toString())),
                      DataCell(Text(formatNumber(p.price))),
                      DataCell(Text(p.productBrand.toString())),
                      DataCell(Text(p.productType.toString())),
                      DataCell(
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Image.network(
                            p.pictureUrl ?? '',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ]))
            .toList(),
      )),
    );
  }
}
