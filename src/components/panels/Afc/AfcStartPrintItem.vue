<template>
  <div class="afc-start-print-item">
    <span class="tool-label">Tool {{ displayIndex }}</span>
    <span class="tool-material">{{ tool.material || 'Unknown' }}</span>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator'

@Component
export default class AfcStartPrintItem extends Vue {
  @Prop({ required: true }) tool!: any

  get displayIndex() {
    return this.tool.index ?? 0
  }
}
</script>

<style scoped>
.afc-start-print-item {
  display: flex;
  justify-content: space-between;
  padding: 4px 0;
}
.tool-label {
  font-weight: 500;
}
.tool-material {
  opacity: 0.8;
}
</style>

