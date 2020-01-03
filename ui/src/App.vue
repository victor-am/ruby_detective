<template>
  <div id="app">
    <div class="toolbar">
      <el-form class="search-bar" @submit.native.prevent="classSearchTerm = visualClassSearchTerm">
        <h1 class="logo"><Logo/> Ruby Detective</h1>

        <el-form-item>
          <el-input v-model="visualClassSearchTerm" placeholder="Search for classes and files..."/>
          <p class="sort-by-label">Sort by</p>
          <el-radio-group class="sort-radio" v-model="sortCriteria" size="mini">
            <el-radio-button label="dependents">Dependents</el-radio-button>
            <el-radio-button label="linesOfCode">LoC</el-radio-button>
            <el-radio-button label="dependencies">Dependencies</el-radio-button>
            <el-radio-button label="selection">Selection</el-radio-button>
          </el-radio-group>
        </el-form-item>
      </el-form>

      <ul class="class-list" ref="classList">
        <li class="results-stats">
          {{ filteredClasses.length }} results found
        </li>
        <li class="class-item" v-for="classData in filteredClasses" :key="classData.full_name">
          <ClassCard :classData="classData" @clickMoreDetails="true" @clickToggleGraph="toggleClassFromGraph" :isSelected="isSelected(classData)"></ClassCard>
        </li>
      </ul>
    </div>

    <el-button size="mini" @click="clearGraph" class="clear-graph-button">Clear {{ graphSelectedClasses.length }} items selected</el-button>
    <el-button size="mini" @click="selectFullGraph" class="full-graph-button">Show full project graph</el-button>
    <DependencyGraph class="graph" :classesData="classesFilteredBySelection" :selectedClasses="graphSelectedClasses"/>
  </div>
</template>

<script>
import Fuse from 'fuse.js'

import DependencyGraph from './components/DependencyGraph.vue'
import ClassCard from './components/ClassCard.vue'
import Logo from './assets/logo.svg';

import uniq from 'lodash/uniq'

export default {
  name: 'app',
  components: {
    DependencyGraph,
    ClassCard,
    Logo
  },
  data() {
    return {
      classesData: window.CLASSES_DATA,
      classSearchTerm: '',
      visualClassSearchTerm: '',
      graphSelectedClasses: [],
      sortCriteria: 'linesOfCode'
    }
  },

  watch: {
    filteredClasses() {
      this.$nextTick(() => { this.$refs.classList.scrollTop = 0 });
    }
  },

  computed: {
    fuzzySearcher() {
      const options = { threshold: 0.1, keys: ['full_name', 'file_path'] }
      return new Fuse(this.classesData, options)
    },

    filteredClasses() {
      if (this.classSearchTerm == '') {
        return this.sortClasses(this.classesData)
      } else {
        const searchResults = this.fuzzySearcher.search(this.classSearchTerm)
        return this.sortClasses(searchResults)
      }
    },

    classesFilteredBySelection() {
      const dependentsAndDependencies = this.graphSelectedClasses.map((selectedClass) => {
        return this.dependentsAndDependenciesOf(selectedClass)
      }).flat()
      const dataset = this.graphSelectedClasses.concat(dependentsAndDependencies)

      return uniq(dataset, 'full_name')
    },

    graphSelectedClassesNames() {
      return this.graphSelectedClasses.map((c) => c.full_name)
    }
  },

  methods: {
    toggleClassFromGraph(klass) {
      if (this.isSelected(klass)) {
        this.graphSelectedClasses = this.graphSelectedClasses.filter((c) => c.full_name != klass.full_name)
      } else {
        this.graphSelectedClasses.push(klass)
      }
    },
    selectFullGraph() {
      this.graphSelectedClasses = this.classesData
    },
    clearGraph() {
      this.graphSelectedClasses = []
    },
    sortClasses(collection) {
      return collection.slice().sort(this.classSortFunction)
    },
    classSortFunction(a, b) {
      const criteria = this.sortCriteria

      if (criteria == 'dependents') {
        return b.dependents.length - a.dependents.length;
      } else if (criteria == 'dependencies') {
        return b.dependencies.length - a.dependencies.length;
      } else if (criteria == 'linesOfCode') {
        return b.lines_of_code - a.lines_of_code;
      } else if (criteria == 'selection') {
        return (a === b)? 0 : this.isSelected(a)? -1 : 1;
      }
    },
    dependentsAndDependenciesOf(klass) {
      return this.classesData.filter((anotherClass) => {
        return anotherClass.dependencies.includes(klass.full_name) ||
          klass.dependencies.includes(anotherClass.full_name)
      })
    },
    isSelected(klass) {
      return this.graphSelectedClassesNames.includes(klass.full_name)
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
  min-width: 310px;
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

.clear-graph-button {
  position: absolute;
  right: 15px;
  top: 10px;
  z-index: 1;
}

.full-graph-button {
  position: absolute;
  right: 15px;
  top: 45px;
  z-index: 2;
}

.results-stats {
  text-align: center;
  margin-bottom: 10px;
  font-weight: bold;
}

.sort-radio {
  width: 100%;
  display: flex !important;
  justify-content: center;
}

.sort-by-label {
  text-align: center;
  font-weight: bold;
  line-height: 23px;
}
</style>
