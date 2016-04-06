/**
 * Created by Shiwenwen on 16/4/1.
 */

function loadJquery() {
    var head = document.getElementsByTagName("head")[0]
    var script = document.createElement("script")
    head.appendChild(script)
    script.setAttribute("src","http://static.bestudent.cn/js/jquery.js")
}
loadJquery()

