import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import '../grocery_bloc/grocery_bloc.dart';
import '../grocery_bloc/grocery_event.dart';
import '../grocery_bloc/grocery_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //class SearchScreen extends StatelessWidget {
  //  const SearchScreen({super.key});
  //bool istyped = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          SizedBox(height: 40),
          _buildSearchField(context),
          _buildResults(),
        ],
      ),
    );
  }

  // 🔍 SEARCH FIELD
  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          context.read<GroceryBloc>().add(SearchGroceryEvent(value));
        },
        decoration: InputDecoration(
          hintText: "Search groceries...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // 🧺 RESULTS LIST
  Widget _buildResults() {
    return Expanded(
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          if (state.filteredItems.isEmpty) {
            return const Center(
              child: Text(
                "Oops! No items found...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.filteredItems.length,
            itemBuilder: (_, index) {
              final item = state.filteredItems[index];

              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(item.image, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightText,
                      ),
                    ),
                    Text(
                      "Rs ${item.price}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },

        /*return ListView.builder(
            itemCount: state.filteredItems.length,
            itemBuilder: (_, index) {
              final item = state.filteredItems[index];

              return ListTile(
                leading: Image.asset(item.image, width: 40),
                title: Text(item.name),
                subtitle: Text("Rs ${item.price}"),
              );
            },
          );*/
      ),
    );
  }
}
