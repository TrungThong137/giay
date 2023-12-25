import 'package:flutter/material.dart';

class SizeAndQuantityWidget extends StatefulWidget {
  const SizeAndQuantityWidget({
    super.key, required this.quantityController, required this.sizeController,
    this.onEnable, this.isOntap=false, this.width,
  });

  final TextEditingController sizeController;
  final TextEditingController quantityController;
  final Function(bool isEnable)? onEnable;
  final bool isOntap;
  final double? width;

  @override
  State<SizeAndQuantityWidget> createState() => _SizeAndQuantityWidgetState();
}

class _SizeAndQuantityWidgetState extends State<SizeAndQuantityWidget> {

  List<double> listSizeShoe= [35, 36, 36.5, 37, 38, 38.5, 39, 40, 40.5, 41, 42, 42.5];
  List<int> listQuantityShoe= [1,2,3,4,5,6,7,8,9,10,11,12];
  bool isShowSelectSizeShoe=false;
  bool isShowSelectQuantityShoe=false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSizeShoe(),
            buildQuantityShoe(),
          ],
        ),
      ),
    );
  }

  Widget buildItemSelect(BuildContext context, {List<dynamic>? listItem, 
    Function(String value)? onTap, bool isShowSelectItem=false}){
    return Visibility(
      visible: isShowSelectItem,
      child: SizedBox(
        width:widget.width!=null ?100: MediaQuery.sizeOf(context).width/2.26,
        height: widget.width==null? 140: null,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ), 
          itemCount: listItem?.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () => onTap!(listItem?[index].toString()??''),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: Text(
                listItem?[index].toString()??'',
                style: TextStyle(
                  fontSize: widget.width!=null?8:null,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomDropButton(BuildContext context,{String? title, String? hintText, 
    List<dynamic>? listItem, Function(String value)? onTapSelect, 
    TextEditingController? controller, Function()? onShowItem, 
    bool isShowSelectItem=false}){
    return Padding(
      padding: EdgeInsets.all(widget.width!=null?3: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title??'',
            style: TextStyle(
              fontSize: widget.width!=null?12: 20,
              fontWeight: FontWeight.w600
            ),
          ),
          InkWell(
            onTap: () => onShowItem!(),
            child: Container(
              height: 50,
              width: widget.width!=null ?100: MediaQuery.sizeOf(context).width/2.26,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45)),
              child: TextFormField(
                textAlign: TextAlign.start,
                enabled: false,
                controller: controller,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  suffixIcon: const Icon(Icons.arrow_drop_down)
                ),
              ),
            ),
          ),
          buildItemSelect(context,listItem: listItem??[], onTap: (value) => onTapSelect!(value),
            isShowSelectItem: isShowSelectItem),
        ],
      ),
    );
  }

  Widget buildSizeShoe(){
    return buildCustomDropButton(
      context,
      title: 'Size giày',
      hintText: 'Chọn Size',
      listItem: listSizeShoe,
      controller: widget.sizeController,
      isShowSelectItem: isShowSelectSizeShoe,
      onTapSelect: (value) => setSizeShoe(value),
      onShowItem: () =>setState(() {
          isShowSelectSizeShoe=!isShowSelectSizeShoe;
      }),
    );
  }

  Widget buildQuantityShoe(){
    return buildCustomDropButton(
      context,
      title: 'Số lượng',
      hintText: 'Chọn số lượng',
      listItem: listQuantityShoe,
      controller: widget.quantityController,
      isShowSelectItem: isShowSelectQuantityShoe,
      onTapSelect: (value) => setQuantityShoe(value),
      onShowItem: () =>setState(() {
        isShowSelectQuantityShoe=!isShowSelectQuantityShoe;
      }),
    );
  }

   void setSizeShoe(String? value){
    widget.sizeController.text=value??'';
    isShowSelectSizeShoe=false;
    onEnableButton();
    setState(() {});
  }

  void setQuantityShoe(String? value){
    widget.quantityController.text=value??'';
    isShowSelectQuantityShoe=false;
    onEnableButton();
    setState(() {});
  }

  void onEnableButton(){
    if(widget.isOntap){
      if(widget.sizeController.text.trim()!='' && widget.quantityController.text.trim()!=''){
        widget.onEnable!(true);
      }else{
        widget.onEnable!(false);
      }
      setState(() {});
    }
  }
}