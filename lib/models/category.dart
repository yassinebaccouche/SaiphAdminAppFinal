class Category {
  String thumbnail;
  String name;
  String noOfCourses;

  Category({
    required this.name,
    required this.noOfCourses,
    required this.thumbnail,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Utilisateurs',
    noOfCourses: 'Ajout Utilisateur',
    thumbnail: 'assets/icons/laptop.jpg',
  ),
  Category(
    name: 'Cadeaux',
    noOfCourses: 'Ajout Cadeau',
    thumbnail: 'assets/icons/accounting.jpg',
  ),
  Category(
    name: 'Posts',
    noOfCourses: 'Ajout Post',
    thumbnail: 'assets/icons/photography.jpg',
  ),
  Category(
    name: 'Notifications',
    noOfCourses: 'Ajout Notifications',
    thumbnail: 'assets/icons/design.jpg',
  ),
];
