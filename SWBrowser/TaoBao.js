/**
 * Created by Shiwenwen on 16/4/6.
 */


function getTaobaoList() {

    // var listData = $("[data-reactid='.0.3.2']")
    var listData = getElementWithAttribute("data-reactid",".0.3.2",document)
    var listArr = new Array()
    //订单列表
    var list = listData.children
    for (var i=0; i<list.length;i++){
        var  dic;

        var order = list[i]
        //
        var tables = order.getElementsByTagName("table")
        //------订单号 时间
        var tbody0 = tables[0].getElementsByTagName("tbody")[0]

        var tr = tbody0.getElementsByTagName("tr")[1]
        var td = tr.getElementsByTagName("td")[0]
        //交易时间
        var dealTime = td.getElementsByTagName("label")[0].children[1]
        dic = dataToJsonString("交易时间",dealTime.innerHTML)
        //订单号
        var orderNumber = td.lastChild
        dic = jsonDicApPend("订单号",orderNumber.innerHTML,dic)
        var tbody1 = tables[1].getElementsByTagName("tbody")[0]
        var trs = tbody1.children
        var subList = new Array()
        for (var x = 1; x < trs.length;x ++){
            var tds = trs[x].getElementsByTagName("td")

            //-----------订单名 价格 状态

            var subDic
            for (var t = 0;t < tds.length;t ++){
                var  td = tds[t]

                switch(t){
                    case 0:{
                        //商品名
                        var orderName =  td.getElementsByTagName("span")[0]
                        if (orderName.innerHTML.length < 1){
                            orderName =  td.getElementsByTagName("span")[1]
                        }
                        subDic = dataToJsonString("商品名",orderName.innerHTML)
                    }break;
                    case 1:{
                        //物品价格
                        var ps = td.getElementsByTagName("p")
                        var  price = ps[ps.length - 1]
                        subDic = jsonDicApPend("物品价格",price.innerHTML,subDic)

                    }break
                    case 2:{
                        // 购买数量
                        var number = td.firstChild.firstChild

                        subDic = jsonDicApPend("购买数量",number.innerHTML,subDic)

                    }break
                    case 3:{

                    }break
                    case 4:{
                        if (x > 1){
                            break
                        }
                        //实付款
                        var money = td.getElementsByTagName("strong")[0]

                        dic = jsonDicApPend("实付款",money.innerHTML,dic)

                    }break
                    case 5:{
                        if (x > 1){
                            break
                        }
                        // //订单状态
                        var orderStatus = td.getElementsByTagName("a")[0]
                        dic = jsonDicApPend("订单状态",orderStatus.innerHTML,dic)

                    }break

                    default:{

                    }break

                }


            }
            subList.push(subDic)




        }
        dic = jsonDicApPend("商品列表",subList,dic)
        listArr.push(dic)
    }

    return "["+listArr.toString()+"]"

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
    var sting

    if(typeof(value) == "string"){
        string = '{'+'"'+key+'"'+':'+'"'+value+'"'+'}';

    }else{

        string = '{'+'"'+key+'"'+':'+'['+value.toString()+']'+'}'
    }



    return string;
}
function datasToJsonString(keys,values) {
    var string;
    for (var  i = 0; i< keys.length; i ++){
        var key = keys[i];
        var value = values[i];
        if (i < keys.length - 1){
            string += '"'+key+'"'+':'+'"'+value+'"'+',';
        }else {
            string += '"'+key+'"'+':'+'"'+value+'"';
        }

    }

    return '{'+ string + '}'
}
function jsonDicApPend(key,value,dic) {

    var string = dic.substr(0,dic.length - 1)

    if(typeof(value) == "string"){
        string = string + ','+'"'+ key + '"'+':' +'"'+ value +'"' + ''+'}'

    }else {

        string = string +','+'"'+ key + '"'+':' +'['+ value.toString() +']' + ''+'}'
    }
    return string

}
function getElementWithAttribute(name,value,element) {
    var subElements = element.getElementsByTagName("*")

    for (var i = 0;i < subElements.length;i++){
            var subelement = subElements[i]

        if (subelement.hasAttribute(name)){

            if (subelement.getAttribute(name) == value){

                return subelement
            }

        }


    }
    return null
}

getTaobaoList()
