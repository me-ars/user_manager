import 'package:user_manager/core/theme/app_palete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_manager/models/user_model.dart';
import 'package:user_manager/shared_widgets/add_user_dialog.dart';
import 'package:user_manager/shared_widgets/custom_button.dart';
import 'package:user_manager/shared_widgets/custom_text_field.dart';
import 'package:user_manager/ui/screens/auth/login/login_screen.dart';
import 'package:user_manager/ui/widgets/user_tile.dart';
import '../../../../core/enums/view_state.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../../../state/home/home_bloc.dart';
import '../../widgets/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(FetchAllInitialDataEvent()),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  int _bottomNavIndex = 0;

  final List<IconData> _iconList = [
    Icons.home,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is UserLogoutState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>const  LoginScreen(),
              ));
        }
        if (state is HomeViewStateChangeState &&
            state.viewState == ViewState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to load users")),
          );
        } else if (state is UserUpdateSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User updated successfully")),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is HomeViewStateChangeState &&
            state.viewState == ViewState.loading;
        final List<UserModel> users = state is UserUpdateSuccessState
            ? state.users
            : state is HomeInitialFetchSuccessState
                ? state.users
                : context.read<HomeBloc>().users;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AddUserDialog.showAddUserPopup(
                  context: context,
                  onAdd: (newUser) {
                    context.read<HomeBloc>().add(AddUserEvent(user: newUser));
                  });
            },
            backgroundColor: AppPalette.appPrimaryColor,
            child: const Icon(Icons.add),
          ),
          backgroundColor: AppPalette.appPrimaryColor,
          body: Column(
            children: [
              SizedBox(height: size.height * 0.1),
              Expanded(
                child: Container(
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: AppPalette.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppPalette.appPrimaryColor,
                          ),
                        )
                      : _buildBody(size, users: users),
                ),
              ),
            ],
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: _iconList,
            activeIndex: _bottomNavIndex,
            gapLocation: GapLocation.none,
            backgroundColor: Colors.white,
            activeColor: AppPalette.appPrimaryColor,
            notchSmoothness: NotchSmoothness.defaultEdge,
            leftCornerRadius: 12,
            rightCornerRadius: 12,
            inactiveColor: AppPalette.apricotColor,
            onTap: (index) {
              setState(() {
                _bottomNavIndex = index;
              });
            },
          ),
        );
      },
    );
  }
  Widget _buildBody(Size size, {required List<UserModel?> users}) {
    if (_bottomNavIndex == 0) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.03, right: size.width * 0.76),
            child: const Text("Users",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UserTile(
                    height: size.height * 0.12,
                    width: size.width * 0.9,
                    userName: "${user?.firstName} ${user?.lastName}",
                    image: user!.avatar,
                    onSwipe: () {
                      context.read<HomeBloc>().add(DeleteUserEvent(id: user.id));
                    },
                    onEdit: () {
                      _showUpdatePopup(
                        context: context,
                        user: user,
                        onTap: (updatedUser) {
                          Navigator.of(context).pop(); // Close dialog
                          context
                              .read<HomeBloc>()
                              .add(UpdateUserEvent(user: updatedUser));
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else {
      // Profile View
      final currentUser = context.read<HomeBloc>().currentUser;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
            backgroundColor: AppPalette.appPrimaryColor,
              child: Text(currentUser!.username[0])
            ),
            const SizedBox(height: 20),
            Text(
              "${currentUser?.username}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: size.height*0.02,),

            const SizedBox(height: 20),
            CustomButton(
              height: size.height * 0.08,
              width: size.width * 0.8,
              buttonText: "Logout",
              onTap: () {
                context.read<HomeBloc>().add(UserLogoutEvent());
              },
            ),
          ],
        ),
      );
    }
  }


  void _showUpdatePopup({
    required BuildContext context,
    required UserModel user,
    required Function(UserModel) onTap,
  }) {
    Size size = MediaQuery.of(context).size;
    TextEditingController firstNameController =
        TextEditingController(text: user.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: user.lastName);
    TextEditingController emailController =
        TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UserAvatarPicker(imageUrl: user.avatar),
                const SizedBox(height: 16),
                CustomTextField(
                  height: size.height * 0.08,
                  width: size.width * 0.8,
                  controller: firstNameController,
                  labelText: "First Name",
                  maxLength: 100,
                  isPassword: false,
                ),
                CustomTextField(
                  height: size.height * 0.08,
                  width: size.width * 0.8,
                  controller: lastNameController,
                  labelText: "Last Name",
                  maxLength: 100,
                  isPassword: false,
                ),
                CustomTextField(
                  height: size.height * 0.08,
                  width: size.width * 0.8,
                  controller: emailController,
                  labelText: "Email",
                  maxLength: 100,
                  isPassword: false,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  height: size.height * 0.08,
                  width: size.width * 0.8,
                  buttonText: "Update",
                  onTap: () {
                    final updatedUser = user.copyWith(
                      firstName: firstNameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      email: emailController.text.trim(),
                    );
                    onTap(updatedUser);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
