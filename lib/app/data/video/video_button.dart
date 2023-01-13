// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:han_tok/app/data/base_style.dart';
import 'package:tapped/tapped.dart';

class VideoButton extends StatelessWidget {
  final double? bottomPadding;
  final bool isFavorite;
  final Function? onFavorite;
  final Function? onComment;
  final Function? onShare;
  final Function? onAvatar;
  const VideoButton({
    Key? key,
    this.bottomPadding,
    this.onFavorite,
    this.onComment,
    this.onShare,
    this.isFavorite: false,
    this.onAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      margin: EdgeInsets.only(
        bottom: bottomPadding ?? 50,
        right: 12,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Tapped(
            child: TikTokAvatar(),
            onTap: onAvatar,
          ),
          FavoriteIcon(
            onFavorite: onFavorite,
            isFavorite: isFavorite,
          ),
          _IconButton(
            icon: IconToText(Icons.mode_comment, size: 36.w),
            text: '4213',
            onTap: onComment,
          ),
          _IconButton(
            icon: IconToText(Icons.share, size: 40.w),
            text: '346',
            onTap: onShare,
          ),
          Container(
            width: 56.w,
            height: 56.w,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              // color: Colors.black.withOpacity(0.8),
            ),
          )
        ],
      ),
    );
  }
}

class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({
    Key? key,
    required this.onFavorite,
    this.isFavorite,
  }) : super(key: key);
  final bool? isFavorite;
  final Function? onFavorite;

  @override
  Widget build(BuildContext context) {
    return _IconButton(
      icon: IconToText(
        Icons.favorite,
        size: 40,
        color: isFavorite! ? Colors.red : null,
      ),
      text: '1.0w',
      onTap: onFavorite,
    );
  }
}

class TikTokAvatar extends StatelessWidget {
  const TikTokAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container(
      width: 56.w,
      height: 56.w,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(28.r),
        color: Colors.white70,
      ),
      child: ClipOval(
        child: Image.network(
          "https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif",
          fit: BoxFit.cover,
        ),
      ),
    );
    Widget addButton = Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.orange,
      ),
      child: Icon(
        Icons.add,
        size: 16,
      ),
    );
    return Container(
      width: 56.w,
      height: 66,
      margin: EdgeInsets.only(bottom: 6),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[avatar, addButton],
      ),
    );
  }
}

/// 把IconData转换为文字，使其可以使用文字样式
class IconToText extends StatelessWidget {
  final IconData? icon;
  final TextStyle? style;
  final double? size;
  final Color? color;

  const IconToText(
    this.icon, {
    Key? key,
    this.style,
    this.size,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      String.fromCharCode(icon!.codePoint),
      style: style ??
          TextStyle(
            fontFamily: 'MaterialIcons',
            fontSize: size ?? 30,
            inherit: true,
            color: color ?? Colors.white,
          ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final Widget? icon;
  final String? text;
  final Function? onTap;
  const _IconButton({
    Key? key,
    this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shadowStyle = TextStyle(
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.15),
          offset: Offset(0, 1),
          blurRadius: 1,
        ),
      ],
    );
    Widget body = Column(
      children: <Widget>[
        Tapped(
          child: icon ?? Container(),
          onTap: onTap,
        ),
        Container(height: 2),
        Text(
          text ?? '??',
          style: BaseStyle.fs12.copyWith(color: Colors.white),
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: DefaultTextStyle(
        child: body,
        style: shadowStyle,
      ),
    );
  }
}
