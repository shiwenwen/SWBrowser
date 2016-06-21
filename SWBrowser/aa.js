function setupWebViewJavascriptBridge(callback) {
	if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
	if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
	window.WVJBCallbacks = [callback];
	var WVJBIframe = document.createElement('iframe');
	WVJBIframe.style.display = 'none';
	WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
	document.documentElement.appendChild(WVJBIframe);
	setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

setupWebViewJavascriptBridge(function(bridge) {

})

function getinfo(){
	url = window.location.href;
	a = url.indexOf("#")>0?url.indexOf("#"):url.length;
	toUrl = url.substring(0,a);
	var mainStr="{}";
	var main = JSON.parse(mainStr);
	if(url.indexOf("#")<0){
		//解析 基本信息
		main.info = base();
		main.next = toUrl+"#assets";//需要控制跳转到下一个url
	}else if(url.indexOf("#assets")>0){
		//解析 无形资产
		main.info = assets();

	}
	return main
}


function assets(){
	var mainStr="{}";
	var main = JSON.parse(mainStr);
	var assStr="[]";
	var ass = JSON.parse(assStr);
	var obj = $("#assets_div>section>div.col-md-6");
	obj.each(function(i,data){
		var a = {
			"企业名称": filterText($(data).find("section div.clear>span>div").text()),
			"网址": filterText($(data).find("section div.clear>small:eq(0)>span").text()),
			"网站备案号": filterText($(data).find("section div.clear>small:eq(1)>span").text()),
			"审核时间": filterText($(data).find("section div.clear>small:eq(2)>span").text())
		}
		ass.push(a);
	});
	main.无形资产 = ass;
	return main;
}


function base(){

	var mainStr="{}";
	var main = JSON.parse(mainStr);
	main.基本信息 = baseInfo();
	main.股东信息 = shareholder();
	main.主要人员 = mainPerson();
	main.变更信息 = changeInfo();
	return main;
}



//解析基本信息
function baseInfo(){
	var objectStr="{}";
	var object = JSON.parse(objectStr);

	object.公司名称 = $("#company-top>div>div>span.clear>span:first").text();
	object.电话 = parseText($("#company-top>div>div>span.clear>small:eq(0)"));
	object.邮箱 = $("#company-top>div>div>span.clear>small>a:eq(0)").text();
	object.公司网址 = $("#company-top>div>div>span.clear>small>a:eq(1)").text();
	object.法律诉讼数量 = $("#susong_title>span").text();
	object.对外投资数量 = $("#touzi_title>span").text();
	object.无形资产数量 = $("#assets_title>span").text();
	object.浏览量 = $("div.side-num:first").text();



	var obj = $("#base_div ul>li");
	obj.each(function(i,data){
		var text = $(data).children("label:first").text();
		if(text.indexOf("注册号：")>=0){
			object.注册号 = parseText(data);
		}else  if(text.indexOf("统一社会信用代码：")>=0){
			object.统一社会信用代码 = parseText(data);
		}else  if(text.indexOf("组织机构代码：")>=0){
			object.组织机构代码 = parseText(data);
		}else  if(text.indexOf("经营状态：")>=0){
			object.经营状态 = parseText(data);
		}else  if(text.indexOf("公司类型：")>=0){
			object.公司类型 = parseText(data);
		}else  if(text.indexOf("成立日期：")>=0){
			object.成立日期 = parseText(data);
		}else  if(text.indexOf("法定代表：")>=0){
			object.法定代表 = $(data).children("a:first").text();
		}else  if(text.indexOf("注册资本：")>=0){
			object.注册资本 = parseText(data);
		}else  if(text.indexOf("登记机关：")>=0){
			object.登记机关 = parseText(data);
		}else  if(text.indexOf("营业期限：")>=0){
			object.营业期限 = parseText(data);
		}else  if(text.indexOf("发照日期：")>=0){
			object.发照日期 = parseText(data);
		}else  if(text.indexOf("企业地址：")>=0){
			object.企业地址 = parseText(data);
		}
//		 else  if(text.indexOf("经营范围：")>=0){
//			 object.经营范围 = parseText(data);
//		 }
	});
	return object;
}

//解析股东信息
function shareholder(){
	var shareholder = "[]";
	var shareholderObj = JSON.parse(shareholder);
	var shareObj = $("#base_div>section:eq(1)>.col-md-6 div.clear");
	shareObj.each(function(i,data){
		var a = {
			"姓名":$(data).children("a:first").text(),
			"角色":$(data).children("small:first").text()
		}
		shareholderObj.push(a);
	});
	return shareholderObj;
}

//解析主要人员
function mainPerson(){
	var mainPersonStr = "[]";
	var mainPersonObj = JSON.parse(mainPersonStr);
	var shareObj = $("#base_div>section:eq(2)>.col-md-3 div.clear");
	shareObj.each(function(i,data){
		var a = {
			"姓名":$(data).children("a:first").text(),
			"职位":$(data).children("small:first").text()
		}
		mainPersonObj.push(a);
	});
	return mainPersonObj;

}

function changeInfo(){
	var changeStr = "[]";
	var changeObj = JSON.parse(changeStr);
	var shareObj = $("#base_div>section:eq(3)>.col-md-12");

	var change;
	shareObj.each(function(i,data){
		var a = {
			"变更项目":$(data).find("section .col-md-6:eq(0) span").text(),
			"变更日期":$(data).find("section .col-md-6:eq(1) span").text()
		}
		changeObj.push(a);
	});
	return changeObj;
}



function parseText(data){
	var str = $(data).contents().filter(function() {
		return this.nodeType == 3;
	}).text();


	return filterText(str);
}

function filterText(str){
	while (str.indexOf("\n") >= 0 ){
		str = str.replace("\n", "");
	}
	while (str.indexOf("\t") >= 0 ){
		str = str.replace("\t", "");
	}
	return str;
}
window.WebViewJavascriptBridge.callHandler('getQiChaChaData', getinfo(), function(response) {

	log('JS got response', response)
	alert('JS got response')
})



