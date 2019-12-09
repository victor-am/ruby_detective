<template>
  <div>
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
      max: 100,
      label: {
        min: 8,
        max: 30,
        drawThreshold: 12,
        maxVisible: 200
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
    smooth: {
      type: "continuous"
    }
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
    classesData: Array
  },
  data() {
    return {
      graph: {},
      nodesDataset: [],
      highlightActive: false
    }
  },

  mounted() {
    this.buildGraph()
  },

  computed: {
    dependencyGraphData() {
      const nodes = this.classesData.map((klass) => {

        return {
          id: klass.full_name,
          label: klass.full_name,
          value: klass.lines_of_code,
          group: klass.namespace
        }
      })

      const edges = this.classesData.map((klass) => {
        return klass.dependencies.map((dependency) => {
          return { from: klass.full_name, to: dependency }
        })
      }).flat()

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
      this.graph = new vis.Network(container, data, GRAPH_OPTIONS);
      this.graph.on("click", this.neighbourhoodHighlight);
    },

    neighbourhoodHighlight(params) {
      // if something is selected:
      if (params.nodes.length > 0) {
        this.highlightActive = true;
        var i, j;
        var selectedNode = params.nodes[0];
        var degrees = 2;

        // mark all nodes as hard to read.
        for (var nodeId in this.allNodes) {
          this.allNodes[nodeId].color = "rgba(200,200,200,0.5)";
          if (this.allNodes[nodeId].hiddenLabel === undefined) {
            this.allNodes[nodeId].hiddenLabel = this.allNodes[nodeId].label;
            this.allNodes[nodeId].label = undefined;
          }
        }
        var connectedNodes = this.graph.getConnectedNodes(selectedNode);
        var allConnectedNodes = [];

        // get the second degree nodes
        for (i = 1; i < degrees; i++) {
          for (j = 0; j < connectedNodes.length; j++) {
            allConnectedNodes = allConnectedNodes.concat(
              this.graph.getConnectedNodes(connectedNodes[j])
            );
          }
        }

        // all second degree nodes get a different color and their label back
        for (i = 0; i < allConnectedNodes.length; i++) {
          this.allNodes[allConnectedNodes[i]].color = "rgba(150,150,150,0.75)";
          if (this.allNodes[allConnectedNodes[i]].hiddenLabel !== undefined) {
            this.allNodes[allConnectedNodes[i]].label =
              this.allNodes[allConnectedNodes[i]].hiddenLabel;
            this.allNodes[allConnectedNodes[i]].hiddenLabel = undefined;
          }
        }

        // all first degree nodes get their own color and their label back
        for (i = 0; i < connectedNodes.length; i++) {
          this.allNodes[connectedNodes[i]].color = undefined;
          if (this.allNodes[connectedNodes[i]].hiddenLabel !== undefined) {
            this.allNodes[connectedNodes[i]].label =
              this.allNodes[connectedNodes[i]].hiddenLabel;
            this.allNodes[connectedNodes[i]].hiddenLabel = undefined;
          }
        }

        // the main node gets its own color and its label back.
        this.allNodes[selectedNode].color = undefined;
        if (this.allNodes[selectedNode].hiddenLabel !== undefined) {
          this.allNodes[selectedNode].label = this.allNodes[selectedNode].hiddenLabel;
          this.allNodes[selectedNode].hiddenLabel = undefined;
        }
      } else if (this.highlightActive === true) {
        // reset all nodes
        for (var nodeId2 in this.allNodes) {
          this.allNodes[nodeId2].color = undefined;
          if (this.allNodes[nodeId2].hiddenLabel !== undefined) {
            this.allNodes[nodeId2].label = this.allNodes[nodeId2].hiddenLabel;
            this.allNodes[nodeId2].hiddenLabel = undefined;
          }
        }
        this.highlightActive = false;
      }

      // transform the object into an array
      var updateArray = [];
      for (nodeId in this.allNodes) {
        if (this.allNodes.hasOwnProperty(nodeId)) {
          updateArray.push(this.allNodes[nodeId]);
        }
      }
      this.nodesDataset.update(updateArray);
    }
  }
}
</script>

<style scoped>
#dependency-graph {
  width: 1024px;
  height: 768px;
}
</style>
