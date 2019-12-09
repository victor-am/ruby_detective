<template>
  <div id="app">
    <div class="toolbar">
      <div class="search-bar">
        <input v-model="classSearchTerm">
        <button @click="showFullGraph = true; selectedClass = false">Show full project graph</button>
      </div>

      <ul class="class-list">
        <li class="class-item" v-for="classData in filteredClassesList" :key="classData.full_name" @click="selectedClass = classData.full_name; showFullGraph = false">
          {{ classData.full_name }}
        </li>
      </ul>
    </div>
    <DependencyGraph class="graph" :classesData="filteredClassesData"/>
  </div>
</template>

<script>
import Fuse from 'fuse.js'

import DependencyGraph from './components/DependencyGraph.vue'

const CLASSES_DATA = require('./data.json')

export default {
  name: 'app',
  components: {
    DependencyGraph
  },
  data() {
    return {
      classesData: CLASSES_DATA,
      classSearchTerm: '',
      selectedClass: '',
      showFullGraph: false
    }
  },
  computed: {
    fuzzySearcher() {
      const options = {
        keys: [
          {
            name: 'full_name',
            weight: 1
          }
        ]
      }

      return new Fuse(this.classesData, options)
    },

    filteredClassesList() {
      return this.classSearchTerm == '' ? this.classesData : this.fuzzySearcher.search(this.classSearchTerm)
    },

    filteredClassesData() {
      if (this.showFullGraph == true) { return this.classesData }

      const selectedClass = this.selectedClass

      const classes = this.classesData.filter((c) => {
        return c.name == selectedClass || c.dependencies.includes(selectedClass)
      })

      const classesNames = classes.map((c) => c.full_name)

      const matchedClassDependencies = this.classesData.filter((c) => classesNames.includes(c.full_name))
      const uniqueDependencies = matchedClassDependencies.filter((cd) => !classesNames.includes(cd.full_name))

      return classes.concat(uniqueDependencies)
    }
  }
}
</script>

<style>
/*! minireset.css v0.0.6 | MIT License | github.com/jgthms/minireset.css */html,body,p,ol,ul,li,dl,dt,dd,blockquote,figure,fieldset,legend,textarea,pre,iframe,hr,h1,h2,h3,h4,h5,h6{margin:0;padding:0}h1,h2,h3,h4,h5,h6{font-size:100%;font-weight:normal}ul{list-style:none}button,input,select,textarea{margin:0}html{box-sizing:border-box}*,*::before,*::after{box-sizing:inherit}img,video{height:auto;max-width:100%}iframe{border:0}table{border-collapse:collapse;border-spacing:0}td,th{padding:0}td:not([align]),th:not([align]){text-align:left}

#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  display: flex;
  height: 100vh;
  width: 100vw;
}

.toolbar {
  width: 25%;
  background: #333;
  color: #eee;
  height: 100%;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.toolbar .search-bar {
  width: 100%;
  margin-bottom: 2px;
  padding-top: 20px;
  padding-bottom: 20px;
  border-bottom: 1px solid #666;
}

.toolbar .class-list {
  overflow-y: scroll;
  height: auto;
  text-align: left;
  margin-left: 10px;
}

.graph {
  width: 75%;
}
</style>
