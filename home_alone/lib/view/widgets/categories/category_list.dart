import 'package:flutter/material.dart';
import 'package:home_alone/view/widgets/categories/category_list_item.dart';
import 'package:home_alone/viewmodel/category_selection_model.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  CategoryList(this.fromSettings);
  final bool fromSettings;

  @override
  Widget build(BuildContext context) {
    return Consumer<CategorySelectionModel>(
      builder: (context, model, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          shrinkWrap: true,
          children: _buildListItems(model),
        ),
      ),
    );
  }

  List<Widget> _buildListItems(CategorySelectionModel model) {
    if (model.categories.isEmpty) {
      return [];
    }
    return model.categories
        .map((f) => CategoryListItem(category: f, fromSettings: fromSettings))
        .toList();
  }
}
