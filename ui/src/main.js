import Vue from 'vue'
import App from './App.vue'
import './plugins/element.js'

Vue.config.productionTip = false

// If in production fetches the data from the HTML, otherwise (development mode)
// it gets it through the file src/data.json.
if (process.env.NODE_ENV == 'production') {
  const classesDataString = document.getElementById("classes-data").innerHTML
  window.CLASSES_DATA = JSON.parse(classesDataString)
} else {
  window.CLASSES_DATA = require('./data.json')
}

new Vue({
  render: h => h(App),
}).$mount('#app')
