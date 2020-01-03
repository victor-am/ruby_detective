<template>
  <div>
    <div class="graph-toolbar">
      <el-checkbox v-model="showSecundaryDependencies">Show secundary dependencies</el-checkbox>
    </div>

    <div id="dependency-graph"></div>
  </div>
</template>

<script>
import vis from 'vis-network'

const GRAPH_OPTIONS = {
  physics: {
    solver: "barnesHut",
    stabilization: false,
    barnesHut: { gravitationalConstant: -80000, springConstant: 0.001, springLength: 200 }
  },
  nodes: {
    shape: "dot",
    scaling: {
      min: 10,
      max: 50,
      label: {
        min: 30,
        max: 30,
        drawThreshold: 0,
        maxVisible: 0
      }
    },
    font: {
      size: 12,
      face: "Tahoma"
    }
  },
  edges: {
    width: 0.15,
    color: { inherit: "from" },
    smooth: false,
    arrows: 'to'
  },
  interaction: {
    tooltipDelay: 200,
    hideEdgesOnDrag: true,
    hideEdgesOnZoom: true
  }
}

export default {
  name: 'DependencyGraph',
  props: {
    classesData: Array,
    selectedClasses: Array
  },
  data() {
    return {
      graph: null,
      nodesDataset: [],
      highlightActive: false,
      showSecundaryDependencies: true
    }
  },

  mounted() {
    this.buildGraph()
  },

  watch: {
    dependencyGraphData() {
      this.buildGraph()
    }
  },

  computed: {
    dependencyGraphData() {
      const nodes = this.classesData.map((klass) => {
        return {
          id: klass.full_name,
          label: klass.full_name,
          title: klass.full_name,
          value: klass.lines_of_code,
          group: klass.namespace
        }
      })

      const edges = this.classesData.map((dependent) => {
        return dependent.dependencies.map((dependency_name) => {
          if (!this.showSecundaryDependencies && this.isSecundaryDependency(dependent.full_name, dependency_name)) {
            return null
          } else {
            return { from: dependent.full_name, to: dependency_name }
          }
        })
      }).flat().filter(n => n)

      return { nodes, edges }
    }
  },

  methods: {
    buildGraph() {
      const nodes = new vis.DataSet(this.dependencyGraphData.nodes);
      const edges = new vis.DataSet(this.dependencyGraphData.edges);
      const container = document.getElementById("dependency-graph");
      const data = { nodes, edges }

      this.nodesDataset = nodes

      if (this.graph) { this.graph.destroy() }
      this.graph = new vis.Network(container, data, GRAPH_OPTIONS);
      this.graph.moveTo({ scale: 0.5, offset: { x: 200, y: 0 }})
    },

    isSecundaryDependency(dependent_name, dependency_name) {
      const selectedClasses = this.selectedClasses.map((c) => c.full_name)
      return !selectedClasses.includes(dependency_name) && !selectedClasses.includes(dependent_name)
    }
  }
}
</script>

<style scoped>
#dependency-graph {
  width: 100%;
  height: 100%;
}

.graph-toolbar {
  position: absolute;
  top: 80px;
  width: 100%;
  right: 15px;
  z-index: 3;
}

.graph-toolbar .el-checkbox {
  float: right;
}
</style>
