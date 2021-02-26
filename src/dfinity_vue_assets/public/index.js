import Vue from 'vue'
import Vuetify from 'vuetify'
import 'vuetify/dist/vuetify.min.css'

if (process.env.NODE_ENV === "development") {
  if (!(window).ic) {
    const { HttpAgent, IDL } = require("@dfinity/agent");
    const createAgent = require("./createAgent").default;
    (window).ic = { agent: createAgent(), HttpAgent, IDL };
  }

  if (!document.getElementById("app")) {
    document.write('<div id="app"></div>');
    const container = document.createElement("div");
    container.id = "app";
    document.body.appendChild(container);
  }
}


Vue.use(Vuetify)
const App = require("./App.vue").default;


new Vue({
  vuetify: new Vuetify({}),
  render: (h) => h(App)
}).$mount('#app')


// const canisterAssets = require("ic:canisters/dfinity_vue_assets").default;
//   // use the asset canister's retrieve method to request a file (the `index.html` file from above)
//   canisterAssets.retrieve("index.html").then((htmlBytes) => {
//     // now that you have the html, decode it and create a new element
//     const html = new TextDecoder().decode(new Uint8Array(htmlBytes));
//     console.log(html);
//     const el = new DOMParser().parseFromString(html, "text/html");
//     console.log(el);
//     // insert your HTML into the bootstrap HTML under the element with id `"app"`
    
    

//     document.getElementById("app").innerHTML = el.body.innerHTML;

//     const container = document.createElement("div");
//     container.id = "vue_app";
//     document.body.appendChild(container);

//     const App = require("./App.vue").default;
//     new Vue({
//       vuetify: new Vuetify({}),
//       render: (h) => h(App)
//     }).$mount('#vue_app')
//   });