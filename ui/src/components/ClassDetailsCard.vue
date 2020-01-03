<template>
  <el-card>
    <div slot="header" class="clearfix">
      <h3>{{ classData.full_name }}</h3>
      <h4 class="sub-title">{{ classData.file_path }}</h4>
    </div>
    <div class="extra-info">
      <h4>{{ classData.lines_of_code }} lines of code</h4>
      <h4>{{ classData.dependencies.length }} Dependencies:</h4>
      <h4>{{ classData.dependents.length }} Dependents:</h4>
    </div>

    <el-button class="graph-button" type="text" @click="$emit('selectClass', classData)">
      <GraphIcon/> Show graph
    </el-button>
  </el-card>
</template>

<script>
import GraphIcon from '@/assets/graph.svg';

export default {
  name: 'ClassDetailsCard',
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
  margin-bottom: 15px;
}

.graph-button {
  padding: 3px 0;
}

.sub-title {
  font-size: 12px;
  color: #666;
}
</style>
