/**
 * Created by Shiwenwen on 16/3/30.
 */
function getARGBImage(img){

	var canvas = document.createElement("canvas");
	var context = canvas.getContext("2d");
	canvas.width = img.width;
	canvas.height = img.height;
	context.drawImage(img,0,0,img.width,img.height);
	var imageData = context.getImageData(0,0,img.width,img.height);
	var dataArray = new Array(imageData.data.length);
	for(var i = 0; i < dataArray.length;i++)
		dataArray[i] = imageData.data[i];
	return dataArray.toString()+","+img.width+","+img.height;
}
function dataToJsonString(key,value) {

	var string = '{'+'"'+key+'"'+':'+'"'+value+'"'+'}';


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

	return string +'"'+ key + '"'+':' +'"'+ value +'"' + ','+'}'

}
function getchis() {

	var xjxlTable = document.getElementsByClassName("xjxlTable")[0];

	var tbody = xjxlTable.getElementsByTagName("tbody")[0];

	var dataArr = new Array();
	var length = tbody.getElementsByTagName("tr").length;

	for (var j = 0;j < length ;j++) {

		var  tr = tbody.getElementsByTagName("tr")[j];

		if (j == 0) {

			var th = tr.getElementsByTagName("th")[0];
			var key = th.innerHTML;
			var td = tr.getElementsByTagName("td")[0];
			var value = td.innerHTML;


			var img = tr.getElementsByTagName('img')[0];
			dataArr.push(dataToJsonString(key,value));

			dataArr.push(dataToJsonString("img",getARGBImage(img)));

		} else {


			for (i = 0; i < 2; i++) {

				var th = tr.getElementsByTagName("th")[i];
				var key = th.innerHTML;
				var td = tr.getElementsByTagName("td")[i];
				var  value = td.innerHTML;
				// if (( j == length - 1) && (i == 0)){
                //
					// var temp = td.getElementsByTagName("a")[0];
				// 	value = temp.innerHTML;
                //
                // }
				dataArr.push(dataToJsonString(key,value));
			}
		}

	}

	return "["+dataArr.toString()+"]";

}
getchis()


