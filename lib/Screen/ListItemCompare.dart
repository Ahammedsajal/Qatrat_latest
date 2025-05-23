import 'package:collection/src/iterable_extensions.dart';
import 'package:customer/Helper/Color.dart';
import 'package:customer/Helper/String.dart';
import 'package:customer/Model/Section_Model.dart';
import 'package:customer/Provider/ProductDetailProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/src/provider.dart';
import '../app/routes.dart';
import '../ui/styles/DesignConfig.dart';

class ListItemCom extends StatefulWidget {
  final Product? productList;
  final ValueChanged<bool>? isSelected;
  final int? secPos;
  final int? len;
  final int? index;
  const ListItemCom({
    super.key,
    this.productList,
    this.isSelected,
    this.secPos,
    this.len,
    this.index,
  });
  @override
  _ListItemNotiState createState() => _ListItemNotiState();
}

class _ListItemNotiState extends State<ListItemCom> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return productItem();
  }

  Widget productItem() {
    final List<Product> compareList =
        context.read<ProductDetailProvider>().compareList;
    String? offPer;
    double price =
        double.parse(widget.productList!.prVarientList![0].disPrice!);
    if (price == 0) {
      price = double.parse(widget.productList!.prVarientList![0].price!);
    } else {
      final double off =
          double.parse(widget.productList!.prVarientList![0].price!) - price;
      offPer = ((off * 100) /
              double.parse(widget.productList!.prVarientList![0].price!))
          .toStringAsFixed(2);
    }
    final double width = deviceWidth! * 0.45;
    final extPro =
        compareList.firstWhereOrNull((cp) => cp.id == widget.productList!.id);
    return SizedBox(
        height: 255,
        width: width,
        child: Card(
          elevation: 0.2,
          margin: const EdgeInsetsDirectional.only(bottom: 5, end: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsetsDirectional.only(end: 5.0, top: 5.0),
                  child: InkWell(
                    child: extPro != null
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primarytheme,
                            size: 22,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            color: Theme.of(context).colorScheme.primarytheme,
                            size: 22,
                          ),
                    onTap: () {
                      setState(() {
                        isSelected = !isSelected;
                        widget.isSelected!(isSelected);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                          padding: const EdgeInsetsDirectional.only(top: 8.0),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),),
                            child: Hero(
                                tag:
                                    "$compHero${widget.index}${widget.productList!.id}${widget.secPos}",
                                child: networkImageCommon(
                                    widget.productList!.image!,
                                    double.maxFinite,
                                    false,
                                    height: double.maxFinite,
                                    width: double.maxFinite,),),
                          ),),
                      if (offPer != null) Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: colors.red,
                                ),
                                margin: const EdgeInsets.all(5),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "${widget.productList!.isSalesOn == "1" ? double.parse(widget.productList!.saleDis!).toStringAsFixed(2) : offPer}%",
                                    style: const TextStyle(
                                        color: colors.whiteTemp,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,),
                                  ),
                                ),
                              ),
                            ) else const SizedBox.shrink(),
                      const Divider(
                        height: 1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 5.0,
                    top: 5,
                  ),
                  child: Row(
                    children: [
                      RatingBarIndicator(
                        rating: double.parse(widget.productList!.rating!),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star_rate_rounded,
                          color: Colors.amber,
                        ),
                        unratedColor: Colors.grey.withOpacity(0.5),
                        itemSize: 12.0,
                      ),
                      Text(
                        " (${widget.productList!.noOfRating!})",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 5.0, top: 5, bottom: 5,),
                  child: Text(
                    widget.productList!.name!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.fontColor,
                        fontWeight: FontWeight.bold,),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                        widget.productList!.isSalesOn == "1"
                            ? getPriceFormat(
                                context,
                                double.parse(widget.productList!
                                    .prVarientList![0].saleFinalPrice!,),)!
                            : '${getPriceFormat(context, price)!} ',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.fontColor,
                            fontWeight: FontWeight.bold,),),
                    Text(
                      double.parse(widget
                                  .productList!.prVarientList![0].disPrice!,) !=
                              0
                          ? getPriceFormat(
                              context,
                              double.parse(widget
                                  .productList!.prVarientList![0].price!,),)!
                          : "",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          decoration: TextDecoration.lineThrough,
                          letterSpacing: 0,),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              final Product model = widget.productList!;
              currentHero = compHero;
              Navigator.pushNamed(context, Routers.productDetails, arguments: {
                "secPos": widget.secPos,
                "index": widget.index,
                "list": true,
                "id": model.id,
              },);
            },
          ),
        ),);
  }
}
