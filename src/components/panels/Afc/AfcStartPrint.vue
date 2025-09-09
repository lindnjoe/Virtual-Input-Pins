<template>
  <div class="afc-start-print">
    <afc-start-print-item
      v-for="(tool, idx) in tools"
      :key="idx"
      :tool="tool"
    />
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator'
import AfcStartPrintItem from '@/components/panels/Afc/AfcStartPrintItem.vue'

@Component({
  components: { AfcStartPrintItem },
})
export default class AfcStartPrint extends Vue {
  @Prop({ required: true }) file!: any

  get tools() {
    return this.file?.analysis?.tools ?? []
  }

  mounted() {
    this.$emit('tool-count', this.tools.length > 0)
  }
}
</script>

<style scoped>
.afc-start-print {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
</style>

