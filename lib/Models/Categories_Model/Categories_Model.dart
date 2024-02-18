
class CategoriesModel {
  bool? status;
  CategoriesModelData? data;

  CategoriesModel.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];
    data = json['data']!= null ?  CategoriesModelData.fromJson(json['data']) : null;
  }

}

class CategoriesModelData
{
    int? currentPage;
    List<PageData> data = [];
    String? firstPageUrl;

    CategoriesModelData.fromJson(Map<String,dynamic> json)
    {
      json['data'].forEach((element)
      {
        data.add(PageData.fromJson(element));
      });
      currentPage = json['current_page'];
      firstPageUrl = json['first_page_url'];
    }

}



  class PageData
  {
    int? id;
    String? name;
    String? image;

    PageData.fromJson(Map<String,dynamic> json)
    {
      id = json['id'];
      name = json['name'];
      image = json['image'];
    }
  }