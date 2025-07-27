import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:user_manager/core/theme/app_palete.dart';

class UserTile extends StatelessWidget {
  final double height;
  final double width;

  final String userName;
  final String image;
  final Function onSwipe;
  final Function onEdit;

  const UserTile(
      {super.key,
      required this.height,
      required this.width,
      required this.userName,
      required this.onSwipe,
      required this.onEdit,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
            color: AppPalette.shadowColor,
            offset: Offset(1, 1),
            spreadRadius: 6,
            blurRadius: 4)
      ], color: AppPalette.whiteColor, borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Slidable(
          direction: Axis.horizontal,
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                  borderRadius: BorderRadius.circular(10),
                  autoClose: true,
                  backgroundColor: AppPalette.apricotColor,
                  onPressed: (context) {
                    onSwipe();
                  },
                  icon: Icons.delete),
            ],
          ),
          child: ListTile(
            trailing: GestureDetector(
                onTap: () {
                  onEdit();
                },
                child: const Icon(Icons.edit)),
            title: Text(userName),
            leading: Container(
              decoration: BoxDecoration(
                color: AppPalette.apricotColor,
                borderRadius: BorderRadius.circular(8),
              ),
              height: height * 0.9,
              width: width * 0.15,
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppPalette.appPrimaryColor,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
