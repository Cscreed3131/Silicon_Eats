class UserDataModel {
  final String userName;
  final String userSic;
  final String userBranch;
  final String userYear;
  final num userPhoneNumber;
  final String userEmail;
  final Map userCart;
  final List userRoles;
  final List userLikedItems;
  final List userOrderedFood;

  UserDataModel({
    required this.userName,
    required this.userSic,
    required this.userBranch,
    required this.userYear,
    required this.userPhoneNumber,
    required this.userEmail,
    required this.userCart,
    required this.userRoles,
    required this.userLikedItems,
    required this.userOrderedFood,
  });
}
