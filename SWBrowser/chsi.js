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
function getBase64Image(img) {


	var canvas = document.createElement("canvas");

	canvas.width = img.width;
	canvas.height = img.height;

	var ctx = canvas.getContext("2d");

	ctx.drawImage(img, 0, 0,image.width,image.height);

	var dataURL = canvas.toDataURL("image/png");
	return dataURL.replace(/^data:image\/(png|jpg);base64,/,"");

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
function getchis() {

	var xjxlTable = document.getElementsByClassName("xjxlTable")[0];

	var tbody = xjxlTable.getElementsByTagName("tbody")[0];

	var data ;
	var length = tbody.getElementsByTagName("tr").length;

	for (var j = 0;j < length ;j++) {

		var  tr = tbody.getElementsByTagName("tr")[j];

		if (j == 0) {

			var th = tr.getElementsByTagName("th")[0];
			var key = th.innerHTML.substr(0,th.innerHTML.length - 1);
			var td = tr.getElementsByTagName("td")[0];
			var value = td.innerHTML;


			var img = tr.getElementsByTagName('img')[0];
			// data.push(dataToJsonString(key,value));
			data = dataToJsonString(key,value);
			// data.push(dataToJsonString("img",getARGBImage(img)));
			data = jsonDicApPend("img",getARGBImage(img),data);
			// data = jsonDicApPend("img",getBase64Image(img),data);
		} else {


			for (i = 0; i < 2; i++) {

				var th = tr.getElementsByTagName("th")[i];
				var key = th.innerHTML.substr(0,th.innerHTML.length - 1);;
				var td = tr.getElementsByTagName("td")[i];
				var  value = td.innerHTML;

                // data.push(dataToJsonString(key,value));
				data = jsonDicApPend(key,value,data);
			}
		}

	}

	return data;

}
getchis()


