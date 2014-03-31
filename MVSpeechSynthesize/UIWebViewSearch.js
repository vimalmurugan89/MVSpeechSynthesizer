var uiWebview_SearchResultCount = 0;

function uiWebview_HighlightAllOccurencesOfStringForElement(element,keyword) {
    
    if (element) {
        if (element.nodeType == 3) {        // Text node
            
            while (true) {
                //if (counter < 1) {
                var value = element.nodeValue;  // Search for keyword in text node
               
                var idx = value.toLowerCase().indexOf(keyword);
                
                if (idx < 0) break;             // not found, abort
                
                //(value.split);
                
                //we create a SPAN element for every parts of matched keywords
                var span = document.createElement("span");
                var text = document.createTextNode(value.substr(idx,keyword.length));
                span.appendChild(text);
                
                span.setAttribute("class","uiWebviewHighlight");
                span.style.backgroundColor="yellow";
                span.style.color="black";
                
                uiWebview_SearchResultCount++;    // update the counter
                
                text = document.createTextNode(value.substr(idx+keyword.length));
                element.deleteData(idx, value.length - idx);
                var next = element.nextSibling;
                element.parentNode.insertBefore(span, next);
                element.parentNode.insertBefore(text, next);
                element = text;
                window.scrollTo(0,span.offsetTop);
                
            }
        } else if (element.nodeType == 1) { // Element node
           // alert('empty1');
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    
                    uiWebview_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
                }
            }
        }
    }
}

// the main entry point to start the search
function uiWebview_HighlightAllOccurencesOfString(keyword) {
 
    uiWebview_RemoveAllHighlights();
    uiWebview_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}

function uiWebview_HighlightAllOccurencesOfStringWithRange(startValue,keyword){
   //  alert('empty1='+startValue+keyword);
    uiWebview_RemoveAllHighlights();
    uiWebview_HighlightAllOccurencesOfStringValueRange(document.body,startValue,keyword.toLowerCase());
}
function uiWebview_HighlightAllOccurencesOfStringValueRange(element,startValue,keyword){
    
   
    if (element) {
        if (element.nodeType == 3) {
            var totalPArsingValue="";
            var nextValue="";
            while (true) {
                //if (counter < 1) {
                var value = element.nodeValue;  // Search for keyword in text node
                
                var idx =value.toLowerCase().indexOf(keyword);
                totalPArsingValue=totalPArsingValue+idx+',';
//                if(idx>3)
//                alert('idx'+idx+'index'+startValue+'word='+keyword);
                
                if (idx < 0){
                    //alert('idx'+value);
                    break;             // not found, abort
                }
                //(value.split);
            
                //we create a SPAN element for every parts of matched keywords
                var span = document.createElement("span");
                var textValue=value.substr(idx,keyword.length);
                var text = document.createTextNode(textValue);
       //         totalPArsingValue=totalPArsingValue+textValue+',';
                
                
                span.appendChild(text);
               // alert('text'+text);
                span.setAttribute("class","uiWebviewHighlight");
                span.style.backgroundColor="green";
                span.style.color="white";
                
               // uiWebview_SearchResultCount++;    // update the counter
                var nextString=value.substr(idx+keyword.length);
                text = document.createTextNode(nextString);
                nextValue=nextValue+nextString+',';
                element.deleteData(idx, value.length - idx);
                var next = element.nextSibling;
                element.parentNode.insertBefore(span, next);
                element.parentNode.insertBefore(text, next);
                element = text;
           //     window.scrollTo(0,span.offsetTop);
                
            }
            alert('value='+totalPArsingValue+'next'+nextValue);
        } else if (element.nodeType == 1) {
            
            if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
               
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    
                    uiWebview_HighlightAllOccurencesOfStringValueRange(element.childNodes[i],startValue,keyword);
                   
                }
            }
        }
    }
}
// helper function, recursively removes the highlights in elements and their childs
function uiWebview_RemoveAllHighlightsForElement(element) {
    if (element) {
        if (element.nodeType == 1) {
            if (element.getAttribute("class") == "uiWebviewHighlight") {
                var text = element.removeChild(element.firstChild);
                element.parentNode.insertBefore(text,element);
                element.parentNode.removeChild(element);
                return true;
            } else {
                var normalize = false;
                for (var i=element.childNodes.length-1; i>=0; i--) {
                    if (uiWebview_RemoveAllHighlightsForElement(element.childNodes[i])) {
                        normalize = true;
                    }
                }
                if (normalize) {
                    element.normalize();
                }
            }
        }
    }
    return false;
}
function highlight(value) {
    
    var mainDiv = document.getElementById("main");
    var startNode = mainDiv.firstChild.firstChild;
    var endNode = mainDiv.childNodes[2].firstChild;
    
    var range = document.createRange();
    range.setStart(startNode, 0); // 6 is the offset of "world" within "Hello world"
    range.setEnd(endNode, 5); // 7 is the length of "this is"
    var sel = window.getSelection();
    sel.removeAllRanges();
    sel.addRange(range);
   
    var startValue='';
  //  var range1 =window.getSelection().getRangeAt(0);
  //  var range = document.createRange();
  //  var div=document.getElementById('value');//ByTagName("body");
   
  //   priorRange = range.cloneRange();
  //  range.setStart(div.firstChild, 8);
 //   range.setEnd(div,11);
   // var selcet=document.getSelection();
   // selcet.addRange(range);
 //   alert('value'+div.firstChild);
   //  alert('range'+range);
   //
    var selectionContents = range.extractContents();
    //alert('cont'+selectionContents);
    var span = document.createElement("span");
    span.appendChild(selectionContents);
    span.setAttribute("class","uiWebviewHighlight");
    span.style.backgroundColor = "yellow";
    span.style.color = "black";
    range.insertNode(span);
    // alert('value'+mainDiv.firstChild);
    alert('range'+range.startOffset+range.endOffset+range.startContainer+range.endContainer);
}

function childNodesDetails(){
 //   alert('alert');
    var element=document.body;
    var details="";
    for (var i=element.childNodes.length-1; i>=0; i--) {
      
        details=details+element.childNodes[i].nodeValue+',';
        // break;
        }
    return details;
  //  return element;
}

// the main entry point to remove the highlights
function uiWebview_RemoveAllHighlights() {
    uiWebview_SearchResultCount = 0;
    uiWebview_RemoveAllHighlightsForElement(document.body);
}