class ProductSearchFilter {
  int? productTypeId;
  int? productBrandId;
  String? name;
  bool includeProductTypes;
  bool includeProductBrands;
  bool includeProductPhotos;
  String? sortBy;
  int pageIndex;
  int pageSize;

  ProductSearchFilter({
    this.productTypeId,
    this.productBrandId,
    this.name,
    this.includeProductTypes = true,
    this.includeProductBrands = true,
    this.includeProductPhotos = true,
    this.sortBy,
    this.pageIndex = 1,
    this.pageSize = 50,
  });

  Map<String, dynamic> toMap() {
    return {
      'productTypeId': productTypeId,
      'productBrandId': productBrandId,
      'name': name,
      'includeProductTypes': includeProductTypes,
      'includeProductBrands': includeProductBrands,
      'includeProductPhotos': includeProductPhotos,
      'sortBy': sortBy,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
    };
  }
}
