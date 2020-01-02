<template>
  <div>
    <div class="graph-toolbar">
      <el-button size="mini" @click="onlyDirectEdges = !onlyDirectEdges">Toggle secundary dependencies</el-button>
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
    selectedClass: String
  },
  data() {
    return {
      graph: { destroy: () => {} },
      nodesDataset: [],
      highlightActive: false,
      onlyDirectEdges: false
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

      const edges = this.classesData.map((klass) => {
        return klass.dependencies.map((dependency) => {
          if (this.onlyDirectEdges && (dependency != this.selectedClass && klass.full_name != this.selectedClass)) {
            return null
          } else {
            return { from: klass.full_name, to: dependency }
          }
        })
      }).flat().filter(n => n)

      return { nodes, edges }
    },

    allNodes() {
      return this.nodesDataset.get({ returnType: "Object" })
    }
  },

  methods: {
    buildGraph() {
      const nodes = new vis.DataSet(this.dependencyGraphData.nodes);
      const edges = new vis.DataSet(this.dependencyGraphData.edges);
      const container = document.getElementById("dependency-graph");
      const data = { nodes, edges }

      this.nodesDataset = nodes
      this.graph.destroy()
      this.graph = new vis.Network(container, data, GRAPH_OPTIONS);
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
  top: 50px;
  width: 100%;
  right: 15px;
  z-index: 3;
}

.graph-toolbar .el-button {
  float: right;
}
</style>
