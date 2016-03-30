/**
 * Created by Shiwenwen on 16/3/30.
 */
function getJiongdongList(){

    var contens = document.getElementById("order02")
    var list = contens.getElementsByTagName("tbody")

    for (var i = 0; i < list.length;i++ ){

        var tbody = list[i]
        // alert(tbody.innerHTML)
        //成交时间
        var dealtime = getElementsByClassName("dealtime",tbody)[0]

        //订单号
        var numberNode = getElementsByClassName("number",tbody)[0]
        var number = numberNode.getElementsByTagName("a")[0]
        //订单来源
        var oderShopNode = getElementsByClassName("order-shop",tbody)[0]
        var oderShop = oderShopNode.getElementsByTagName("*")
        var shopText = oderShop[0]
        //收货信息
        var pcNode = getElementsByClassName("pc",tbody)[0];
        var pcInner;
        for(var i = 0;i <pcNode.getElementsByTagName("*").length ;i++ ){
            pcInner = pcInner + pcNode.getElementsByTagName("*")[i].innerHTML

        }
        alert(dealtime.innerHTML + number.innerHTML + shopText.innerHTML+pcInner)

    }
    
     

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
getJiongdongList()

