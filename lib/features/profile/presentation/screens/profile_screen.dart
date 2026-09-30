import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jigrotech/core/mixins/ui_feedback_mixin.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/cms_bottom_sheet.dart';
import '../../../../core/widgets/custom_dialogs.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.onNavigateTab});

  final ValueChanged<int>? onNavigateTab;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with UiFeedbackMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().fetchProfile();
    });
  }

  void _confirmLogout(BuildContext context) {
    showLogoutDialog(
      context,
      onLogout: () async {
        await context.read<AuthCubit>().logout();
        if (context.mounted) {
          context.go('/login');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: RefreshIndicator(
        onRefresh: () => context.read<AuthCubit>().fetchProfile(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildSectionHeader("Profile", "Settings"),
                    const SizedBox(height: 15),
                    _buildListItem(
                      icon: IconsaxPlusLinear.user,
                      iconColor: AppColors.black,
                      title: "Update Profile",
                      subtitle: "Manage your personal profile details",
                      onTap: () {
                        final state = context.read<AuthCubit>().state;
                        if (state is AuthAuthenticated) {
                          _showEditProfileModal(
                            context,
                            state.user.name,
                            state.user.email ?? '',
                            state.user.profileImageUrl,
                          );
                        } else {
                          _showEditProfileModal(context, '', '', null);
                        }
                      },
                    ),
                    _buildListItem(
                      icon: IconsaxPlusLinear.clock_1,
                      iconColor: AppColors.black,
                      title: "Transaction History",
                      subtitle: "View your past transactions & bill payments",
                      onTap: () {
                        if (widget.onNavigateTab != null) {
                          widget.onNavigateTab!(2);
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    _buildSectionHeader("Security", "& Privacy"),
                    const SizedBox(height: 15),
                    _buildListItem(
                      icon: IconsaxPlusLinear.document,
                      iconColor: AppColors.black,
                      title: "Terms & Conditions",
                      subtitle: "Read terms and conditions",
                      onTap: () => CmsBottomSheet.show(
                        context,
                        title: "Terms & Conditions",
                        pageKey: "terms_conditions",
                      ),
                    ),
                    _buildListItem(
                      icon: IconsaxPlusLinear.shield_security,
                      iconColor: AppColors.black,
                      title: "Privacy & Policy",
                      subtitle: "Read our privacy policy",
                      onTap: () => CmsBottomSheet.show(
                        context,
                        title: "Privacy Policy",
                        pageKey: "privacy_policy",
                      ),
                    ),
                    _buildListItem(
                      icon: IconsaxPlusLinear.logout_1,
                      iconColor: Colors.red,
                      title: "Logout",
                      subtitle: "Log out of your account",
                      onTap: () => _confirmLogout(context),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 240,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Curve
          Positioned(
            top: -100,
            left: -150,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // User Info Section
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                String name = "User Name";
                String phone = "";
                String email = "";
                String? profileImg;

                if (state is AuthAuthenticated) {
                  final user = state.user;
                  name = user.name.isNotEmpty ? user.name : "User Name";
                  phone = user.phone;
                  email = user.email ?? "";
                  profileImg = user.profileImageUrl;
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                      ),
                      child: ClipOval(
                        child:
                            (profileImg != null &&
                                profileImg.startsWith('http'))
                            ? Image.network(
                                profileImg,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppColors.grey,
                                    ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.grey,
                              ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontSize: 20,
                              fontFamily: AppTypography.outfitBold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (phone.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              phone.startsWith('+') ? phone : "+91 $phone",
                              style: TextStyle(
                                color: AppColors.black.withValues(alpha: 0.8),
                                fontSize: 14,
                                fontFamily: AppTypography.outfitMedium,
                              ),
                            ),
                          ],
                          if (email.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                                fontFamily: AppTypography.outfitRegular,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _showEditProfileModal(
                        context,
                        name,
                        email,
                        profileImg,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.secondary, // Pink color
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String pinkText, String blackText) {
    return Row(
      children: [
        Text(
          pinkText,
          style: const TextStyle(
            color: AppColors.secondary, // Pink
            fontSize: 16,
            fontFamily: AppTypography.outfitBold,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          blackText,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontFamily: AppTypography.outfitBold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontFamily: AppTypography.outfitBold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                          fontFamily: AppTypography.outfitRegular,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.black,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200, thickness: 1, height: 1),
          ],
        ),
      ),
    );
  }

  void _showEditProfileModal(
    BuildContext context,
    String currentName,
    String currentEmail,
    String? currentAvatarUrl,
  ) {
    final nameController = TextEditingController(
      text: currentName == "User Name" ? "" : currentName,
    );
    final emailController = TextEditingController(text: currentEmail);
    String? selectedImagePath;
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 25,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 25,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Update Profile",
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontFamily: AppTypography.outfitBold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Builder(
                                builder: (context) {
                                  if (selectedImagePath != null &&
                                      selectedImagePath!.isNotEmpty) {
                                    return Image.file(
                                      File(selectedImagePath!),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColors.grey,
                                      ),
                                    );
                                  }
                                  if (currentAvatarUrl != null &&
                                      currentAvatarUrl.isNotEmpty &&
                                      currentAvatarUrl.startsWith('http')) {
                                    return Image.network(
                                      currentAvatarUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: AppColors.grey,
                                      ),
                                    );
                                  }
                                  return const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppColors.grey,
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (image != null) {
                                  setModalState(() {
                                    selectedImagePath = image.path;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Full Name",
                      style: TextStyle(
                        fontFamily: AppTypography.outfitMedium,
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z\s]'),
                        ),
                        LengthLimitingTextInputFormatter(40),
                      ],
                      decoration: InputDecoration(
                        hintText: "Enter full name",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Email Address",
                      style: TextStyle(
                        fontFamily: AppTypography.outfitMedium,
                        color: AppColors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      decoration: InputDecoration(
                        hintText: "Enter email address",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: isSubmitting
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () async {
                                  final name = nameController.text.trim();
                                  final email = emailController.text.trim();

                                  final nameReg = RegExp(r'^[a-zA-Z\s]+$');
                                  final emailReg = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                  );

                                  if (name.isEmpty) {
                                    showErrorToast(
                                      "Please enter your full name",
                                    );
                                    return;
                                  }
                                  if (!nameReg.hasMatch(name)) {
                                    showErrorToast(
                                      "Please enter a valid name (alphabets only)",
                                    );
                                    return;
                                  }
                                  if (name.length < 2) {
                                    showErrorToast(
                                      "Name must be at least 2 characters long",
                                    );
                                    return;
                                  }
                                  if (email.isEmpty) {
                                    showErrorToast(
                                      "Please enter your email address",
                                    );
                                    return;
                                  }
                                  if (!emailReg.hasMatch(email)) {
                                    showErrorToast(
                                      "Please enter a valid email address",
                                    );
                                    return;
                                  }

                                  setModalState(() => isSubmitting = true);

                                  final success = await context
                                      .read<AuthCubit>()
                                      .updateProfile(
                                        name: name,
                                        email: email,
                                        profileImage: selectedImagePath,
                                      );

                                  if (ctx.mounted) {
                                    setModalState(() => isSubmitting = false);
                                    if (success) {
                                      showLoadingToast(
                                        "Profile updated successfully",
                                      );
                                      Navigator.pop(ctx);
                                    } else {
                                      showErrorToast(
                                        "Failed to update profile",
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  "Update Profile",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                    fontFamily: AppTypography.outfitMedium,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
