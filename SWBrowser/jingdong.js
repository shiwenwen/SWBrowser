/**
 * Created by Shiwenwen on 16/3/30.
 */
function getJiongdongList(){

    var contens = document.getElementById("order02")
    var list = contens.getElementsByTagName("tbody")
    var jsonData = new Array()
    for (var i = 0; i < list.length;i++ ){
        var dic
        var tbody = list[i]
        // alert(tbody.innerHTML)
        //成交时间

        var dealtime = getElementsByClassName("dealtime",tbody)[0]
        dic = dataToJsonString("成交时间",dealtime.innerHTML)
        //订单号
        var numberNode = getElementsByClassName("number",tbody)[0]
        var number = numberNode.getElementsByTagName("a")[0]
        dic = jsonDicApPend("订单号",number.innerHTML,dic)
        //订单来源
        var oderShopNode = getElementsByClassName("order-shop",tbody)[0]
        var oderShop = oderShopNode.getElementsByTagName("*")
        var shopText = oderShop[0]
        dic = jsonDicApPend("订单来源",shopText.innerHTML,dic)
        //收货信息
        // var pcNode = getElementsByClassName("pc",tbody)[0];
        // var pcInner;
        // for(var j = 0;j < pcNode.getElementsByTagName("*").length ;j++ ){
        //     pcInner = pcInner +"\n"+ pcNode.getElementsByTagName("*")[j].innerHTML
        //
        // }
        // dic = jsonDicApPend("收货信息",pcInner,dic)

        //商品
        var trbds = getElementsByClassName("tr-bd",tbody)
        var pArr = new  Array()
        for(var j = 0;j <trbds.length ;j++ ){

            //商品名称
            var trbd = trbds[j]
            var pName = getElementsByClassName("p-name",trbd)[0]
            var pNameA = pName.getElementsByTagName("a")[0]
            //
            var  pDic = dataToJsonString("商品名称",pNameA.innerHTML)
            //购买数量
            var number = getElementsByClassName("goods-number",trbd)[0]
            pDic = jsonDicApPend("购买数量",number.innerHTML,pDic)
            // 信息
            var info = getElementsByClassName("o-info",trbd)[0]

            var li = info.getElementsByTagName("li")[0]
            if (li.getElementsByTagName("*").length == 0){

                pDic = jsonDicApPend("购买信息",li.innerHTML,pDic)

            }


            pArr.push(pDic)
        }
        dic = jsonDicApPend("商品列表",'['+ pArr.toString()+']',dic)
        //订单状态
        var status = getElementsByClassName("status",tbody)[0]
        var statusInfo = status.getElementsByTagName("span")[0]
        var subSpans = statusInfo.getElementsByTagName("span")
        if (subSpans.length > 0){
           var subSpan = subSpans[0]
            dic = jsonDicApPend("订单状态",subSpan.innerHTML,dic)

        }else {
            dic = jsonDicApPend("订单状态",statusInfo.innerHTML,dic)
        }

        //总金额
        var amount = getElementsByClassName("amount",tbody)[0]
        var amountSpan = amount.getElementsByTagName("span")[0]

        dic = jsonDicApPend("总金额",amountSpan.innerHTML,dic)
        //支付方式
        var payStatus = amount.getElementsByTagName("span")[1]
        dic = jsonDicApPend("支付方式",payStatus.innerHTML,dic)
        jsonData.push(dic)
    }

    
    return "["+jsonData.toString()+"]";

}
function getElementsByClassName(className,element) {
    var children = element.getElementsByTagName('*');
    var elements = new Array();
    for (var i=0; i<children.length; i++){
        var child = children[i];
        var classNames = child.className.split(' ');
        for (var j=0; j<classNames.length; j++){
            if (classNames[j] == className){
                elements.push(child);
                break;
            }
        }
    }
    return elements;



}
function dataToJsonString(key,value) {

    var string = '{'+'"'+key+'"'+':'+'"'+value+'"'+',}';


    return string;
}
function datasToJsonString(keys,values) {
    var string;
    for (var  i = 0; i< keys.length; i ++){
        var key = keys[i];
        var value = values[i];
        string += '"'+key+'"'+':'+'"'+value+'"'+',';
    }
    return '{'+ string + '}'
}

function jsonDicApPend(key,value,dic) {

    var string = dic.substr(0,dic.length - 1)

    return string +'"'+ key + '"'+':' +'"'+ value +'"' + ','+'}'

}
getJiongdongList()

