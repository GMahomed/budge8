class CreatedBudgetCategoryItem{

  String _category;
  int _limit;
  int _amountSpent;
  int _remainingBalance;

  CreatedBudgetCategoryItem(this._category, this._limit, this._amountSpent)
  {
    _remainingBalance = _limit - _amountSpent;
  }

  String getCategory()
  {
    return _category;
  }

  int getLimit()
  {
    return _limit;
  }

  void setLimit(int limit)
  {
    _limit = limit;
  }

  void setAmount(int amount)
  {
    _amountSpent = amount;
  }

  void updateRemaining()
  {
    _remainingBalance = _limit - _amountSpent;
  }

  int getAmountSpent()
  {
    return _amountSpent;
  }

  int getRemainingBalance()
  {
    return _remainingBalance;
  }
}