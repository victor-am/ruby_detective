<template>
  <div id="app">
    <div class="toolbar">
      <el-form class="search-bar">
        <h1 class="logo"><Logo/> Ruby Detective</h1>

        <el-form-item>
          <el-input v-model.lazy="classSearchTerm" placeholder="Search for classes and files..."/>
        </el-form-item>
      </el-form>

      <ul class="class-list">
        <li class="class-item" v-for="classData in filteredClassesList" :key="classData.full_name">
          <ClassCard :classData="classData" @selectClass="selectClass"></ClassCard>
        </li>
      </ul>
    </div>

    <el-button size="mini" @click="selectFullGraph" class="full-graph-button">Show full project graph</el-button>

    <DependencyGraph class="graph" :classesData="filteredClassesData"/>
  </div>
</template>

<script>
import Fuse from 'fuse.js'

import DependencyGraph from './components/DependencyGraph.vue'
import ClassCard from './components/ClassCard.vue'
import Logo from './assets/logo.svg';

let CLASSES_DATA
if (process.env.NODE_ENV == 'production') {
  CLASSES_DATA = JSON.parse(document.getElementById("classes-data").innerHTML)
} else {
  CLASSES_DATA = require('./data.json')
}

export default {
  name: 'app',
  components: {
    DependencyGraph,
    ClassCard,
    Logo
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
        keys: ['full_name', 'file_path']
      }

      return new Fuse(this.classesData, options)
    },

    filteredClassesList() {
      return this.classSearchTerm == '' ? this.classesData : this.fuzzySearcher.search(this.classSearchTerm)
    },

    filteredClassesData() {
      const selectedClass = this.classesData.filter((c) => c.full_name == this.selectedClass)[0]

      if (this.showFullGraph == true) { return this.classesData }
      if (selectedClass === undefined) { return [] }

      const dependentsAndDependencies = this.classesData.filter((c) => {
        return c.dependencies.includes(selectedClass.full_name) || selectedClass.dependencies.includes(c.full_name)
      })

      return dependentsAndDependencies.concat(selectedClass)
    }
  },

  methods: {
    selectClass(classData) {
      this.selectedClass = classData.full_name
      this.showFullGraph = false
    },
    selectFullGraph() {
      this.showFullGraph = true
      this.selectedClass = ''
    }
  }
}
</script>

<style>
/*! minireset.css v0.0.6 | MIT License | github.com/jgthms/minireset.css */html,body,p,ol,ul,li,dl,dt,dd,blockquote,figure,fieldset,legend,textarea,pre,iframe,hr,h1,h2,h3,h4,h5,h6{margin:0;padding:0}h1,h2,h3,h4,h5,h6{font-size:100%;font-weight:normal}ul{list-style:none}button,input,select,textarea{margin:0}html{box-sizing:border-box}*,*::before,*::after{box-sizing:inherit}img,video{height:auto;max-width:100%}iframe{border:0}table{border-collapse:collapse;border-spacing:0}td,th{padding:0}td:not([align]),th:not([align]){text-align:left}

h1 { font-size: 20px; }
h2 { font-size: 18px; }
h3 { font-size: 16px; }
h4 { font-size: 14px; }

#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  display: flex;
  height: 100vh;
  width: 100vw;
}

.logo {
  margin: 10px 0 10px 0;
  display: flex;
  align-items: center;
  justify-content: center;
  padding-right: 25px;
}

.logo svg {
  margin-right: 5px;
  width: 50px;
  height: 50px;
}

.toolbar {
  width: 25%;
  height: 100%;
  display: flex;
  flex-direction: column;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  z-index: 1;
}

.toolbar .search-bar {
  width: 100%;
  border-bottom-right-radius: 11px;
  padding: 0 15px 0 15px;
  background-color: rgba(255,255,255,0.9);
  box-shadow: #00000026 2px 2px 3px;
  z-index: 2;
}

.toolbar .class-list {
  padding-top: 10px;
  overflow-y: scroll;
  height: auto;
}

.graph {
  width: 100%;
}

.class-item {
  margin: 0 20px 10px 15px;
}

.full-graph-button {
  position: absolute;
  right: 15px;
  top: 10px;
  z-index: 1;
}
</style>
