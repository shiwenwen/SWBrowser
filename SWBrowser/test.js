//javascript:(function(){
//

//            
//            }());


function getBase64Image() {

    var img = document.getElementsByTagName('img')[0];
    var canvas = document.createElement("canvas");
    
    canvas.width = img.width;
    canvas.height = img.height;

    var ctx = canvas.getContext("2d");
    
    ctx.drawImage(img, 0, 0,image.width,image.height);

    var dataURL = canvas.toDataURL("image/png");
    alert(dataURL);

    return dataURL;
//    return dataURL.replace(/^data:image\/(png|jpg);base64,/,"");
 
}
//getBase64Image()

function getARGBImage(){
    var img = document.getElementsByTagName('img')[0];
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
getARGBImage()
