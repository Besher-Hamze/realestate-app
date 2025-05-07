import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/app/modules/home/controllers/home_controller.dart';
import 'package:real_estate_app/app/modules/home/views/widgets/featured_property_card.dart';
import 'package:real_estate_app/app/modules/home/views/widgets/property_card.dart';
import 'package:real_estate_app/app/modules/home/views/widgets/quick_filter_widget.dart';
import 'package:real_estate_app/app/routes/app_pages.dart';
import 'package:real_estate_app/app/utils/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('عقارات العربية'),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 26),
            onPressed: () => Get.toNamed(Routes.PROPERTY_SEARCH),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        )
            : _buildHomeContent(context),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.loadInitialData(),
      color: AppTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
              child: GetBuilder<HomeController>(
                  builder: (controller) {
                    final userName = controller.isLoggedIn() && controller.userData?.fullName != null
                        ? controller.userData!.fullName.split(' ')[0]
                        : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName != null ? 'مرحبًا $userName،' : 'مرحبًا بك،',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'اكتشف العقار المناسب لك',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
              ),
            ),

            // Search bar
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث عن عقار...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list, color: AppTheme.primaryColor, size: 20),
                      onPressed: () => Get.toNamed(Routes.PROPERTY_LIST),
                      tooltip: 'تصفية',
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintStyle: const TextStyle(color: AppTheme.secondaryTextColor),
                ),
                onSubmitted: (_) => controller.handleSearch(),
                textInputAction: TextInputAction.search,
              ),
            ),

            // Quick filters
            const QuickFilterWidget(),

            // Featured properties
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 24,
                        width: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'العقارات المميزة',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => Get.toNamed(Routes.PROPERTY_LIST),
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('عرض الكل'),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Obx(
                  () => controller.featuredProperties.isEmpty
                  ? Container(
                height: 220,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_work_outlined,
                        size: 40,
                        color: AppTheme.secondaryTextColor,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'لا توجد عقارات مميزة حاليًا',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : CarouselSlider(
                options: CarouselOptions(
                  height: 220,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.85,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
                items: controller.featuredProperties
                    .map((property) => FeaturedPropertyCard(
                  property: property,
                  onTap: () => controller.viewPropertyDetails(property.id),
                ))
                    .toList(),
              ),
            ),

            // Recent properties
            Container(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 24,
                        width: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'أحدث العقارات',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => Get.toNamed(Routes.PROPERTY_LIST),
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('عرض الكل'),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Obx(
                  () => controller.recentProperties.isEmpty
                  ? Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.dividerColor),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_work_outlined,
                        size: 40,
                        color: AppTheme.secondaryTextColor,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'لا توجد عقارات حديثة حاليًا',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                itemCount: controller.recentProperties.length,
                itemBuilder: (context, index) {
                  final property = controller.recentProperties[index];
                  return PropertyCard(
                    property: property,
                    onTap: () => controller.viewPropertyDetails(property.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            GetBuilder<HomeController>(
                builder: (controller) {
                  if (controller.isLoggedIn()) {
                    final user = controller.userData;
                    return UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      margin: EdgeInsets.zero,
                      accountName: Text(
                        user?.fullName ?? 'المستخدم',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      accountEmail: Text(
                        user?.email ?? 'user@example.com',
                        style: const TextStyle(fontSize: 14),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text(
                          user?.fullName != null && user!.fullName.isNotEmpty
                              ? user.fullName.substring(0, 1).toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return DrawerHeader(
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                      ),
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.home_work,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'عقارات العربية',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'اهلاً بك في تطبيق العقارات',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => Get.toNamed(Routes.LOGIN),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primaryColor,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            icon: const Icon(Icons.login, size: 18),
                            label: const Text('تسجيل الدخول', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }
                }
            ),

            const SizedBox(height: 8),

            // Menu items with enhanced styling
            _buildDrawerItem(
              icon: Icons.home_rounded,
              title: 'الرئيسية',
              isSelected: true,
              onTap: () {
                Get.back();
                controller.changeTab(0);
              },
            ),

            _buildDrawerItem(
              icon: Icons.apartment_rounded,
              title: 'جميع العقارات',
              onTap: () {
                Get.back();
                Get.toNamed(Routes.PROPERTY_LIST);
              },
            ),

            _buildDrawerItem(
              icon: Icons.favorite_rounded,
              title: 'المفضلة',
              onTap: () {
                Get.back();
                controller.navigateToFavorites();
              },
            ),

            _buildDrawerItem(
              icon: Icons.calendar_today_rounded,
              title: 'حجوزاتي',
              onTap: () {
                Get.back();
                controller.navigateToBookings();
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 32),
            ),

            GetBuilder<HomeController>(
                builder: (controller) {
                  if (controller.isLoggedIn()) {
                    return Column(
                      children: [
                        _buildDrawerItem(
                          icon: Icons.person_rounded,
                          title: 'الملف الشخصي',
                          onTap: () {
                            Get.back();
                            controller.navigateToProfile();
                          },
                        ),

                        _buildDrawerItem(
                          icon: Icons.logout_rounded,
                          title: 'تسجيل الخروج',
                          isDestructive: true,
                          onTap: () {
                            Get.back();
                            controller.logout();
                          },
                        ),
                      ],
                    );
                  } else {
                    return _buildDrawerItem(
                      icon: Icons.login_rounded,
                      title: 'تسجيل الدخول',
                      isPrimary: true,
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.LOGIN);
                      },
                    );
                  }
                }
            ),

            const SizedBox(height: 24),

            // App version at bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'تطبيق العقارات الإصدار 1.0.0',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor.withOpacity(0.6),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isPrimary = false,
    bool isDestructive = false,
  }) {
    Color textColor = AppTheme.textColor;
    Color iconColor = AppTheme.secondaryTextColor;
    Color? backgroundColor;

    if (isSelected) {
      textColor = AppTheme.primaryColor;
      iconColor = AppTheme.primaryColor;
      backgroundColor = AppTheme.primaryColor.withOpacity(0.1);
    } else if (isPrimary) {
      textColor = AppTheme.primaryColor;
      iconColor = AppTheme.primaryColor;
    } else if (isDestructive) {
      textColor = AppTheme.errorColor;
      iconColor = AppTheme.errorColor;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontWeight: isSelected || isPrimary ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
      ),
    );
  }
}