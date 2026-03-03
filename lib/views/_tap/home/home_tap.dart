import 'package:baton/models/enum/category.dart';
import 'package:baton/views/_tap/home/widgets/category_chip.dart';
import 'package:baton/views/_tap/home/widgets/product_item.dart';
import 'package:flutter/material.dart';

class HomeTap extends StatelessWidget {
  const HomeTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          const Icon(Icons.notifications),
          const SizedBox(width: 10),
          const Icon(Icons.more_vert),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: Category.values.length,
                itemBuilder: (context, index) {
                  return CategoryChip(label: Category.values[index].name);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.7,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return const ProductItem(postId: '1');
                },
                itemCount: 10,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SizedBox(
          width: 100,
          height: 40,
          child: FloatingActionButton.extended(
            icon: const Icon(Icons.add, size: 16),
            onPressed: () {},
            label: const Text("상품 등록"),
          ),
        ),
      ),
    );
  }
}
