<template>
  <div id="app">
    <DependencyGraph :classesData="classesData"/>
  </div>
</template>

<script>
import DependencyGraph from './components/DependencyGraph.vue'

const CLASSES_DATA = require('./data.json')

export default {
  name: 'app',
  components: {
    DependencyGraph
  },
  data() {
    return {
      classesData: CLASSES_DATA
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
