/**
 * Created by Shiwenwen on 16/4/6.
 */
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

function getTaobaoList() {




}
