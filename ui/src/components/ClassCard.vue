<template>
  <el-card>
    <div slot="header" class="clearfix">
      <h3>{{ classData.full_name }}</h3>
      <h4 class="sub-title">{{ classData.file_path }}</h4>
    </div>
    <div class="extra-info">
      <p>
        Dependencies:
        <span class="value">{{ classData.dependencies.length }}</span>
      </p>
      <p>
        Dependents:
        <span class="value">{{ classData.dependents.length }}</span>
      </p>
      <p>
        Lines of code:
        <span class="value">{{ classData.lines_of_code }}</span>
      </p>
    </div>

    <el-button class="graph-button" type="text" @click="$emit('selectClass', classData)">
      <GraphIcon/> Show graph
    </el-button>
  </el-card>
</template>

<script>
import GraphIcon from '@/assets/graph.svg';

export default {
  name: 'ClassCard',
  components: { GraphIcon },
  props: {
    classData: Object
  }
}
</script>

<style scoped>
.class-item .extra-info {
  font-size: 14px;
  color: #555;
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
  margin-bottom: 15px;
}
.extra-info p {
  margin: 5px;
  text-align: center;
}
.extra-info .value {
  font-weight: bold;
  font-size: 18px;
  display: block;
}
.graph-button {
  padding: 3px 0;
}
.sub-title {
  font-size: 12px;
  color: #666;
}
</style>
