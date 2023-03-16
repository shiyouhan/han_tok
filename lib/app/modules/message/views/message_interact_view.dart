// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:han_tok/app/data/base_style.dart';
import 'package:han_tok/app/modules/message/controllers/message_interact_controller.dart';
import 'package:han_tok/app/modules/message/views/message_detail_view.dart';
import 'package:han_tok/app/utils/DateUtil.dart';
import 'package:han_tok/app/utils/Iconfont.dart';

import '../../../data/video/user_info.dart';

class MessageInteractView extends StatefulWidget {
  const MessageInteractView({Key? key}) : super(key: key);

  @override
  State<MessageInteractView> createState() => _MessageInteractViewState();
}

class _MessageInteractViewState extends State<MessageInteractView> {
  MessageInteractController controller = Get.put(MessageInteractController());
  var selectValue;
  var selectItemValue = '关注';

  List<DropdownMenuItem> generateItemList() {
    final List<DropdownMenuItem> items = [];
    final DropdownMenuItem item1 = DropdownMenuItem(
      onTap: () => controller.renewOne(),
      value: '关注',
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 16.w),
            child: Icon(IconFont.guanzhu,
                color: Colors.grey.withOpacity(.8), size: 26),
          ),
          Text('关注',
              style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold))
        ],
      ),
    );
    final DropdownMenuItem item2 = DropdownMenuItem(
      onTap: () => controller.renewTwo(),
      value: '点赞视频',
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 16.w),
            child: Icon(Icons.favorite,
                color: Colors.grey.withOpacity(.8), size: 24),
          ),
          Text('点赞视频',
              style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
    final DropdownMenuItem item3 = DropdownMenuItem(
      onTap: () => controller.renewFive(),
      value: '点赞评论',
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 16.w),
            child: Icon(IconFont.dianzan,
                color: Colors.grey.withOpacity(.8), size: 24),
          ),
          Text('点赞评论',
              style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
    final DropdownMenuItem item4 = DropdownMenuItem(
      onTap: () => controller.renewFour(),
      value: '发出的评论',
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 16.w),
            child: Image.asset(
              'assets/images/fachu.png',
              width: 22.w,
              height: 22.h,
            ),
          ),
          Text('发出的评论',
              style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
    final DropdownMenuItem item5 = DropdownMenuItem(
      onTap: () => controller.renewThree(),
      value: '收到的评论',
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 16.w),
            child: Image.asset(
              'assets/images/shoudao.png',
              width: 22.w,
              height: 22.h,
            ),
          ),
          Text('收到的评论',
              style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
    items.add(item1);
    items.add(item2);
    items.add(item3);
    items.add(item4);
    items.add(item5);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('消息', style: BaseStyle.fs16),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton(
              hint: Text(
                '$selectItemValue',
                style: BaseStyle.fs16.copyWith(fontWeight: FontWeight.bold),
              ),
              value: selectValue,
              elevation: 0,
              dropdownColor: Colors.white,
              // underline: Container(),
              enableFeedback: true,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r)),
              // isDense: true,
              isExpanded: true,
              items: generateItemList(),
              onChanged: (T) {
                setState(() {
                  selectItemValue = T;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(
              () => SizedBox(
                height: size.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: controller.messageList
                        .map(
                          (element) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Get.to(() =>
                                      UserInfo(vlogerId: element.fromUserId)),
                                  child: Container(
                                    width: 56.w,
                                    height: 56.w,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.w,
                                      ),
                                      borderRadius: BorderRadius.circular(28.r),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        element.fromFace,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 16.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Get.to(() => UserInfo(
                                              vlogerId: element.fromUserId)),
                                          child: Text(
                                            element.fromNickname,
                                            style: BaseStyle.fs14.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        element.msgType == 3
                                            ? GestureDetector(
                                                onTap: () => {
                                                  if (element.msgType != 1)
                                                    {
                                                      Get.to(() =>
                                                          MessageDetailView(
                                                              vlogId: element
                                                                  .msgContent
                                                                  .vlogId,
                                                              // vlogerId: element.fromUserId,
                                                              vlogerId: element
                                                                  .toUserId,
                                                              url: element
                                                                  .msgContent
                                                                  .url))
                                                    }
                                                },
                                                child: Text(
                                                  element.msgContent
                                                      .commentContent,
                                                  style: BaseStyle.fs12,
                                                ),
                                              )
                                            : Container(),
                                        element.msgType == 4
                                            ? GestureDetector(
                                                onTap: () => {
                                                  if (element.msgType != 1)
                                                    {
                                                      Get.to(() =>
                                                          MessageDetailView(
                                                              vlogId: element
                                                                  .msgContent
                                                                  .vlogId,
                                                              // vlogerId: element.fromUserId,
                                                              vlogerId: element
                                                                  .toUserId,
                                                              url: element
                                                                  .msgContent
                                                                  .url))
                                                    }
                                                },
                                                child: Text(
                                                  element.msgContent
                                                      .commentContent,
                                                  style: BaseStyle.fs12,
                                                ),
                                              )
                                            : Container(),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => {
                                                if (element.msgType != 1)
                                                  {
                                                    Get.to(() =>
                                                        MessageDetailView(
                                                            vlogId: element
                                                                .msgContent
                                                                .vlogId,
                                                            // vlogerId: element.fromUserId,
                                                            vlogerId: element
                                                                .toUserId,
                                                            url: element
                                                                .msgContent
                                                                .url))
                                                  }
                                              },
                                              child: Text(
                                                element.msgType == 1
                                                    ? '关注了你'
                                                    : (element.msgType == 2
                                                        ? '点赞了你的视频'
                                                        : (element.msgType == 3
                                                            ? '评论了你'
                                                            : (element.msgType ==
                                                                    4
                                                                ? '回复了你'
                                                                : '点赞了你的评论'))),
                                                style: BaseStyle.fs12,
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              DateUtil().getComparedTime(
                                                  element.createTime),
                                              style: BaseStyle.fs12,
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                                Spacer(),
                                element.msgType == 1
                                    ? (element.msgContent.isFriend == false
                                        ? GestureDetector(
                                            onTap: () => {
                                              controller.vlogerId.value =
                                                  element.fromUserId,
                                              controller.follow(),
                                            },
                                            child: Container(
                                              width: 70.w,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 6.h),
                                              decoration: BoxDecoration(
                                                color: Color(0XF8FA9FB7),
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                              ),
                                              child: Text('回关',
                                                  style: BaseStyle.fs14
                                                      .copyWith(
                                                          color: Colors.white)),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () => {
                                              controller.vlogerId.value =
                                                  element.fromUserId,
                                              controller.cancel(),
                                            },
                                            child: Container(
                                              width: 70.w,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 6.h),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.grey.withOpacity(.1),
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                              ),
                                              child: Text('已互关',
                                                  style: BaseStyle.fs14),
                                            ),
                                          ))
                                    : GestureDetector(
                                        onTap: () => Get.to(() =>
                                            MessageDetailView(
                                                vlogId:
                                                    element.msgContent.vlogId,
                                                // vlogerId: element.fromUserId,
                                                vlogerId: element.toUserId,
                                                url: element.msgContent.url)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          child: Image.network(
                                            element.msgContent.vlogCover,
                                            width: 48.w,
                                            height: 64.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
