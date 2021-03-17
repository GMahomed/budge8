class CategoryLimits{

  final String category;
  int limit;

  CategoryLimits(this.category)
  {
    limit = 0;
  }

  String getCategory()
  {
    return category;
  }

  int getLimit()
  {
    return limit;
  }

  void setLimit(int newLimit)
  {
    limit = newLimit;
  }

  bool isNotEmpty()
  {
    if(category == '')
      {
        return false;
      }
    return true;
  }
}