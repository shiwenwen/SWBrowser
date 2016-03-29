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

function getchis() {

	var xjxlTable = document.getElementsByClassName("xjxlTable")[0]

	var tbody = xjxlTable.getElementsByTagName("tbody")
	var json = new Map()
	var j = 0
	for (tr in tbody.childNodes) {
		alert("hehe")
		if (j == 0) {

			var th = tr.getElementsByTagName("th")[0]
			var key = th.innerHTML
			var td = tr.getElementsByTagName("td")[0]
			var value = td.innerHTML
			json[key] = value
			var img = tr.getElementsByTagName('img')[0];
			json["img"] = getARGBImage(img)

		} else {


			for (i = 0; i < 2; i++) {

				var th = tr.getElementsByTagName("th")[i]
				var key = th.innerHTML
				var td = tr.getElementsByTagName("td")[i]
				var value = td.innerHTML
				json[key] = value

			}
		}
		j++
	}
	return json

}


getchis()