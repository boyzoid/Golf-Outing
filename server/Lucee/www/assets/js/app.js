(function(t){function e(e){for(var o,s,i=e[0],u=e[1],c=e[2],l=0,f=[];l<i.length;l++)s=i[l],a[s]&&f.push(a[s][0]),a[s]=0;for(o in u)Object.prototype.hasOwnProperty.call(u,o)&&(t[o]=u[o]);d&&d(e);while(f.length)f.shift()();return r.push.apply(r,c||[]),n()}function n(){for(var t,e=0;e<r.length;e++){for(var n=r[e],o=!0,s=1;s<n.length;s++){var u=n[s];0!==a[u]&&(o=!1)}o&&(r.splice(e--,1),t=i(i.s=n[0]))}return t}var o={},a={app:0},r=[];function s(t){return i.p+"assets/js/"+({courses:"courses",outings:"outings"}[t]||t)+".js"}function i(e){if(o[e])return o[e].exports;var n=o[e]={i:e,l:!1,exports:{}};return t[e].call(n.exports,n,n.exports,i),n.l=!0,n.exports}i.e=function(t){var e=[],n=a[t];if(0!==n)if(n)e.push(n[2]);else{var o=new Promise(function(e,o){n=a[t]=[e,o]});e.push(n[2]=o);var r,u=document.createElement("script");u.charset="utf-8",u.timeout=120,i.nc&&u.setAttribute("nonce",i.nc),u.src=s(t),r=function(e){u.onerror=u.onload=null,clearTimeout(c);var n=a[t];if(0!==n){if(n){var o=e&&("load"===e.type?"missing":e.type),r=e&&e.target&&e.target.src,s=new Error("Loading chunk "+t+" failed.\n("+o+": "+r+")");s.type=o,s.request=r,n[1](s)}a[t]=void 0}};var c=setTimeout(function(){r({type:"timeout",target:u})},12e4);u.onerror=u.onload=r,document.head.appendChild(u)}return Promise.all(e)},i.m=t,i.c=o,i.d=function(t,e,n){i.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:n})},i.r=function(t){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},i.t=function(t,e){if(1&e&&(t=i(t)),8&e)return t;if(4&e&&"object"===typeof t&&t&&t.__esModule)return t;var n=Object.create(null);if(i.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var o in t)i.d(n,o,function(e){return t[e]}.bind(null,o));return n},i.n=function(t){var e=t&&t.__esModule?function(){return t["default"]}:function(){return t};return i.d(e,"a",e),e},i.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},i.p="/",i.oe=function(t){throw console.error(t),t};var u=window["webpackJsonp"]=window["webpackJsonp"]||[],c=u.push.bind(u);u.push=e,u=u.slice();for(var l=0;l<u.length;l++)e(u[l]);var d=c;r.push([0,"chunk-vendors"]),n()})({0:function(t,e,n){t.exports=n("56d7")},"56d7":function(t,e,n){"use strict";n.r(e);n("744f"),n("6c7b"),n("7514"),n("20d6"),n("1c4c"),n("6762"),n("cadf"),n("e804"),n("55dd"),n("d04f"),n("c8ce"),n("217b"),n("7f7f"),n("f400"),n("7f25"),n("536b"),n("d9ab"),n("f9ab"),n("32d7"),n("25c9"),n("9f3c"),n("042e"),n("c7c6"),n("f4ff"),n("049f"),n("7872"),n("a69f"),n("0b21"),n("6c1a"),n("c7c62"),n("84b4"),n("c5f6"),n("2e37"),n("fca0"),n("7cdf"),n("ee1d"),n("b1b1"),n("87f3"),n("9278"),n("5df2"),n("04ff"),n("f751"),n("4504"),n("fee7"),n("ffc1"),n("0d6d"),n("9986"),n("8e6e"),n("25db"),n("e4f7"),n("b9a1"),n("64d5"),n("9aea"),n("db97"),n("66c8"),n("57f0"),n("165b"),n("456d"),n("cf6a"),n("fd24"),n("8615"),n("551c"),n("097d"),n("df1b"),n("2397"),n("88ca"),n("ba16"),n("d185"),n("ebde"),n("2d34"),n("f6b3"),n("2251"),n("c698"),n("a19f"),n("9253"),n("9275"),n("3b2b"),n("3846"),n("4917"),n("a481"),n("28a5"),n("386d"),n("6b54"),n("4f7f"),n("8a81"),n("ac4d"),n("8449"),n("9c86"),n("fa83"),n("48c0"),n("a032"),n("aef6"),n("d263"),n("6c37"),n("9ec8"),n("5695"),n("2fdb"),n("d0b0"),n("5df3"),n("b54a"),n("f576"),n("ed50"),n("788d"),n("14b9"),n("f386"),n("f559"),n("1448"),n("673e"),n("242a"),n("c66f"),n("b05c"),n("34ef"),n("6aa2"),n("15ac"),n("af56"),n("b6e4"),n("9c29"),n("63d9"),n("4dda"),n("10ad"),n("c02b"),n("4795"),n("130f"),n("ac6a"),n("96cf"),n("0cdd");var o=n("2b0e"),a=n("9f7b");o["default"].use(a["a"]);var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{attrs:{id:"app"}},[n("nav",{staticClass:"navbar navbar-expand-lg navbar-dark bg-dark"},[n("router-link",{staticClass:"navbar-brand",attrs:{to:"/"}},[t._v("Golf Outing")]),t._m(0),n("div",{staticClass:"collapse navbar-collapse",attrs:{id:"navbarSupportedContent"}},[n("ul",{directives:[{name:"show",rawName:"v-show",value:t.$store.state.authenticated,expression:"$store.state.authenticated"}],staticClass:"navbar-nav mr-auto"},[n("li",{staticClass:"nav-item",class:{active:"/"==t.$route.path}},[n("router-link",{staticClass:"nav-link",attrs:{to:"/"}},[t._v("Home "),n("span",{staticClass:"sr-only"},[t._v("(current)")])])],1),n("li",{staticClass:"nav-item"},[n("router-link",{staticClass:"nav-link",class:{active:t.isOutingNav},attrs:{to:"/outings"}},[t._v("Outings")])],1),n("li",{staticClass:"nav-item"},[n("router-link",{staticClass:"nav-link",class:{active:t.isCourseNav},attrs:{to:"/courses"}},[t._v("Courses")])],1),n("li",{staticClass:"nav-item"},[n("router-link",{staticClass:"nav-link",class:{active:t.isGolferNav},attrs:{to:"/golfers"}},[t._v("Golfers")])],1),n("li",{staticClass:"nav-item"},[n("a",{staticClass:"nav-link",attrs:{href:"#"},on:{click:function(e){return t.logout()}}},[t._v("Logout")])])]),t.$store.state.production?t._e():n("div",{staticClass:"alert alert-danger bold",attrs:{id:"dev-mode"}},[t._v("DEVELOPMENT MODE")])])],1),n("router-view",{on:{authenticated:t.setAuthenticated}})],1)},s=[function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("button",{staticClass:"navbar-toggler",attrs:{type:"button","data-toggle":"collapse","data-target":"#navbarSupportedContent","aria-controls":"navbarSupportedContent","aria-expanded":"false","aria-label":"Toggle navigation"}},[n("span",{staticClass:"navbar-toggler-icon"})])}],i={name:"App",data:function(){return{authenticated:!1,mockAccount:{username:"scott.stroz@gmail.com",password:"password"}}},mounted:function(){this.$store.dispatch("setEnvironment",{production:!0,apiRoot:"https://outing.mygolfleague.net"}),this.$store.state.authenticated||this.$router.replace({name:"login"})},methods:{setAuthenticated:function(t){t.success&&(this.$store.dispatch("login"),this.$store.dispatch("setToken",t.token))},logout:function(){this.$store.dispatch("logout"),this.$router.replace({name:"login"})}},beforeCreate:function(){this.$store.subscribe(function(t,e){localStorage.setItem("store",JSON.stringify(e))}),this.$store.commit("initialiseStore")},computed:{isCourseNav:function(){return"courses"==this.$route.name||"course"==this.$route.name},isOutingNav:function(){return"outings"==this.$route.name||"outing"==this.$route.name||"scoring"==this.$route.name},isGolferNav:function(){return"golfers"==this.$route.name}}},u=i,c=(n("5c0b"),n("2877")),l=Object(c["a"])(u,r,s,!1,null,null,null),d=l.exports,f=n("8c4f"),g=function(){var t=this,e=t.$createElement;t._self._c;return t._m(0)},p=[function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"col-10 offset-1"},[n("h1",{staticClass:"text-center"},[t._v("Golf Outing")]),n("p",[t._v('Take a mulligan, A scratch golfer, Good break! Fried egg Tom Watson Duck hook! Losing your ball in the rough, At the Clubhouse, Roll around on the ground laughing, Completely missed the ball, oops! While drinking beer Look out a ball is coming straight for you! Run down the fairway shouting Taking a practise swing, Score a double bogey Start your backswing, take it slow. Run down the fairway shouting Cheating on the next hole Spoon Begin the back nine holes, And getting annoyed Score an albatross You got the yips "Get in the hole!" Roll around on the ground laughing, To buy a drink for Lose your putter, forced to go home. Brassie.')]),n("p",[t._v("Roll around on the ground laughing, Tiger Woods Visit the golf range, And lose your mind, Ostrich Niblick Pull out your 3-wood and.... That's a big slice Score a bogey 3-iron comes out, Looking for a new angle of attack Win the Green Jacket Plugged lie in the bunker Open stance Thinking your at Sunningdale Run down the fairway shouting Shouting Fore as loud as you can. Look out a ball is coming straight for you! Pulled to the left Feeling happy now, Splash shot Time to buy some new clubs And swing. A controlled draw Begin the back nine holes, Phoenix Making a lot of noise.")])])}],h={data:function(){return{}}},m=h,b=Object(c["a"])(m,g,p,!1,null,null,null),v=b.exports;o["default"].use(f["a"]);var k=new f["a"]({mode:"history",base:"/",routes:[{path:"/",name:"home",component:v},{path:"/login",name:"login",component:function(){return n.e("courses").then(n.bind(null,"a55b"))}},{path:"/outings",name:"outings",component:function(){return n.e("outings").then(n.bind(null,"3eb8"))}},{path:"/outing/:id",name:"outing",component:function(){return n.e("courses").then(n.bind(null,"19e8"))}},{path:"/scoring/:id",name:"scoring",component:function(){return n.e("courses").then(n.bind(null,"0632"))}},{path:"/courses",name:"courses",component:function(){return n.e("courses").then(n.bind(null,"1a2f"))}},{path:"/course/:id",name:"course",component:function(){return n.e("courses").then(n.bind(null,"9f72"))}},{path:"/golfers",name:"golfers",component:function(){return n.e("courses").then(n.bind(null,"6dd9"))}}]}),y=n("2f62");o["default"].use(y["a"]);var w=new y["a"].Store({state:{authenticated:!1,token:null,production:"true",apiRoot:"https://outing.mygolfleague.net"},mutations:{initialiseStore:function(t){localStorage.getItem("store")&&this.replaceState(Object.assign(t,JSON.parse(localStorage.getItem("store"))))},setAuthenticated:function(t,e){t.authenticated=e},setToken:function(t,e){t.token=e},setProduction:function(t,e){t.production=e},setApiRoot:function(t,e){t.apiRoot=e}},actions:{login:function(t){t.commit("setAuthenticated",!0),t.commit("setToken","moo")},logout:function(t){t.commit("setAuthenticated",!1),t.commit("setToken",null)},setEnvironment:function(t,e){t.commit("setProduction",e.production),t.commit("setApiRoot",e.apiRoot)},setToken:function(t,e){t.commit("setToken",e)}}}),C=(n("4989"),n("bc3a")),_=n.n(C),S=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticClass:"text-center"},[n("b-spinner",{attrs:{variant:"primary",type:"grow",label:"Spinning"}})],1)},$=[],O={name:"loader",data:function(){return{}}},T=O,j=Object(c["a"])(T,S,$,!1,null,null,null),x=j.exports,A=n("415c"),P=n.n(A),E=n("7bb1"),N=n("859b"),R=n.n(N);n("d355");_.a.defaults.baseURL="https://outing.mygolfleague.net",_.a.interceptors.response.use(function(t){return void 0!=t.data.token&&void 0!=t.data.success&&t.data.success&&w.dispatch("setToken",t.data.token),t},function(t){return 401===t.response.status&&(w.dispatch("logout"),k.replace({name:"login"})),Promise.reject(t)}),o["default"].config.productionTip=!1;var L={name:"lodash"};o["default"].use(P.a,L),o["default"].use(E["a"],{inject:!0,fieldsBagName:"veeFields",errorBagName:"veeErrors",events:""}),o["default"].use(n("2ead")),o["default"].use(R.a),o["default"].component("loader",x),new o["default"]({router:k,store:w,render:function(t){return t(d)}}).$mount("#app")},"5c0b":function(t,e,n){"use strict";var o=n("5e27"),a=n.n(o);a.a},"5e27":function(t,e,n){}});
//# sourceMappingURL=app.js.map