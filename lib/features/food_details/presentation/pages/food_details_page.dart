import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../cart/presentation/pages/cart_page.dart';

class FoodDetailsPage extends ConsumerStatefulWidget {
  final MenuItemEntity item;

  const FoodDetailsPage({super.key, required this.item});

  @override
  ConsumerState<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends ConsumerState<FoodDetailsPage> {
  // Static add-on options for now — not backend-driven yet, since
  // MenuItem doesn't model per-item customization options. Swap for
  // real data if/when you add an `addons` field to MenuItem.
  final Map<String, bool> _addons = {'Cheese': false, 'Extra Sauce': false, 'Fries': false};
  final _instructionController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  void _addToCart() {
    final selectedAddons = _addons.entries.where((e) => e.value).map((e) => e.key).toList();

    ref.read(cartProvider.notifier).addItem(
          menuItemId: widget.item.id,
          name: widget.item.name,
          price: widget.item.price,
          image: widget.item.image,
          quantity: _quantity,
          addons: selectedAddons,
          specialInstruction: _instructionController.text.trim(),
        );

    // Capture these BEFORE popping — after pop() this page's own
    // context becomes invalid, but a NavigatorState/ScaffoldMessengerState
    // captured now stays valid since they belong to ancestor widgets
    // that remain mounted, not to this page.
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    navigator.pop();

    messenger.showSnackBar(
      SnackBar(
        content: Text('${widget.item.name} added to cart'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            navigator.push(MaterialPageRoute(builder: (_) => const CartPage()));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: -1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Color(0xFFFFC93C),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 18),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 4),
              const Text('Order', style: TextStyle(fontSize: 12, color: AppColors.hintText)),
              const SizedBox(height: 4),
              const Text(
                'Customize Order',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.labelText),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.item.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: AppColors.primaryOrange.withOpacity(0.2),
                                  child: const Icon(Icons.restaurant, color: AppColors.primaryOrange),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.item.name,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rs ${widget.item.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryOrange,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Add-ons', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                ..._addons.keys.map((label) {
                                  return InkWell(
                                    onTap: () => setState(() => _addons[label] = !_addons[label]!),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _addons[label]! ? Icons.check_box : Icons.check_box_outline_blank,
                                            size: 16,
                                            color: AppColors.primaryOrange,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(label, style: const TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('Special Instruction', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _instructionController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText: 'e.g. No onions, please',
                            hintStyle: const TextStyle(fontSize: 13, color: AppColors.hintText),
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.inputBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.inputBorder),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _QuantityButton(
                                icon: Icons.remove,
                                onTap: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              _QuantityButton(
                                icon: Icons.add,
                                onTap: () => setState(() => _quantity++),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(label: 'Add to Cart', onPressed: _addToCart),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 14,
        backgroundColor: AppColors.primaryOrange,
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
