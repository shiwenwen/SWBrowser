
/**
 * Created by Shiwenwen on 16/3/30.
 */
function getPassengers(passens){

    var arr = new  Array()

    for (var i =0;i < passens.length; i++){


        arr.push(JSON.stringify(passens[i]))


    }

    return "["+arr.toString()+"]";

}

getPassengers(passengers)
