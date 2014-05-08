!function(e){var t=function(t,r){this.element=e(t);this.format=n.parseFormat(r.format||this.element.data("date-format")||"mm/dd/yyyy");this.picker=e(n.template).appendTo("body").on({click:e.proxy(this.click,this)});this.isInput=this.element.is("input");this.component=this.element.is(".date")?this.element.find(".add-on"):false;if(this.isInput){this.element.on({focus:e.proxy(this.show,this),keyup:e.proxy(this.update,this)})}else{if(this.component){this.component.on("click",e.proxy(this.show,this))}else{this.element.on("click",e.proxy(this.show,this))}}this.minViewMode=r.minViewMode||this.element.data("date-minviewmode")||0;if(typeof this.minViewMode==="string"){switch(this.minViewMode){case"months":this.minViewMode=1;break;case"years":this.minViewMode=2;break;default:this.minViewMode=0;break}}this.viewMode=r.viewMode||this.element.data("date-viewmode")||0;if(typeof this.viewMode==="string"){switch(this.viewMode){case"months":this.viewMode=1;break;case"years":this.viewMode=2;break;default:this.viewMode=0;break}}this.startViewMode=this.viewMode;this.weekStart=r.weekStart||this.element.data("date-weekstart")||0;this.weekEnd=this.weekStart===0?6:this.weekStart-1;this.onRender=r.onRender;this.fillDow();this.fillMonths();this.update();this.showMode()};t.prototype={constructor:t,show:function(t){this.picker.show();this.height=this.component?this.component.outerHeight():this.element.outerHeight();this.place();e(window).on("resize",e.proxy(this.place,this));if(t){t.stopPropagation();t.preventDefault()}if(!this.isInput){}var n=this;e(document).on("mousedown",function(t){if(e(t.target).closest(".datepicker").length==0){n.hide()}});this.element.trigger({type:"show",date:this.date})},hide:function(){this.picker.hide();e(window).off("resize",this.place);this.viewMode=this.startViewMode;this.showMode();if(!this.isInput){e(document).off("mousedown",this.hide)}this.element.trigger({type:"hide",date:this.date})},set:function(){var e=n.formatDate(this.date,this.format);if(!this.isInput){if(this.component){this.element.find("input").prop("value",e)}this.element.data("date",e)}else{this.element.prop("value",e)}},setValue:function(e){if(typeof e==="string"){this.date=n.parseDate(e,this.format)}else{this.date=new Date(e)}this.set();this.viewDate=new Date(this.date.getFullYear(),this.date.getMonth(),1,0,0,0,0);this.fill()},place:function(){var e=this.component?this.component.offset():this.element.offset();this.picker.css({top:e.top+this.height,left:e.left})},update:function(e){this.date=n.parseDate(typeof e==="string"?e:this.isInput?this.element.prop("value"):this.element.data("date"),this.format);this.viewDate=new Date(this.date.getFullYear(),this.date.getMonth(),1,0,0,0,0);this.fill()},fillDow:function(){var e=this.weekStart;var t="<tr>";while(e<this.weekStart+7){t+='<th class="dow">'+n.dates.daysMin[e++%7]+"</th>"}t+="</tr>";this.picker.find(".datepicker-days thead").append(t)},fillMonths:function(){var e="";var t=0;while(t<12){e+='<span class="month">'+n.dates.monthsShort[t++]+"</span>"}this.picker.find(".datepicker-months td").append(e)},fill:function(){var e=new Date(this.viewDate),t=e.getFullYear(),r=e.getMonth(),i=this.date.valueOf();this.picker.find(".datepicker-days th:eq(1)").text(n.dates.months[r]+" "+t);var s=new Date(t,r-1,28,0,0,0,0),o=n.getDaysInMonth(s.getFullYear(),s.getMonth());s.setDate(o);s.setDate(o-(s.getDay()-this.weekStart+7)%7);var u=new Date(s);u.setDate(u.getDate()+42);u=u.valueOf();var a=[];var f,l,c;while(s.valueOf()<u){if(s.getDay()===this.weekStart){a.push("<tr>")}f=this.onRender(s);l=s.getFullYear();c=s.getMonth();if(c<r&&l===t||l<t){f+=" old"}else if(c>r&&l===t||l>t){f+=" new"}if(s.valueOf()===i){f+=" active"}a.push('<td class="day '+f+'">'+s.getDate()+"</td>");if(s.getDay()===this.weekEnd){a.push("</tr>")}s.setDate(s.getDate()+1)}this.picker.find(".datepicker-days tbody").empty().append(a.join(""));var h=this.date.getFullYear();var p=this.picker.find(".datepicker-months").find("th:eq(1)").text(t).end().find("span").removeClass("active");if(h===t){p.eq(this.date.getMonth()).addClass("active")}a="";t=parseInt(t/10,10)*10;var d=this.picker.find(".datepicker-years").find("th:eq(1)").text(t+"-"+(t+9)).end().find("td");t-=1;for(var v=-1;v<11;v++){a+='<span class="year'+(v===-1||v===10?" old":"")+(h===t?" active":"")+'">'+t+"</span>";t+=1}d.html(a)},click:function(t){t.stopPropagation();t.preventDefault();var r=e(t.target).closest("span, td, th");if(r.length===1){switch(r[0].nodeName.toLowerCase()){case"th":switch(r[0].className){case"switch":this.showMode(1);break;case"prev":case"next":this.viewDate["set"+n.modes[this.viewMode].navFnc].call(this.viewDate,this.viewDate["get"+n.modes[this.viewMode].navFnc].call(this.viewDate)+n.modes[this.viewMode].navStep*(r[0].className==="prev"?-1:1));this.fill();this.set();break}break;case"span":if(r.is(".month")){var i=r.parent().find("span").index(r);this.viewDate.setMonth(i)}else{var s=parseInt(r.text(),10)||0;this.viewDate.setFullYear(s)}if(this.viewMode!==0){this.date=new Date(this.viewDate);this.element.trigger({type:"changeDate",date:this.date,viewMode:n.modes[this.viewMode].clsName})}this.showMode(-1);this.fill();this.set();break;case"td":if(r.is(".day")&&!r.is(".disabled")){var o=parseInt(r.text(),10)||1;var i=this.viewDate.getMonth();if(r.is(".old")){i-=1}else if(r.is(".new")){i+=1}var s=this.viewDate.getFullYear();this.date=new Date(s,i,o,0,0,0,0);this.viewDate=new Date(s,i,Math.min(28,o),0,0,0,0);this.fill();this.set();this.element.trigger({type:"changeDate",date:this.date,viewMode:n.modes[this.viewMode].clsName})}break}}},mousedown:function(e){e.stopPropagation();e.preventDefault()},showMode:function(e){if(e){this.viewMode=Math.max(this.minViewMode,Math.min(2,this.viewMode+e))}this.picker.find(">div").hide().filter(".datepicker-"+n.modes[this.viewMode].clsName).show()}};e.fn.datepicker=function(n,r){return this.each(function(){var i=e(this),s=i.data("datepicker"),o=typeof n==="object"&&n;if(!s){i.data("datepicker",s=new t(this,e.extend({},e.fn.datepicker.defaults,o)))}if(typeof n==="string")s[n](r)})};e.fn.datepicker.defaults={onRender:function(e){return""}};e.fn.datepicker.Constructor=t;var n={modes:[{clsName:"days",navFnc:"Month",navStep:1},{clsName:"months",navFnc:"FullYear",navStep:1},{clsName:"years",navFnc:"FullYear",navStep:10}],dates:{days:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],daysShort:["Sun","Mon","Tue","Wed","Thu","Fri","Sat","Sun"],daysMin:["Su","Mo","Tu","We","Th","Fr","Sa","Su"],months:["January","February","March","April","May","June","July","August","September","October","November","December"],monthsShort:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]},isLeapYear:function(e){return e%4===0&&e%100!==0||e%400===0},getDaysInMonth:function(e,t){return[31,n.isLeapYear(e)?29:28,31,30,31,30,31,31,30,31,30,31][t]},parseFormat:function(e){var t=e.match(/[.\/\-\s].*?/),n=e.split(/\W+/);if(!t||!n||n.length===0){throw new Error("Invalid date format.")}return{separator:t,parts:n}},parseDate:function(e,t){var n=e.split(t.separator),e=new Date,r;e.setHours(0);e.setMinutes(0);e.setSeconds(0);e.setMilliseconds(0);if(n.length===t.parts.length){var i=e.getFullYear(),s=e.getDate(),o=e.getMonth();for(var u=0,a=t.parts.length;u<a;u++){r=parseInt(n[u],10)||1;switch(t.parts[u]){case"dd":case"d":s=r;e.setDate(r);break;case"mm":case"m":o=r-1;e.setMonth(r-1);break;case"yy":i=2e3+r;e.setFullYear(2e3+r);break;case"yyyy":i=r;e.setFullYear(r);break}}e=new Date(i,o,s,0,0,0)}return e},formatDate:function(e,t){var n={d:e.getDate(),m:e.getMonth()+1,yy:e.getFullYear().toString().substring(2),yyyy:e.getFullYear()};n.dd=(n.d<10?"0":"")+n.d;n.mm=(n.m<10?"0":"")+n.m;var e=[];for(var r=0,i=t.parts.length;r<i;r++){e.push(n[t.parts[r]])}return e.join(t.separator)},headTemplate:"<thead>"+"<tr>"+'<th class="prev">&lsaquo;</th>'+'<th colspan="5" class="switch"></th>'+'<th class="next">&rsaquo;</th>'+"</tr>"+"</thead>",contTemplate:'<tbody><tr><td colspan="7"></td></tr></tbody>'};n.template='<div class="datepicker dropdown-menu">'+'<div class="datepicker-days">'+'<table class=" table-condensed">'+n.headTemplate+"<tbody></tbody>"+"</table>"+"</div>"+'<div class="datepicker-months">'+'<table class="table-condensed">'+n.headTemplate+n.contTemplate+"</table>"+"</div>"+'<div class="datepicker-years">'+'<table class="table-condensed">'+n.headTemplate+n.contTemplate+"</table>"+"</div>"+"</div>"}(window.jQuery);!function(e){var t=function(t,n){this.element=e(t);this.picker=e('<div class="slider">'+'<div class="slider-track">'+'<div class="slider-selection"></div>'+'<div class="slider-handle"></div>'+'<div class="slider-handle"></div>'+"</div>"+'<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'+"</div>").insertBefore(this.element).append(this.element);this.id=this.element.data("slider-id")||n.id;if(this.id){this.picker[0].id=this.id}if(typeof Modernizr!=="undefined"&&Modernizr.touch){this.touchCapable=true}var r=this.element.data("slider-tooltip")||n.tooltip;this.tooltip=this.picker.find(".tooltip");this.tooltipInner=this.tooltip.find("div.tooltip-inner");this.orientation=this.element.data("slider-orientation")||n.orientation;switch(this.orientation){case"vertical":this.picker.addClass("slider-vertical");this.stylePos="top";this.mousePos="pageY";this.sizePos="offsetHeight";this.tooltip.addClass("right")[0].style.left="100%";break;default:this.picker.addClass("slider-horizontal").css("width",this.element.outerWidth());this.orientation="horizontal";this.stylePos="left";this.mousePos="pageX";this.sizePos="offsetWidth";this.tooltip.addClass("top")[0].style.top=-this.tooltip.outerHeight()-14+"px";break}this.min=this.element.data("slider-min")||n.min;this.max=this.element.data("slider-max")||n.max;this.step=this.element.data("slider-step")||n.step;this.value=this.element.data("slider-value")||n.value;if(this.value[1]){this.range=true}this.selection=this.element.data("slider-selection")||n.selection;this.selectionEl=this.picker.find(".slider-selection");if(this.selection==="none"){this.selectionEl.addClass("hide")}this.selectionElStyle=this.selectionEl[0].style;this.handle1=this.picker.find(".slider-handle:first");this.handle1Stype=this.handle1[0].style;this.handle2=this.picker.find(".slider-handle:last");this.handle2Stype=this.handle2[0].style;var i=this.element.data("slider-handle")||n.handle;switch(i){case"round":this.handle1.addClass("round");this.handle2.addClass("round");break;case"triangle":this.handle1.addClass("triangle");this.handle2.addClass("triangle");break}if(this.range){this.value[0]=Math.max(this.min,Math.min(this.max,this.value[0]));this.value[1]=Math.max(this.min,Math.min(this.max,this.value[1]))}else{this.value=[Math.max(this.min,Math.min(this.max,this.value))];this.handle2.addClass("hide");if(this.selection=="after"){this.value[1]=this.max}else{this.value[1]=this.min}}this.diff=this.max-this.min;this.percentage=[(this.value[0]-this.min)*100/this.diff,(this.value[1]-this.min)*100/this.diff,this.step*100/this.diff];this.offset=this.picker.offset();this.size=this.picker[0][this.sizePos];this.formater=n.formater;this.layout();if(this.touchCapable){this.picker.on({touchstart:e.proxy(this.mousedown,this)})}else{this.picker.on({mousedown:e.proxy(this.mousedown,this)})}if(r==="show"){this.picker.on({mouseenter:e.proxy(this.showTooltip,this),mouseleave:e.proxy(this.hideTooltip,this)})}else{this.tooltip.addClass("hide")}};t.prototype={constructor:t,over:false,inDrag:false,showTooltip:function(){this.tooltip.addClass("in");this.over=true},hideTooltip:function(){if(this.inDrag===false){this.tooltip.removeClass("in")}this.over=false},layout:function(){this.handle1Stype[this.stylePos]=this.percentage[0]+"%";this.handle2Stype[this.stylePos]=this.percentage[1]+"%";if(this.orientation=="vertical"){this.selectionElStyle.top=Math.min(this.percentage[0],this.percentage[1])+"%";this.selectionElStyle.height=Math.abs(this.percentage[0]-this.percentage[1])+"%"}else{this.selectionElStyle.left=Math.min(this.percentage[0],this.percentage[1])+"%";this.selectionElStyle.width=Math.abs(this.percentage[0]-this.percentage[1])+"%"}if(this.range){this.tooltipInner.text(this.formater(this.value[0])+" : "+this.formater(this.value[1]));this.tooltip[0].style[this.stylePos]=this.size*(this.percentage[0]+(this.percentage[1]-this.percentage[0])/2)/100-(this.orientation==="vertical"?this.tooltip.outerHeight()/2:this.tooltip.outerWidth()/2)+"px"}else{this.tooltipInner.text(this.formater(this.value[0]));this.tooltip[0].style[this.stylePos]=this.size*this.percentage[0]/100-(this.orientation==="vertical"?this.tooltip.outerHeight()/2:this.tooltip.outerWidth()/2)+"px"}},mousedown:function(t){if(this.touchCapable&&t.type==="touchstart"){t=t.originalEvent}this.offset=this.picker.offset();this.size=this.picker[0][this.sizePos];var n=this.getPercentage(t);if(this.range){var r=Math.abs(this.percentage[0]-n);var i=Math.abs(this.percentage[1]-n);this.dragged=r<i?0:1}else{this.dragged=0}this.percentage[this.dragged]=n;this.layout();if(this.touchCapable){e(document).on({touchmove:e.proxy(this.mousemove,this),touchend:e.proxy(this.mouseup,this)})}else{e(document).on({mousemove:e.proxy(this.mousemove,this),mouseup:e.proxy(this.mouseup,this)})}this.inDrag=true;var s=this.calculateValue();this.element.trigger({type:"slideStart",value:s}).trigger({type:"slide",value:s});return false},mousemove:function(e){if(this.touchCapable&&e.type==="touchmove"){e=e.originalEvent}var t=this.getPercentage(e);if(this.range){if(this.dragged===0&&this.percentage[1]<t){this.percentage[0]=this.percentage[1];this.dragged=1}else if(this.dragged===1&&this.percentage[0]>t){this.percentage[1]=this.percentage[0];this.dragged=0}}this.percentage[this.dragged]=t;this.layout();var n=this.calculateValue();this.element.trigger({type:"slide",value:n}).data("value",n).prop("value",n);return false},mouseup:function(t){if(this.touchCapable){e(document).off({touchmove:this.mousemove,touchend:this.mouseup})}else{e(document).off({mousemove:this.mousemove,mouseup:this.mouseup})}this.inDrag=false;if(this.over==false){this.hideTooltip()}this.element;var n=this.calculateValue();this.element.trigger({type:"slideStop",value:n}).data("value",n).prop("value",n);return false},calculateValue:function(){var e;if(this.range){e=[this.min+Math.round(this.diff*this.percentage[0]/100/this.step)*this.step,this.min+Math.round(this.diff*this.percentage[1]/100/this.step)*this.step];this.value=e}else{e=this.min+Math.round(this.diff*this.percentage[0]/100/this.step)*this.step;this.value=[e,this.value[1]]}return e},getPercentage:function(e){if(this.touchCapable){e=e.touches[0]}var t=(e[this.mousePos]-this.offset[this.stylePos])*100/this.size;t=Math.round(t/this.percentage[2])*this.percentage[2];return Math.max(0,Math.min(100,t))},getValue:function(){if(this.range){return this.value}return this.value[0]},setValue:function(e){this.value=e;if(this.range){this.value[0]=Math.max(this.min,Math.min(this.max,this.value[0]));this.value[1]=Math.max(this.min,Math.min(this.max,this.value[1]))}else{this.value=[Math.max(this.min,Math.min(this.max,this.value))];this.handle2.addClass("hide");if(this.selection=="after"){this.value[1]=this.max}else{this.value[1]=this.min}}this.diff=this.max-this.min;this.percentage=[(this.value[0]-this.min)*100/this.diff,(this.value[1]-this.min)*100/this.diff,this.step*100/this.diff];this.layout()}};e.fn.slider=function(n,r){return this.each(function(){var i=e(this),s=i.data("slider"),o=typeof n==="object"&&n;if(!s){i.data("slider",s=new t(this,e.extend({},e.fn.slider.defaults,o)))}if(typeof n=="string"){s[n](r)}})};e.fn.slider.defaults={min:0,max:10,step:1,orientation:"horizontal",value:5,selection:"before",tooltip:"show",handle:"round",formater:function(e){return e}};e.fn.slider.Constructor=t}(window.jQuery)