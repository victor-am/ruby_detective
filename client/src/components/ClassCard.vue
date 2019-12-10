<template>
  <el-card>
    <div slot="header" class="clearfix">
      <h3>{{ classData.full_name }}</h3>
      <h4 class="sub-title">{{ classData.file_path }}</h4>
    </div>
    <div class="extra-info">
      <p>
        Lines of code:
        <strong> {{ classData.lines_of_code }}</strong>
      </p>
      <p>
        Dependencies:
        <strong>{{ classData.dependencies.length }}</strong>
      </p>
    </div>

    <el-button class="graph-button" type="text" icon="el-icon-share" @click="$emit('selectClass', classData)">
      Show graph
    </el-button>
  </el-card>
</template>

<script>
export default {
  name: 'ClassCard',
  props: {
    classData: Object
  },

  computed: {
  },

  methods: {
  }
}
</script>

<style scoped>
.class-item .extra-info {
  font-size: 14px;
  color: #555;
  display: flex;
  justify-content: space-between;
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
