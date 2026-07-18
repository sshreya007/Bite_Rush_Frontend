import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/usecases/update_profile.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserEntity user;

  const EditProfilePage({super.key, required this.user});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final result = await ref.read(updateProfileProvider)(
      UpdateProfileParams(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(failure.message), backgroundColor: AppColors.error),
        );
      },
      (updatedUser) {
        ref.invalidate(
            currentUserProvider); // refetch so Profile page shows the new data
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Profile updated'),
              backgroundColor: AppColors.success),
        );
      },
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
              const Text(
                'Edit Profile',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.labelText),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                  label: 'Name',
                  hint: 'Enter name',
                  controller: _nameController),
              const SizedBox(height: 20),
              CustomTextField(
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                  controller: _phoneController),
              const SizedBox(height: 32),
              CustomButton(
                  label: 'Save', isLoading: _isSaving, onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
